codeunit 50303 "POS Settlement"
{
    Permissions = tabledata "Gen. Journal Line" = rimd;
    TableNo = "POS Transaction Header";

    trigger OnRun()
    var
        POSPaymentLine: Record "POS Payment Line";
        POSSetup: Record "POS Setup";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLineToPost: Record "Gen. Journal Line";
        NextLineNo: Integer;
        SettlementAmount: Decimal;
        RemainingChange: Decimal;
    begin
        POSSetup.Reset();
        POSSetup.Get('POS');
        POSSetup.TestField("Settlement Jnl. Template");
        POSSetup.TestField("Settlement Jnl. Batch");
        ValidateSettlementDocument(Rec);

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", POSSetup."Settlement Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", POSSetup."Settlement Jnl. Batch");
        GenJournalLine.SetRange("Document No.", Rec."No.");
        if GenJournalLine.FindFirst() then
            GenJournalLine.DeleteAll();

        // For sales: subtract change from cash payments so we only settle the actual sale amount
        Rec.CalcFields("Total Amount");
        RemainingChange := Rec."Change Amount";

        NextLineNo := GetNextLineNo(POSSetup."Settlement Jnl. Template", POSSetup."Settlement Jnl. Batch");
        POSPaymentLine.SetRange("Document No.", Rec."No.");
        if POSPaymentLine.FindSet() then
            repeat
                SettlementAmount := POSPaymentLine.Amount;

                // Deduct change from cash payments (customer gets change back, not posted)
                if (Rec."Transaction Type" = Rec."Transaction Type"::Sale) and
                   (POSPaymentLine."Payment Method" = POSPaymentLine."Payment Method"::Cash) and
                   (RemainingChange > 0) then begin
                    if RemainingChange >= SettlementAmount then begin
                        RemainingChange -= SettlementAmount;
                        SettlementAmount := 0;
                    end else begin
                        SettlementAmount -= RemainingChange;
                        RemainingChange := 0;
                    end;
                end;

                if SettlementAmount > 0 then begin
                    InsertSettlementLine(Rec, POSPaymentLine, POSSetup, NextLineNo, GenJournalLineToPost, SettlementAmount);
                    NextLineNo += 10000;
                end;
            until POSPaymentLine.Next() = 0;

        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLineToPost);
    end;

    procedure SettleTransaction(var POSTransactionHeader: Record "POS Transaction Header")
    var
        POSSettlement: Codeunit "POS Settlement";
    begin
        if POSTransactionHeader.Status <> POSTransactionHeader.Status::Posted then
            Error('POS transaction %1 must be posted before settlement.', POSTransactionHeader."No.");

        if POSTransactionHeader."Settlement Status" = POSTransactionHeader."Settlement Status"::Settled then
            exit;

        Commit();
        if not POSSettlement.Run(POSTransactionHeader) then begin
            POSTransactionHeader.Get(POSTransactionHeader."No.");
            POSTransactionHeader."Settlement Status" := POSTransactionHeader."Settlement Status"::Failed;
            POSTransactionHeader."Settlement Error" := CopyStr(GetLastErrorText(), 1, MaxStrLen(POSTransactionHeader."Settlement Error"));
            POSTransactionHeader.Modify(true);
            Error('Settlement failed for POS transaction %1. %2', POSTransactionHeader."No.", GetLastErrorText());
        end;

        POSTransactionHeader.Get(POSTransactionHeader."No.");
        POSTransactionHeader."Settlement Status" := POSTransactionHeader."Settlement Status"::Settled;
        POSTransactionHeader."Settled At" := CurrentDateTime;
        Clear(POSTransactionHeader."Settlement Error");
        POSTransactionHeader.Modify(true);
    end;

    local procedure ValidateSettlementDocument(var POSTransactionHeader: Record "POS Transaction Header")
    begin
        POSTransactionHeader.TestField("Customer No.");

        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then
            POSTransactionHeader.TestField("Posted Sales Invoice No.")
        else
            POSTransactionHeader.TestField("Posted Sales Cr. Memo No.");
    end;

    local procedure InsertSettlementLine(var POSTransactionHeader: Record "POS Transaction Header"; var POSPaymentLine: Record "POS Payment Line"; var POSSetup: Record "POS Setup"; LineNo: Integer; var GenJournalLineToPost: Record "Gen. Journal Line"; SettlementAmount: Decimal)
    var
        TenderSetup: Record "POS Tender Setup";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        ResolveTenderSetup(POSPaymentLine."Payment Method", TenderSetup);

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := POSSetup."Settlement Jnl. Template";
        GenJournalLine."Journal Batch Name" := POSSetup."Settlement Jnl. Batch";
        GenJournalLine."Line No." := LineNo;
        GenJournalLine.Validate("Posting Date", POSTransactionHeader."Posting Date");
        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment)
        else
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Refund);
        GenJournalLine.Validate("Document No.", POSTransactionHeader."No.");
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.Validate("Account No.", POSTransactionHeader."Customer No.");

        if TenderSetup."Bal. Account Type" = TenderSetup."Bal. Account Type"::"G/L Account" then
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account")
        else
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.Validate("Bal. Account No.", TenderSetup."Bal. Account No.");

        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then begin
            GenJournalLine.Validate(Amount, -SettlementAmount);
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
            GenJournalLine.Validate("Applies-to Doc. No.", POSTransactionHeader."Posted Sales Invoice No.");
        end else begin
            GenJournalLine.Validate(Amount, SettlementAmount);
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::"Credit Memo");
            GenJournalLine.Validate("Applies-to Doc. No.", POSTransactionHeader."Posted Sales Cr. Memo No.");
        end;

        GenJournalLine.Validate("Shortcut Dimension 1 Code", POSTransactionHeader."Shortcut Dimension 1 Code");
        GenJournalLine.Validate("Shortcut Dimension 2 Code", POSTransactionHeader."Shortcut Dimension 2 Code");
        if POSTransactionHeader."Dimension Set ID" <> 0 then
            GenJournalLine.Validate("Dimension Set ID", POSTransactionHeader."Dimension Set ID");
        GenJournalLine.Description := CopyStr(StrSubstNo('POS %1 %2', Format(POSPaymentLine."Payment Method"), POSTransactionHeader."No."), 1, MaxStrLen(GenJournalLine.Description));
        GenJournalLine."External Document No." := CopyStr(GetExternalDocumentNo(POSTransactionHeader, POSPaymentLine), 1, MaxStrLen(GenJournalLine."External Document No."));
        GenJournalLine."System-Created Entry" := true;
        GenJournalLine.Insert(true);

        GenJournalLineToPost := GenJournalLine;
    end;

    local procedure ResolveTenderSetup(PaymentMethod: Option Cash,Card,Mobile; var TenderSetup: Record "POS Tender Setup")
    begin
        TenderSetup.SetRange("Payment Method", PaymentMethod);
        TenderSetup.SetRange(Active, true);
        if not TenderSetup.FindFirst() then
            Error('POS Tender Setup is missing for payment method %1.', Format(PaymentMethod));

        TenderSetup.TestField("Bal. Account No.");
    end;

    local procedure GetNextLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetExternalDocumentNo(var POSTransactionHeader: Record "POS Transaction Header"; var POSPaymentLine: Record "POS Payment Line"): Text[50]
    begin
        if POSPaymentLine."Reference No." <> '' then
            exit(POSPaymentLine."Reference No.");

        exit(POSTransactionHeader."No.");
    end;
}
