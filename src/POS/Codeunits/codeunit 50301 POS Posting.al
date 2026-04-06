codeunit 50301 "POS Posting"
{
    procedure LoadReturnLines(var POSTransactionHeader: Record "POS Transaction Header")
    var
        SourceTransactionHeader: Record "POS Transaction Header";
        SourceTransactionLine: Record "POS Transaction Line";
        TargetTransactionLine: Record "POS Transaction Line";
        NextLineNo: Integer;
        ReturnableQty: Decimal;
    begin
        POSTransactionHeader.TestField("Transaction Type", POSTransactionHeader."Transaction Type"::Return);
        POSTransactionHeader.TestField("Original Receipt No.");

        SourceTransactionHeader.Get(POSTransactionHeader."Original Receipt No.");
        SourceTransactionHeader.TestField(Status, SourceTransactionHeader.Status::Posted);
        POSTransactionHeader.Validate("Customer No.", SourceTransactionHeader."Customer No.");

        TargetTransactionLine.SetRange("Document No.", POSTransactionHeader."No.");
        if TargetTransactionLine.FindFirst() then
            TargetTransactionLine.DeleteAll();

        NextLineNo := 10000;
        SourceTransactionLine.SetRange("Document No.", SourceTransactionHeader."No.");
        if SourceTransactionLine.FindSet() then
            repeat
                ReturnableQty := GetRemainingReturnQtyFromPostedReturns(SourceTransactionHeader."No.", SourceTransactionLine."Line No.");
                if ReturnableQty > 0 then begin
                    TargetTransactionLine.Init();
                    TargetTransactionLine."Document No." := POSTransactionHeader."No.";
                    TargetTransactionLine."Line No." := NextLineNo;
                    TargetTransactionLine.Insert(true);
                    TargetTransactionLine.Validate("Item No.", SourceTransactionLine."Item No.");
                    TargetTransactionLine.Validate(Quantity, ReturnableQty);
                    TargetTransactionLine.Validate("Unit Price", SourceTransactionLine."Unit Price");
                    TargetTransactionLine.Validate("Line Discount %", SourceTransactionLine."Line Discount %");
                    TargetTransactionLine.SetOriginalPricingBaseline();
                    TargetTransactionLine."Original Receipt Line No." := SourceTransactionLine."Line No.";
                    TargetTransactionLine.Modify(true);
                    NextLineNo += 10000;
                end;
            until SourceTransactionLine.Next() = 0;

        TargetTransactionLine.Reset();
        TargetTransactionLine.SetRange("Document No.", POSTransactionHeader."No.");
        if not TargetTransactionLine.FindFirst() then
            Error('Receipt %1 has no remaining returnable quantities.', POSTransactionHeader."Original Receipt No.");

        POSTransactionHeader.UpdateCalculatedAmounts();
    end;

    procedure ApproveReturn(var POSTransactionHeader: Record "POS Transaction Header")
    var
        ApprovalDialog: Page "POS Approval Dialog";
        POSSecurity: Codeunit "POS Security";
        SupervisorUserId: Code[50];
        ApprovalPin: Code[20];
        ApprovalReason: Text[100];
    begin
        POSTransactionHeader.TestField("Transaction Type", POSTransactionHeader."Transaction Type"::Return);
        if ApprovalDialog.RunModal() <> Action::OK then
            exit;

        SupervisorUserId := ApprovalDialog.GetSupervisorUserId();
        ApprovalPin := ApprovalDialog.GetApprovalPin();
        ApprovalReason := ApprovalDialog.GetReason();

        POSSecurity.ValidateSupervisorAuthorization(SupervisorUserId, ApprovalPin);
        if ApprovalReason = '' then
            Error('Reason is required for POS return approval.');

        POSTransactionHeader."Approved By" := SupervisorUserId;
        POSTransactionHeader."Approved At" := CurrentDateTime;
        POSTransactionHeader."Approval Reason" := ApprovalReason;
        POSTransactionHeader.Status := POSTransactionHeader.Status::Approved;
        POSTransactionHeader.Modify(true);
    end;

    procedure PostTransaction(var POSTransactionHeader: Record "POS Transaction Header")
    var
        SalesHeader: Record "Sales Header";
        POSPaymentLine: Record "POS Payment Line";
        POSManagement: Codeunit "POS Management";
        POSSettlement: Codeunit "POS Settlement";
        POSSetup: Record "POS Setup";
    begin
        POSManagement.ValidateTransaction(POSTransactionHeader);
        ValidatePostingPrerequisites(POSTransactionHeader);

        CreateSalesHeader(POSTransactionHeader, SalesHeader);
        CreateSalesLines(POSTransactionHeader, SalesHeader);

        POSTransactionHeader."Sales Document No." := SalesHeader."No.";
        POSTransactionHeader.Modify(true);

        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);

        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then
            POSTransactionHeader."Posted Sales Invoice No." := FindPostedInvoiceNo(POSTransactionHeader."No.")
        else
            POSTransactionHeader."Posted Sales Cr. Memo No." := FindPostedCreditMemoNo(POSTransactionHeader."No.");

        POSTransactionHeader.Status := POSTransactionHeader.Status::Posted;
        POSTransactionHeader."Posted At" := CurrentDateTime;
        POSTransactionHeader.Modify(true);

        POSPaymentLine.SetRange("Document No.", POSTransactionHeader."No.");
        if POSPaymentLine.FindSet() then
            repeat
                POSPaymentLine.ValidateLine();
            until POSPaymentLine.Next() = 0;

        POSSetup.Reset();
        if POSSetup.Get('POS') then
            if POSSetup."Auto Post Settlement" then
                POSSettlement.SettleTransaction(POSTransactionHeader);
    end;

    local procedure ValidatePostingPrerequisites(var POSTransactionHeader: Record "POS Transaction Header")
    var
        POSSetup: Record "POS Setup";
    begin
        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then
            POSTransactionHeader.TestField(Status, POSTransactionHeader.Status::Open)
        else
            if not (POSTransactionHeader.Status in [POSTransactionHeader.Status::Open, POSTransactionHeader.Status::Approved]) then
                Error('Return transaction %1 must be Open or Approved before posting.', POSTransactionHeader."No.");
        POSSetup.Reset();
        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Return then begin
            if POSSetup.Get('POS') and POSSetup."Require Return Approval" then begin
                POSTransactionHeader.TestField("Approved By");
                POSTransactionHeader.TestField(Status, POSTransactionHeader.Status::Approved);
            end;

            ValidateReturnQuantities(POSTransactionHeader);
        end;

        ValidateLineOverrides(POSTransactionHeader, POSSetup);
    end;

    local procedure CreateSalesHeader(var POSTransactionHeader: Record "POS Transaction Header"; var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SalesSetup.Get();
        SalesHeader.Init();
        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then begin
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesSetup.TestField("Invoice Nos.");
            SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesSetup."Invoice Nos.", POSTransactionHeader."Posting Date", true);
        end else begin
            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
            SalesSetup.TestField("Credit Memo Nos.");
            SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesSetup."Credit Memo Nos.", POSTransactionHeader."Posting Date", true);
        end;

        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", POSTransactionHeader."Customer No.");
        SalesHeader.Validate("Bill-to Customer No.", POSTransactionHeader."Customer No.");
        SalesHeader.Validate("Posting Date", POSTransactionHeader."Posting Date");
        SalesHeader.Validate("Document Date", POSTransactionHeader."Posting Date");
        SalesHeader.Validate("External Document No.", CopyStr(POSTransactionHeader."No.", 1, MaxStrLen(SalesHeader."External Document No.")));
        SalesHeader."Your Reference" := POSTransactionHeader."POS Terminal Code";
        SalesHeader.Validate("Shortcut Dimension 1 Code", POSTransactionHeader."Shortcut Dimension 1 Code");
        SalesHeader.Validate("Shortcut Dimension 2 Code", POSTransactionHeader."Shortcut Dimension 2 Code");
        if POSTransactionHeader."Dimension Set ID" <> 0 then
            SalesHeader.Validate("Dimension Set ID", POSTransactionHeader."Dimension Set ID");
        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLines(var POSTransactionHeader: Record "POS Transaction Header"; var SalesHeader: Record "Sales Header")
    var
        POSTransactionLine: Record "POS Transaction Line";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        LineNo := 10000;
        POSTransactionLine.SetRange("Document No.", POSTransactionHeader."No.");
        if POSTransactionLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineNo;
                SalesLine.Insert(true);
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", POSTransactionLine."Item No.");
                if POSTransactionLine."Location Code" <> '' then
                    SalesLine.Validate("Location Code", POSTransactionLine."Location Code");
                SalesLine.Validate(Quantity, POSTransactionLine.Quantity);
                SalesLine.Validate("Unit Price", POSTransactionLine."Unit Price");
                SalesLine.Validate("Line Discount %", POSTransactionLine."Line Discount %");
                SalesLine.Validate("Shortcut Dimension 1 Code", POSTransactionLine."Shortcut Dimension 1 Code");
                SalesLine.Validate("Shortcut Dimension 2 Code", POSTransactionLine."Shortcut Dimension 2 Code");
                if POSTransactionLine."Dimension Set ID" <> 0 then
                    SalesLine.Validate("Dimension Set ID", POSTransactionLine."Dimension Set ID");
                SalesLine.Modify(true);
                LineNo += 10000;
            until POSTransactionLine.Next() = 0;
    end;

    local procedure ValidateReturnQuantities(var POSTransactionHeader: Record "POS Transaction Header")
    var
        POSTransactionLine: Record "POS Transaction Line";
        RemainingReturnQty: Decimal;
    begin
        POSTransactionLine.SetRange("Document No.", POSTransactionHeader."No.");
        if POSTransactionLine.FindSet() then
            repeat
                if POSTransactionLine."Original Receipt Line No." = 0 then
                    Error('Return line %1 must be loaded from the original receipt.', POSTransactionLine."Line No.");

                RemainingReturnQty := GetRemainingReturnQty(POSTransactionHeader."Original Receipt No.", POSTransactionLine."Original Receipt Line No.", POSTransactionHeader."No.");
                if POSTransactionLine.Quantity > RemainingReturnQty then
                    Error(
                      'Return quantity for item %1 exceeds the remaining returnable quantity. Remaining: %2, Entered: %3.',
                      POSTransactionLine."Item No.", RemainingReturnQty, POSTransactionLine.Quantity);
            until POSTransactionLine.Next() = 0;
    end;

    local procedure ValidateLineOverrides(var POSTransactionHeader: Record "POS Transaction Header"; var POSSetup: Record "POS Setup")
    var
        POSTransactionLine: Record "POS Transaction Line";
        ApprovalRequired: Boolean;
    begin
        POSSetup.Reset();
        if not POSSetup.Get('POS') then
            exit;

        if not (POSSetup."Require Price Override" or POSSetup."Require Discount Approval") then
            exit;

        POSTransactionLine.SetRange("Document No.", POSTransactionHeader."No.");
        if POSTransactionLine.FindSet() then
            repeat
                ApprovalRequired :=
                  (POSSetup."Require Price Override" and POSTransactionLine.HasPriceOverride()) or
                  (POSSetup."Require Discount Approval" and POSTransactionLine.HasDiscountOverride());

                if ApprovalRequired then begin
                    POSTransactionLine.TestField("Override Approved", true);
                    POSTransactionLine.TestField("Price Override Approved By");
                    POSTransactionLine.TestField("Override Approved At");
                    POSTransactionLine.TestField("Override Reason");
                end;
            until POSTransactionLine.Next() = 0;
    end;

    local procedure GetRemainingReturnQtyFromPostedReturns(OriginalReceiptNo: Code[20]; OriginalReceiptLineNo: Integer): Decimal
    begin
        exit(GetRemainingReturnQty(OriginalReceiptNo, OriginalReceiptLineNo, ''));
    end;

    local procedure GetRemainingReturnQty(OriginalReceiptNo: Code[20]; OriginalReceiptLineNo: Integer; CurrentDocumentNo: Code[20]): Decimal
    var
        SourceLine: Record "POS Transaction Line";
        ReturnHeader: Record "POS Transaction Header";
        ReturnLine: Record "POS Transaction Line";
        SoldQty: Decimal;
        ReturnedQty: Decimal;
    begin
        SourceLine.SetRange("Document No.", OriginalReceiptNo);
        SourceLine.SetRange("Line No.", OriginalReceiptLineNo);
        if not SourceLine.FindFirst() then
            exit(0);

        SoldQty := SourceLine.Quantity;

        ReturnHeader.SetRange("Original Receipt No.", OriginalReceiptNo);
        ReturnHeader.SetRange("Transaction Type", ReturnHeader."Transaction Type"::Return);
        ReturnHeader.SetRange(Status, ReturnHeader.Status::Posted);
        if ReturnHeader.FindSet() then
            repeat
                ReturnLine.SetRange("Document No.", ReturnHeader."No.");
                ReturnLine.SetRange("Original Receipt Line No.", OriginalReceiptLineNo);
                if ReturnLine.FindSet() then
                    repeat
                        ReturnedQty += ReturnLine.Quantity;
                    until ReturnLine.Next() = 0;
            until ReturnHeader.Next() = 0;

        if CurrentDocumentNo <> '' then begin
            ReturnLine.Reset();
            ReturnLine.SetRange("Document No.", CurrentDocumentNo);
            ReturnLine.SetRange("Original Receipt Line No.", OriginalReceiptLineNo);
            if ReturnLine.FindSet() then
                repeat
                    ReturnedQty -= ReturnLine.Quantity;
                until ReturnLine.Next() = 0;
        end;

        exit(SoldQty - ReturnedQty);
    end;

    local procedure FindPostedInvoiceNo(ExternalDocumentNo: Code[20]): Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesInvoiceHeader.FindLast() then
            exit(SalesInvoiceHeader."No.");
    end;

    local procedure FindPostedCreditMemoNo(ExternalDocumentNo: Code[20]): Code[20]
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        SalesCrMemoHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesCrMemoHeader.FindLast() then
            exit(SalesCrMemoHeader."No.");
    end;
}
