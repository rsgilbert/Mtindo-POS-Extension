codeunit 50001 "Subscriber"
{
    Permissions = tabledata "Purch. Inv. Line" = m, tabledata "Purch. Cr. Memo Line" = m;
    // tabledata "Payment Requisition Header" = r,
    // tabledata "Accountability Header" = r;

    trigger OnRun()
    begin

    end;

    // [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterPreparePurchase', '', true, true)]
    // local procedure AddCustomFields(var PurchaseLine: Record "Purchase Line"; var InvoicePostingBuffer: Record "Invoice Post. Buffer" temporary)
    // begin
    //     InvoicePostingBuffer."Work Plan Entry No" := PurchaseLine."Work Plan Entry No.";
    //     InvoicePostingBuffer."Budget Set ID" := PurchaseLine."Budget Set ID";
    //     InvoicePostingBuffer."Budget Control A/C" := PurchaseLine."Budget Control A/C";
    //     InvoicePostingBuffer."Work Plan" := PurchaseLine."Work Plan";
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    // local procedure CopyCustomFieldsToGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
    // begin
    //     GenJnlLine."Work Plan Entry No." := InvoicePostingBuffer."Work Plan Entry No";
    //     GenJnlLine."Budget Name" := InvoicePostingBuffer."Budget Name";
    //     GenJnlLine."Work Plan" := InvoicePostingBuffer."Work Plan";
    //     GenJnlLine."Budget Control A/C" := InvoicePostingBuffer."Budget Control A/C";
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]

    local procedure CopyFromHeaderToJnl(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Work Plan" := PurchaseHeader."Work Plan";
        GenJournalLine."Budget Name" := PurchaseHeader."Budget Code";
        //GenJournalLine."Purchase Requisition No." := PurchaseHeader."Purchase Requisition No.";
        GenJournalLine.Payee := PurchaseHeader."Buy-from Vendor Name";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', true, true)]
    local procedure GenJournalLinePosting(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var

    begin
        if not GlobalGLEntry.Reversed then begin
            GlobalGLEntry."Budget Name" := GenJournalLine."Budget Name";
            GlobalGLEntry."Work Plan" := GenJournalLine."Work Plan";
            GlobalGLEntry."Work Plan Entry No." := GenJournalLine."Work Plan Entry No.";
            GlobalGLEntry."Budget Set ID" := GenJournalLine."Budget Set ID";
        end;
        //GlobalGLEntry."Purchase Requisition No." := GenJournalLine."Purchase Requisition No.";
        //GlobalGLEntry."Payment Req. Line No." := GenJournalLine."Payment Req. Line No.";
        GlobalGLEntry.Payee := GenJournalLine.Payee;
    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCustLedgEntryInsert, '', false, false)]
    // local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    // begin
    //     CustLedgerEntry."Payment Requisition No." := GenJournalLine."Payment Requisition No.";
    //     CustLedgerEntry."Payment Req. Line No." := GenJournalLine."Payment Req. Line No.";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptHeader', '', true, true)]
    local procedure CheckMandatoryGRN(var PurchHeader: Record "Purchase Header")
    var
        PostedPurchInvoice: Record "Purch. Inv. Header";
    begin
        IF (PurchHeader."Vendor Shipment No." = '') AND (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) then
            Error('Delivery note No/Job No is required');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure CheckMandatory(var PurchaseHeader: Record "Purchase Header")
    var
        lvPurchLine: Record "Purchase Line";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            if PurchaseHeader.Invoice then begin
                PurchaseHeader.TestField("Posting Date");
                PurchaseHeader.TestNoSeries();
                // Part for with holding tax

                // lvPurchLine.Reset();
                // lvPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
                // lvPurchLine.SetRange("Document No.", PurchaseHeader."No.");
                // if lvPurchLine.FindSet() then
                //     repeat
                //         lvPurchLine.TestField("WHT Prod. Posting Group");
                //     until lvPurchLine.Next() = 0;
            end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostInvoice', '', true, true)]
    // local procedure ClearPostingDate(var PurchHeader: Record "Purchase Header")
    // begin
    //     PurchHeader."Posting Date" := 0D;
    //     Clear(PurchHeader."Vendor Invoice No.");
    //     Clear(PurchHeader."Vendor Shipment No.");
    //     Clear(PurchHeader."Received By");
    //     Clear(PurchHeader."Checked By");
    //     Clear(PurchHeader."Check Date");
    //     Clear(PurchHeader."Receipt Date");

    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertReceiptHeader', '', true, true)]
    // local procedure ClearDeliveryDetails(var PurchHeader: Record "Purchase Header")
    // begin
    //     Clear(PurchHeader."Vendor Shipment No.");
    //     Clear(PurchHeader."Received By");
    //     Clear(PurchHeader."Checked By");
    //     Clear(PurchHeader."Check Date");
    //     Clear(PurchHeader."Receipt Date");
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchaseLine: Record "Purchase Line";
        // lvEmailMessage: Codeunit "Email Message";
        // lvEmailSend: Codeunit Email;
        EmailSmtp: Codeunit "SMTP Mail";
        SenderMail: Text[2048];
        RecepientMail: Text[2048];
        Subject: Text[2048];
        Body: Text;
        lvCountReceivedItems: Integer;
    begin
        //send Receipt notifications
        Clear(Body);
        clear(Subject);
        Clear(lvCountReceivedItems);
        if PurchRcptHeader."No." <> '' then begin
            Subject := 'Receipt of items on LPO ' + PurchHeader."No." + '.';
            Body := '</br>';
            // Body += 'Dear ' + PurchHeader."Requestor Name" + ', <br> <br>';
            Body += 'Kindly be informed that the items below on your purchase order ' + PurchHeader."No." + ' have been delivered in the store' + '</br>';
            Body += '<table border = "1",border-collapse = collapse>';
            Body += '<tr><td Colspan ="4"><b>Details</b></td></tr>';
            Body += '<tr><td><b>Type</b></td><td><b>Item Code</b></td><td><b>Description</b></td><td><b>Quatity Ordered</b></td><td><b>Received Quantity</b></td></tr>';

            PurchaseLine.Reset();
            PurchaseLine.SetRange(PurchaseLine."Document No.", PurchHeader."No.");
            PurchaseLine.Setfilter(PurchaseLine."Quantity Received", '<>%1', 0);
            If PurchaseLine.FindSet() then
                repeat
                    lvCountReceivedItems += 1;
                    Body += '<tr><td>' + Format(PurchaseLine.Type) + '</td><td>' + PurchaseLine."No." + '</td><td>' + PurchaseLine."Description 2" + '</td><td>' + FORMAT(PurchaseLine.Quantity) + '</td><td>' + FORMAT(PurchaseLine."Quantity Received") + '</td></tr>';
                until PurchaseLine.Next() = 0;

            Body += '</table>';
            Body += '</br></br>';
            Body += 'Warm Regards <br>';
            Body += '';
            //  EmailSmtp.CreateMessage('UPMB ERP', 'ekk@hrpsolutions.com', PurchHeader."Requested By Email", Subject, Body, true);

            // if (PurchHeader."Requested By Email" <> '') and (lvCountReceivedItems > 0) then
            EmailSmtp.Send();
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    // local procedure InsertFieldsToVendorLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    // begin
    // VendorLedgerEntry."Purchase Requisition No" := GenJournalLine."Purchase Requisition No.";
    // VendorLedgerEntry."Work Plan No" := GenJournalLine."Work Plan";
    // VendorLedgerEntry."Budget Code" := GenJournalLine."Budget Name";
    //end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVATEntry', '', false, false)]
    local procedure InsertFieldsToVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        // VATEntry."Purchase Requisition No" := GenJournalLine."Purchase Requisition No.";
        // VATEntry."Work Plan No" := GenJournalLine."Work Plan";
        // VATEntry."Budget Code" := GenJournalLine."Budget Name";
    end;

    // 2. Get the reason for reversal and save it in the reversal description table using transaction no as the related field.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnBeforeReverse', '', false, false)]
    local procedure OnBeforeReverse(var ReversalEntry2: Record "Reversal Entry"; var ReversalEntry: Record "Reversal Entry")
    var
        CommentLine: Record "Comment Line";
        TransactNo: Code[20];
    begin
        TransactNo := Format(ReversalEntry2."Transaction No.");
        CommentLine.SetRange("No.", TransactNo);
        IF NOT CommentLine.FindFirst() then;
        //Error('Reversal comment is required');
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnAfterStorePurchDocument', '', false, false)]
    // local procedure ArchivePurchaseOrder(var PurchaseHeader: Record "Purchase Header")
    // begin
    //     PurchaseHeader.Archived := true;
    //     PurchaseHeader.Modify();
    //     if PurchaseHeader.Archived then
    //         PurchaseHeader.Delete(true);
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure InsertFieldsToBankAcctLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        // BankAccountLedgerEntry.Payee := GenJournalLine.Payee;
        BankAccountLedgerEntry."External Document No." := GenJournalLine."External Document No.";
    end;

    //For AP Posting
    // [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', true, true)]
    // procedure GroupPurchBuffer(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    // begin
    //     InvoicePostingBuffer."Additional Grouping Identifier" := format(PurchaseLine."Line No.", 0, 2);
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterRecreatePurchLine', '', false, false)]
    local procedure OnAfterRecreatePurchLine(var PurchLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ConvertedAmt: Decimal;
    begin
        // PurchaseHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
        // PurchLine.Validate("Work Plan", TempPurchLine."Work Plan");
        // PurchLine.Validate("Budget Name", TempPurchLine."Budget Name");
        // PurchLine.Validate("Work Plan Entry No.", TempPurchLine."Work Plan Entry No.");
        // PurchLine.Validate("Budget Control A/C", TempPurchLine."Budget Control A/C");
        // PurchLine.Description := TempPurchLine.Description;
        // PurchLine."Original Requisition Amount" := TempPurchLine."Original Requisition Amount";
        // PurchLine.Status := PurchLine.Status::"Pending Approval";
        // //PurchLine."Outstand. Amt. Not Invd.(LCY)" := PurchLine."Unit Cost (LCY)" * PurchLine.Quantity;
        // PurchLine.Validate(Quantity, TempPurchLine.Quantity);
        // ConvertedAmt := CurrExchRate.ExchangeAmount(TempPurchLine."Direct Unit Cost", TempPurchLine."Currency Code", PurchaseHeader."Currency Code", PurchaseHeader."Posting Date");
        // PurchLine.Validate("Direct Unit Cost", ConvertedAmt);
        // PurchLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header")
    begin
        // if PurchInvHeader."Currency Factor" <> 0 then begin
        //     PurchInvLine."Amount (LCY)" := PurchInvLine.Amount / PurchInvHeader."Currency Factor";
        //     PurchInvLine."Amount Inc. VAT (LCY)" := PurchInvLine."Amount Including VAT" / PurchInvHeader."Currency Factor";
        // end
        // else begin
        //     PurchInvLine."Amount (LCY)" := PurchInvLine.Amount;
        //     PurchInvLine."Amount Inc. VAT (LCY)" := PurchInvLine."Amount Including VAT";
        // end;
        // PurchInvLine.Modify();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoLineInsert', '', false, false)]
    // local procedure OnAfterPurchCrMemoLineInsert(var PurchCrMemoLine: Record "Purch. Cr. Memo Line"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    // begin
    //     if PurchCrMemoHdr."Currency Factor" <> 0 then begin
    //         PurchCrMemoLine."Amount (LCY)" := PurchCrMemoLine.Amount / PurchCrMemoHdr."Currency Factor";
    //         PurchCrMemoLine."Amount Inc. VAT (LCY)" := PurchCrMemoLine."Amount Including VAT" / PurchCrMemoHdr."Currency Factor";
    //     end else begin
    //         PurchCrMemoLine."Amount (LCY)" := PurchCrMemoLine.Amount;
    //         PurchCrMemoLine."Amount Inc. VAT (LCY)" := PurchCrMemoLine."Amount Including VAT";
    //     end;
    //     PurchCrMemoLine.Modify();
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingAmount', '', false, false)]
    // local procedure OnAfterInitOutstandingAmount(var PurchLine: Record "Purchase Line")
    // begin
    //     PurchLine."Outstand. Amt. Not Invd." := PurchLine."Amt. Rcd. Not Invoiced" + PurchLine."Outstanding Amount";
    //     PurchLine."Outstand. Amt. Not Invd.(LCY)" := PurchLine."Amt. Rcd. Not Invoiced (LCY)" + PurchLine."Outstanding Amount (LCY)";
    // end;

    // //Hide dialog at the point of posting a payment requisition.
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', false, false)]
    // local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    // var
    //     PaymentReqHeader: Record "Payment Requisition Header";
    //     AccountabilityHeader: Record "Accountability Header";
    //     GenLedgerSetup: Record "General Ledger Setup";
    //     lvGLAccount: Record "G/L Account";
    // begin
    //     GenLedgerSetup.get();
    //     //If Budget checks are enabled for General Journals, test for Workplan and workplan entry number.
    //     if GenLedgerSetup."Enable Gen. Jnl. Budget checks" then
    //         if lvGLAccount.Get(GenJournalLine."Account No.") then
    //             if lvGLAccount."Add to Work Plan" then begin
    //                 GenJournalLine.TestField("Work Plan");
    //                 GenJournalLine.TestField("Work Plan Entry No.");
    //             end;
    //     PaymentReqHeader.SetRange("PV No.", GenJournalLine."Document No.");
    //     if PaymentReqHeader.FindFirst() then
    //         HideDialog := true;
    //     AccountabilityHeader.SetRange("No.", GenJournalLine."Document No.");
    //     if AccountabilityHeader.FindFirst() then
    //         HideDialog := true;
    // end;

    procedure CanCancelApprovalForRecord(RecID: RecordID) Result: Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then
            exit(false);

        ApprovalEntry.SetRange("Table ID", RecID.TableNo);
        ApprovalEntry.SetRange("Record ID to Approve", RecID);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);

        if not UserSetup."Approval Administrator" then
            ApprovalEntry.SetRange("Sender ID", UserId);
        Result := ApprovalEntry.FindFirst();
    end;

    procedure HasOpenApprovalEntries(RecordID: RecordID) Result: Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

        ApprovalEntry.SetRange("Table ID", RecordID.TableNo);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        // Initial check before performing an expensive query due to the "Related to Change" flow field.
        if ApprovalEntry.IsEmpty() then
            exit(false);
        ApprovalEntry.SetRange("Related to Change", false);
        exit(not ApprovalEntry.IsEmpty);
    end;

    procedure HasOpenApprovalEntriesForCurrentUser(RecordID: RecordID): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", RecordID.TableNo);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID", UserId);
        // Initial check before performing an expensive query due to the "Related to Change" flow field.
        if ApprovalEntry.IsEmpty() then
            exit(false);
        ApprovalEntry.SetRange("Related to Change", false);

        exit(not ApprovalEntry.IsEmpty());
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, 'OnBeforeTestBalance', '', false, false)]
    // local procedure CalculateCommitments(var GLAccount: Record "G/L Account"; var AccScheduleName: Record "Acc. Schedule Name"; var AccScheduleLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; AmountType: Integer; var ColValue: Decimal; CalcAddCurr: Boolean; var TestBalance: Boolean; var GLEntry: Record "G/L Entry"; var GLBudgetEntry: Record "G/L Budget Entry"; var Balance: Decimal)
    // var
    // begin
    //     case ColumnLayout."Ledger Entry Type" of
    //         ColumnLayout."Ledger Entry Type"::"Commitment Entries":
    //             begin
    //                 if AccScheduleName."Analysis View Name" = '' then
    //                     exit;
    //                 AccSchedName := AccScheduleName;
    //                 //if AccScheduleName."Analysis View Name" <> '' then
    //                 //with AnalysisViewEntry do begin
    //                 SetGLAccAnalysisViewEntryFilters(GLAccount, AnalysisViewEntry, AccScheduleLine, ColumnLayout);
    //                 If AmountType = 0 then begin
    //                     if CalcAddCurr then begin
    //                         AnalysisViewEntry.CalcSums("Add.-Curr. Amount");
    //                         ColValue := AnalysisViewEntry."Add.-Curr. Amount";
    //                     end else begin
    //                         AnalysisViewEntry.CalcSums(Amount);
    //                         ColValue := AnalysisViewEntry.Amount;
    //                     end;
    //                     Balance := ColValue;
    //                 end;
    //                 IF AmountType = 1 then
    //                     if CalcAddCurr then begin
    //                         if TestBalance then begin
    //                             AnalysisViewEntry.CalcSums("Add.-Curr. Debit Amount", "Add.-Curr. Amount");
    //                             Balance := AnalysisViewEntry."Add.-Curr. Amount";
    //                         end else
    //                             AnalysisViewEntry.CalcSums("Add.-Curr. Debit Amount");
    //                         ColValue := AnalysisViewEntry."Add.-Curr. Debit Amount";
    //                     end else begin
    //                         if TestBalance then begin
    //                             AnalysisViewEntry.CalcSums("Debit Amount", Amount);
    //                             Balance := AnalysisViewEntry.Amount;
    //                         end else
    //                             AnalysisViewEntry.CalcSums("Debit Amount");
    //                         ColValue := AnalysisViewEntry."Debit Amount";
    //                     end;
    //                 IF AmountType = 2 then
    //                     if CalcAddCurr then begin
    //                         if TestBalance then begin
    //                             AnalysisViewEntry.CalcSums("Add.-Curr. Credit Amount", "Add.-Curr. Amount");
    //                             Balance := AnalysisViewEntry."Add.-Curr. Amount";
    //                         end else
    //                             AnalysisViewEntry.CalcSums("Add.-Curr. Credit Amount");
    //                         ColValue := AnalysisViewEntry."Add.-Curr. Credit Amount";
    //                     end else begin
    //                         if TestBalance then begin
    //                             AnalysisViewEntry.CalcSums("Credit Amount", Amount);
    //                             Balance := AnalysisViewEntry.Amount;
    //                         end else
    //                             AnalysisViewEntry.CalcSums("Credit Amount");
    //                         ColValue := AnalysisViewEntry."Credit Amount";
    //                     end;
    //             end;
    //     end;
    // end;

    // local procedure SetGLAccAnalysisViewEntryFilters(var GLAcc: Record "G/L Account"; var AnalysisViewEntry: Record "Analysis Commitment View Entry"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout")
    // begin
    // AnalysisViewEntry.SetRange("Analysis View Code", AccSchedName."Analysis View Name");
    // AnalysisViewEntry.SetRange("Account Source", AnalysisViewEntry."Account Source"::"G/L Account");
    // if GLAcc.Totaling = '' then
    //     AnalysisViewEntry.SetRange("Account No.", GLAcc."No.")
    // else
    //     AnalysisViewEntry.SetFilter("Account No.", GLAcc.Totaling);
    //     GLAcc.CopyFilter("Date Filter", AnalysisViewEntry."Posting Date");
    //     AccSchedLine.CopyFilter("Business Unit Filter", AnalysisViewEntry."Business Unit Code");
    //     AnalysisViewEntry.CopyDimFilters(AccSchedLine);
    //     AnalysisViewEntry.FilterGroup(2);
    //     AnalysisViewEntry.SetDimFilters(
    //       AccSchMgt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"),
    //       AccSchMgt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"),
    //       AccSchMgt.GetDimTotalingFilter(3, AccSchedLine."Dimension 3 Totaling"),
    //       AccSchMgt.GetDimTotalingFilter(4, AccSchedLine."Dimension 4 Totaling"));
    //     AnalysisViewEntry.FilterGroup(8);
    //     AnalysisViewEntry.SetDimFilters(
    //        AccSchMgt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"),
    //        AccSchMgt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"),
    //        AccSchMgt.GetDimTotalingFilter(3, ColumnLayout."Dimension 3 Totaling"),
    //        AccSchMgt.GetDimTotalingFilter(4, ColumnLayout."Dimension 4 Totaling"));
    //     //AnalysisViewEntry.SetFilter("Business Unit Code", ColumnLayout."Business Unit Totaling");
    //     AnalysisViewEntry.FilterGroup(0);
    // end;


    //Add integration points for Record approvals.
    [IntegrationEvent(false, false)]
    procedure ApproveRecordRequest(RecordID: RecordId)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure RejectRecordApprovalRequest(RecordID: RecordId)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure DelegateRecordApprovalRequest(RecordID: RecordId)
    begin
    end;

    //Restrict User access for tables in terms of Create, Modify, Delete.
    //To be reviewed
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)] 
    // local procedure OnAfterGetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseRename: Boolean)
    // var
    //     RestrictedTable: Record "Restricted Table";
    // begin
    //     RestrictedTable.SetRange("Table ID", TableId);
    //     if RestrictedTable.FindFirst() then begin
    //         OnDatabaseInsert := true;
    //         OnDatabaseModify := true;
    //         OnDatabaseDelete := true;
    //         OnDatabaseRename := true;
    //     end else begin
    //         OnDatabaseInsert := false;
    //         OnDatabaseModify := false;
    //         OnDatabaseDelete := false;
    //         OnDatabaseRename := false;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseInsert', '', false, false)]
    // local procedure OnAfterOnDatabaseInsert(RecRef: RecordRef)
    // var
    //     RestrictedTable: Record "Restricted Table";
    // begin
    //     CheckUserAccess(RecRef, 'create');
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', false, false)]
    // local procedure OnAfterOnDatabaseModify(RecRef: RecordRef)
    // var
    //     RestrictedTable: Record "Restricted Table";
    // begin
    //     CheckUserAccess(RecRef, 'modify');
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseDelete', '', false, false)]
    // local procedure OnAfterOnDatabaseDelete(RecRef: RecordRef)
    // begin
    //     CheckUserAccess(RecRef, 'delete');
    // end;

    /*-----------------------Related to fixed asset clearing account. Check if the amount on the Fixed Asset specifications page is 
    equal to the Purchase line amount before posting the purchase order and update the table once the receipt is created-----------------------------------------------------------*/
    // local procedure CalculateTotalAmountOnFixedAssetSpecs(var PurchLine: Record "Purchase Line"): Decimal
    // var
    //     FixedAssetSpecs: Record "Fixed Assets Specs";
    //     gvTotalAmount: Decimal;
    // begin
    //     Clear(gvTotalAmount);
    //     FixedAssetSpecs.SetRange("Receipt Generated", false);
    //     FixedAssetSpecs.SetRange("Purchase Order No.", PurchLine."Document No.");
    //     FixedAssetSpecs.SetRange("Purch. Order Line No.", PurchLine."Line No.");
    //     if FixedAssetSpecs.FindSet() then
    //         repeat
    //             gvTotalAmount += FixedAssetSpecs.Amount;
    //         until FixedAssetSpecs.Next() = 0;
    //     exit(gvTotalAmount);
    // end;

    // local procedure CountFixedAssets(var PurchLine: Record "Purchase Line"): Integer
    // var
    //     FixedAssetSpecs: Record "Fixed Assets Specs";
    //     gvCount: Integer;
    // begin
    //     Clear(gvCount);
    //     FixedAssetSpecs.SetRange("Receipt Generated", false);
    //     FixedAssetSpecs.SetRange("Purchase Order No.", PurchLine."Document No.");
    //     FixedAssetSpecs.SetRange("Purch. Order Line No.", PurchLine."Line No.");
    //     if FixedAssetSpecs.FindSet() then
    //         repeat
    //             gvCount += 1;
    //         until FixedAssetSpecs.Next() = 0;
    //     exit(gvCount);
    // end;

    // local procedure CheckFixedAssetsSpecsMandatoryFields(PurchLine: Record "Purchase Line")
    // var
    //     FixedAssetSpecs: Record "Fixed Assets Specs";
    // begin
    //     FixedAssetSpecs.SetRange("Receipt Generated", false);
    //     FixedAssetSpecs.SetRange("Purchase Order No.", PurchLine."Document No.");
    //     FixedAssetSpecs.SetRange("Purch. Order Line No.", PurchLine."Line No.");
    //     if FixedAssetSpecs.FindSet() then
    //         repeat
    //             FixedAssetSpecs.TestField(Description);
    //             FixedAssetSpecs.TestField("Serial No.");
    //         until FixedAssetSpecs.Next() = 0;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    // local procedure CheckTotalAmount(var PurchaseHeader: Record "Purchase Header")
    // var
    //     PurchLine: Record "Purchase Line";
    //     GLAccount: Record "G/L Account";
    //     FixedAssetSpecification: Record "Fixed Assets Specs";
    //     FASpecsTotalAmount: Decimal;
    //     Currency: Record Currency;
    // begin
    //     if PurchaseHeader."Currency Code" <> '' then
    //         Currency.get(PurchaseHeader."Currency Code")
    //     else
    //         Currency.InitRoundingPrecision();
    //     if (PurchaseHeader.Receive) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then begin
    //         PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //         PurchLine.SetRange("Document No.", PurchaseHeader."No.");
    //         PurchLine.SetRange(Type, PurchLine.Type::"G/L Account");
    //         PurchLine.SetRange("Exclude FA Specs Check", false);
    //         if PurchLine.FindSet() then
    //             repeat
    //                 GLAccount.SetRange("No.", PurchLine."No.");
    //                 GLAccount.SetRange("FA Acquisition Control Acc.", true);
    //                 if GLAccount.FindFirst() then begin
    //                     CheckFixedAssetsSpecsMandatoryFields(PurchLine);
    //                     FASpecsTotalAmount := CalculateTotalAmountOnFixedAssetSpecs(PurchLine);
    //                     if PurchLine."Qty. to Receive" <> 0 then begin
    //                         if ((round((PurchLine."Unit Cost" * PurchLine."Qty. to Receive"), Currency."Amount Rounding Precision")) <> FASpecsTotalAmount) or (PurchLine."Qty. to Receive" <> CountFixedAssets(PurchLine)) then
    //                             Error('The total amount for the fixed Asset Specification must be equal to the line amount less VAT and the Number of assets must be equal to quantity to receive for Purchase Order %1, Line number %2', PurchLine."Document No.", PurchLine."Line No.");
    //                     end;
    //                 end;
    //             until PurchLine.Next() = 0;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptHeaderInsert', '', true, true)]
    // local procedure UpdateFixedAssetSpecsTable(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header")
    // var
    //     FixedAssetSpec: Record "Fixed Assets Specs";
    //     PurchLine: Record "Purchase Line";
    //     GLAccount: Record "G/L Account";
    // begin
    //     PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //     PurchLine.SetRange("Document No.", PurchaseHeader."No.");
    //     PurchLine.SetRange(Type, PurchLine.Type::"G/L Account");
    //     if PurchLine.FindSet() then
    //         repeat
    //             GLAccount.SetRange("No.", PurchLine."No.");
    //             GLAccount.SetRange("FA Acquisition Control Acc.", true);
    //             if GLAccount.FindFirst() then begin
    //                 FixedAssetSpec.SetRange("Purchase Order No.", PurchLine."Document No.");
    //                 FixedAssetSpec.SetRange("Purch. Order Line No.", PurchLine."Line No.");
    //                 if FixedAssetSpec.FindSet() then
    //                     repeat
    //                         FixedAssetSpec."Purch. Rcpt. No." := PurchRcptHeader."No.";
    //                         FixedAssetSpec."Receipt Generated" := true;
    //                         FixedAssetSpec."Purchase Req. No." := PurchaseHeader."Purchase Requisition No.";
    //                         FixedAssetSpec."GRN No." := PurchaseHeader."Vendor Shipment No.";
    //                         FixedAssetSpec.Modify();
    //                     until FixedAssetSpec.Next() = 0;
    //             end;
    //         Until PurchLine.Next() = 0;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', true, true)]
    // local procedure UpdateFixedAssetSpecInvoiceNo(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    // var
    //     FixedAssetSpec: Record "Fixed Assets Specs";
    //     PurchLine: Record "Purchase Line";
    //     GLAccount: Record "G/L Account";
    //     counter: Integer;
    // begin
    //     PurchLine.Reset();
    //     PurchLine.SetRange("Document Type", PurchHeader."Document Type");
    //     PurchLine.SetRange("Document No.", PurchHeader."No.");
    //     PurchLine.SetRange(Type, PurchLine.Type::"G/L Account");
    //     if PurchLine.FindSet() then
    //         repeat
    //             Clear(counter);
    //             GLAccount.SetRange("No.", PurchLine."No.");
    //             GLAccount.SetRange("FA Acquisition Control Acc.", true);
    //             if GLAccount.FindFirst() then begin
    //                 FixedAssetSpec.SetRange("Purchase Order No.", PurchLine."Document No.");
    //                 FixedAssetSpec.SetRange("Purch. Order Line No.", PurchLine."Line No.");
    //                 FixedAssetSpec.SetRange("Receipt Generated", true);
    //                 FixedAssetSpec.SetRange("Invoice Posted", false);
    //                 if FixedAssetSpec.FindSet() then
    //                     repeat
    //                         counter += 1;
    //                         FixedAssetSpec."Purchase Invoice No" := PurchInvHeader."No.";
    //                         FixedAssetSpec."Invoice Posted" := true;
    //                         FixedAssetSpec."Acquisition Date" := PurchInvHeader."Posting Date";
    //                         FixedAssetSpec.Modify();
    //                         FixedAssetSpec.Next();
    //                     until counter = PurchLine."Qty. to Invoice";
    //             end;
    //         Until PurchLine.Next() = 0;
    // end;
    /*-----------------------Related to fixed asset clearing account. Check if the amount on the Fixed Asset specifications page is 
        equal to the Purchase line amount before posting the purchase order and update the table once the receipt is created-----------End------------------------------------------------*/


    // local procedure CheckUserAccess(RecRef: RecordRef; UserAction: text)
    // var
    //     AccessError: Label 'You do not have rights to %1 this record.';
    //     RestrictedTable: Record "Restricted Table";
    // begin
    //     if RecRef.IsTemporary then
    //         exit;
    //     RestrictedTable.SetRange("Table ID", RecRef.Number);
    //     if RestrictedTable.FindSet() then
    //         repeat
    //             RestrictedTable.SetRange("USER ID", UserId);
    //             if not RestrictedTable.FindFirst() then
    //                 Error(AccessError, UserAction)
    //         until RestrictedTable.Next() = 0;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    // local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    // var
    //     FieldRef: FieldRef;
    //     RecNo: Code[20];
    //     DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
    // begin
    //     if RecRef.Number = Database::Insurance then begin
    //         FieldRef := RecRef.Field(1);
    //         RecNo := FieldRef.Value;
    //         DocumentAttachment.Validate("No.", RecNo);
    //     end;
    //     case RecRef.Number of
    //         DATABASE::"Purchase Requisition Header":
    //             begin
    //                 FieldRef := RecRef.Field(1);
    //                 DocType := FieldRef.Value;
    //                 DocumentAttachment.Validate("Document Type", DocType);

    //                 FieldRef := RecRef.Field(2);
    //                 RecNo := FieldRef.Value;
    //                 DocumentAttachment.Validate("No.", RecNo);
    //             end;
    //         DATABASE::"Payment Requisition Header":
    //             begin
    //                 FieldRef := RecRef.Field(1);
    //                 RecNo := FieldRef.Value;
    //                 DocumentAttachment.Validate("No.", RecNo);

    //                 FieldRef := RecRef.Field(8);
    //                 DocType := FieldRef.Value;
    //                 DocumentAttachment.Validate("Document Type", DocType);

    //             end;
    //         Database::"Accountability Header":
    //             begin
    //                 FieldRef := RecRef.Field(1);
    //                 RecNo := FieldRef.Value;
    //                 DocumentAttachment.Validate("No.", RecNo);

    //                 FieldRef := RecRef.Field(8);
    //                 DocType := FieldRef.Value;
    //                 DocumentAttachment.Validate("Document Type", DocType);
    //             end;
    //         Database::"Budget Realloc. Header":
    //             begin
    //                 FieldRef := RecRef.Field(1);
    //                 DocType := FieldRef.Value;
    //                 DocumentAttachment.Validate("Document Type", DocType);
    //                 FieldRef := RecRef.Field(2);
    //                 RecNo := FieldRef.Value;
    //                 DocumentAttachment.Validate("No.", RecNo);
    //             end;

    //     end;
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
    begin
        if RecRef.Number = Database::Insurance then begin
            FieldRef := RecRef.Field(1);
            RecNo := FieldRef.Value;
            DocumentAttachment.SetRange("No.", RecNo);
        end;
        case RecRef.Number of
        // DATABASE::"Purchase Requisition Header":
        //     begin
        //         FieldRef := RecRef.Field(1);
        //         DocType := FieldRef.Value;

        //         FieldRef := RecRef.Field(2);
        //         RecNo := FieldRef.Value;
        //         DocumentAttachment.SetRange("Document Type", DocType);
        //         DocumentAttachment.SetRange("No.", RecNo);
        //     end;
        // DATABASE::"Payment Requisition Header":
        //     begin
        //         FieldRef := RecRef.Field(1);
        //         RecNo := FieldRef.Value;

        //         FieldRef := RecRef.Field(8);
        //         DocType := FieldRef.Value;
        //         DocumentAttachment.SetRange("Document Type", DocType);
        //         DocumentAttachment.SetRange("No.", RecNo);

        //     end;
        // Database::"Accountability Header":
        //     begin
        //         FieldRef := RecRef.Field(1);
        //         RecNo := FieldRef.Value;

        //         FieldRef := RecRef.Field(8);
        //         DocType := FieldRef.Value;
        //         DocumentAttachment.SetRange("Document Type", DocType);
        //         DocumentAttachment.SetRange("No.", RecNo);
        //     end;

        end;
    end;

    procedure GetSenderUserID(SenderEmailAddress: Text[80]): Code[50]
    var
        lvUser: Record User;
    begin
        if SenderEmailAddress <> '' then begin
            lvUser.Reset();
            if lvUser.Find('-') then
                repeat
                    if LowerCase(lvUser."Authentication Email") = LowerCase(SenderEmailAddress) then
                        exit(lvUser."User Name");
                until lvUser.Next() = 0;
        end
        else
            exit(UserId);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Distribution Management", 'OnGetFullDocumentTypeTextElseCase', '', false, false)]
    // local procedure OnGetFullDocumentTypeTextElseCase(DocumentRecordRef: RecordRef; var DocumentTypeText: Text[50])
    // begin
    //     case DocumentRecordRef.Number of
    //         Database::"Request For Quotation Tracker":
    //             DocumentTypeText := 'Request For Quotation';

    //     end;
    // end;

    // [EventSubscriber(ObjectType::Page, Page::"Report Selection - Purchase", 'OnSetUsageFilterOnAfterSetFiltersByReportUsage', '', false, false)]
    // local procedure OnSetUsageFilterOnAfterSetFiltersByReportUsage(ReportUsage2: Enum "Report Selection Usage Purchase"; var Rec: Record "Report Selections")
    // begin
    //     case ReportUsage2 of
    //         ReportUsage2::RFQ:
    //             Rec.SetRange(Usage, Rec.Usage::RFQ);
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnNotHandledCopyFromGLAccount', '', false, false)]
    // local procedure OnNotHandledCopyFromGLAccount(GLAccount: Record "G/L Account"; var PurchaseLine: Record "Purchase Line")
    // begin
    //     PurchaseLine."WHT Prod. Posting Group" := GLAccount."WHT Prod. Posting Group";
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    // local procedure OnCopyFromItemOnAfterCheck(Item: Record Item; var PurchaseLine: Record "Purchase Line")
    // begin
    //     PurchaseLine."WHT Prod. Posting Group" := Item."WHT Prod. Posting Group";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterUpdatePostingNos, '', false, false)]
    // local procedure OnAfterUpdatePostingNos(var PurchaseHeader: Record "Purchase Header"; var ModifyHeader: Boolean)
    // var
    //     lvNumberingByDonor: Record "Numbering By Donor";
    //     lvGenLedgerSetup: Record "General Ledger Setup";
    //     lvNoseries: Codeunit NoSeriesManagement;
    // begin
    //     lvGenLedgerSetup.get();
    //     lvNumberingByDonor.Reset();
    //     lvNumberingByDonor.SetRange("Dimension Code", lvGenLedgerSetup."Global Dimension 2 Code");
    //     lvNumberingByDonor.SetRange("Dimension Value Code", PurchaseHeader."Shortcut Dimension 2 Code");
    //     if lvNumberingByDonor.FindFirst() then begin
    //         if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then begin
    //             if lvNumberingByDonor."Posted Purch. Inv. Nos." <> '' then begin
    //                 PurchaseHeader."Posting No. Series" := lvNumberingByDonor."Posted Purch. Inv. Nos.";
    //                 PurchaseHeader.Validate("Posting No.", lvNoseries.GetNextNo(lvNumberingByDonor."Posted Purch. Inv. Nos.", today, true));
    //             end;
    //         end else
    //             if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") then
    //                 if lvNumberingByDonor."Posted Purch. Cr. Memo" <> '' then begin
    //                     PurchaseHeader."Posting No. Series" := lvNumberingByDonor."Posted Purch. Cr. Memo";
    //                     PurchaseHeader.Validate("Posting No.", lvNoseries.GetNextNo(lvNumberingByDonor."Posted Purch. Cr. Memo", today, true));
    //                 end;
    //         PurchaseHeader.Modify();
    //     end;

    // end;
    //Budget Check for General Journal.
    // [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeUpdateApplyToAmount', '', false, false)]
    // local procedure OnBeforeUpdateApplyToAmount(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line")
    // var
    //     BudgetContSetup: Record "Budget Control Setup";
    //     GeneralLedgerSetup: Record "General Ledger Setup";
    //     lvGenJnlLine: Record "Gen. Journal Line";
    //     LinePendingAmountLCY: Decimal;
    // begin
    //     GeneralLedgerSetup.get();
    //     if GeneralLedgerSetup."Enable Gen. Jnl. Budget checks" then
    //         if GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::"G/L Account"] then
    //             // Budget Check ======================================
    //             if GenJournalLine."Amount (LCY)" > 0 then
    //                 if (GenJournalLine."Work Plan" <> '') and not GenJournalLine."System-Created Entry" and not GenJournalLine."Created From Requisition" then begin
    //                     lvGenJnlLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
    //                     lvGenJnlLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
    //                     lvGenJnlLine.SetFilter("Line No.", '<>%1', GenJournalLine."Line No.");
    //                     lvGenJnlLine.SetRange("Work Plan", GenJournalLine."Work Plan");
    //                     lvGenJnlLine.SetRange("Work Plan Entry No.", GenJournalLine."Work Plan Entry No.");
    //                     if lvGenJnlLine.FindSet() then
    //                         repeat
    //                             LinePendingAmountLCY += lvGenJnlLine."Amount (LCY)";
    //                         until lvGenJnlLine.Next() = 0;
    //                     BudgetContSetup.CheckBudget(GenJournalLine."Work Plan", GenJournalLine."Work Plan Entry No.", GenJournalLine."Budget Name", GenJournalLine."Amount (LCY)", LinePendingAmountLCY, xGenJournalLine."Amount (LCY)");
    //                 end;
    //     //====================================================
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCreateDim', '', false, false)]
    // local procedure OnBeforeCreateDim(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    // begin
    //     if CurrentFieldNo = GenJournalLine.FieldNo("Bal. Account No.") then
    //         if (GenJournalLine."Work Plan Entry No." <> 0) and (GenJournalLine."Budget Set ID" <> 0) then
    //             IsHandled := true;
    // end;



    var
        Pay: Page "Payment Journal";
        Checkline: Codeunit "Gen. Jnl.-Check Line";
        AnalysisViewCopy: Record "Analysis View";
        // TempAnalysisViewEntry: Record "Analysis Commitment View Entry";
        // AnalysisViewEntry: Record "Analysis Commitment View Entry";
        AccSchedName: Record "Acc. Schedule Name";
        NoOfEntries: Integer;
        PrevPostingDate: Date;
        PrevCalculatedPostingDate: Date;
        // AmountType: Enum "Account Schedule Amount Type";
        AccSchMgt: Codeunit AccSchedManagement;
        Txt001: Label 'Commitment Values can only be populated if the analysis view is not empty';
        UserCanInsert: Boolean;
        UserCanEdit: Boolean;
        UserCanDelete: Boolean;
}
