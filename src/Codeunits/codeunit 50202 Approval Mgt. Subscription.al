codeunit 50202 "Approval Mgt. Subscription"
{
    Permissions = tabledata "Approval Entry" = m;

    var
        ApprovalMgt: Codeunit "Approval Management";
        ApprovalMgtNotification: Codeunit "Approval Notification";
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";

    // [EventSubscriber(ObjectType::Table, Database::"Payroll Header", 'OnSenderPayrollHeaderForApproval', '', false, false)]
    // local procedure OnSenderPayrollHeaderForApproval(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     IF ApprovalMgt.SendRequest(RecRef, senderUserID) THEN;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"WorkPlan Header", 'OnSendWorkplanApprovalRequest', '', false, false)]
    local procedure OnSendWorkplanApprovalRequest(var WorkplanHeader: Record "WorkPlan Header"; senderUserID: Code[50])
    var
        RecID: RecordId;
        RecRef: RecordRef;
    begin
        RecID := WorkplanHeader.RecordId;
        RecRef := RecID.GetRecord();
        ApprovalMgt.SendRequest(RecRef, senderUserID);
        ;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Budget Realloc. Header", 'OnSendBudgetReallocApprovalRequest', '', false, false)]
    local procedure OnSendBudgetReallocApprovalRequest(var BudgetReallocHeader: Record "Budget Realloc. Header"; senderUserID: Code[50])
    var
        RecID: RecordId;
        RecRef: RecordRef;
    begin
        RecID := BudgetReallocHeader.RecordId;
        RecRef := RecID.GetRecord();
        ApprovalMgt.SendRequest(RecRef, senderUserID);
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Requisition Header", 'OnSendPurchasReqeApprovalRequest', '', false, false)]
    // local procedure OnSendPurchasReqeApprovalRequest(var recRef: RecordRef; SenderUserID: Code[20])
    // var
    //     RecID: RecordId;
    // begin
    //     ApprovalMgt.SendRequest(RecRef, SenderUserID);
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnSendPurchaseApprovalRequest', '', false, false)]
    local procedure OnSendPurchaseApprovalRequest(var Recref: RecordRef; senderUserID: Code[50])
    var
        RecID: RecordId;
    begin
        ApprovalMgt.SendRequest(RecRef, senderUserID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Requisition Header", 'OnSendPaymentApprovalRequest', '', false, false)]
    local procedure OnSendPaymentApprovalRequest(var RecRef: RecordRef; SenderUserID: Code[50])
    begin
        ApprovalMgt.SendRequest(RecRef, SenderUserID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Accountability Header", 'OnSendAccountabilityApprovalRequest', '', false, false)]
    local procedure OnSendAccountabilityApprovalRequest(Recref: RecordRef; SenderUserID: Code[50])
    begin
        ApprovalMgt.SendRequest(RecRef, SenderUserID);
    end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Req. Employee Headers", 'onSendRecruitmentApprovalRequest', '', false, false)]
    // local procedure onSendRecruitmentApprovalRequest(var RecRef: RecordRef; senderUserID: Code[20])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Exit Interview", 'onSendExitInterviewApprovalRequest', '', false, false)]
    // local procedure onSendExitInterviewApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Training Plan", 'onSendTrainingPlanApprovalRequest', '', false, false)]
    // local procedure onSendTrainingPlanApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Training Request", 'onSendTrainingRequestApprovalRequest', '', false, false)]
    // local procedure onSendTrainingRequestApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Staff Handover", 'onSendStaffHandoverApprovalRequest', '', false, false)]
    // local procedure onSendStaffHandoverApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Performance Header", 'onSendIPAApprovalRequest', '', false, false)]
    // local procedure onSendIPAApprovalRequest(var RecRef: RecordRef)
    // begin
    //     ApprovalMgt.SendRequest(RecRef);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Employee Journal Line", 'OnSendEmployeeJnlLineApprovalRequest', '', false, false)]
    // local procedure OnSendEmployeeJnlLineApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Employee Journal Line", 'OnSendEmployeeJnlLineBatchApprovalRequest', '', false, false)]
    // local procedure OnSendEmployeeJnlLineBatchApprovalRequest(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Bank Acc. Reconciliation", 'OnSendBankReconApproval', '', false, false)]
    // local procedure OnSendBankReconApproval(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Human Resource Header", 'OnSendLeaveApprovalRequest', '', false, false)]
    // local procedure OnSendLeaveApprovalRequest(var RecRef: RecordRef; SenderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Payroll Header", 'OnCancelPayrollHeaderApprovalRequest', '', false, false)]
    // local procedure OnCancelPayrollHeaderApprovalRequest(var PayrollHeader: Record "Payroll Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := PayrollHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Payroll Header", DocType::Payroll, PayrollHeader."Payroll ID", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Human Resource Header", 'onCancelLeaveApprovalRequest', '', false, false)]
    // local procedure onCancelLeaveApprovalRequest(var RecRef: RecordRef)
    // var
    //     RecID: RecordId;
    //     DocType: Enum "Approval Document Type";
    //     RecNo: Code[20];
    //     FieldRef: FieldRef;
    // begin
    //     FieldRef := RecRef.Field(1);
    //     DocType := FieldRef.Value;
    //     FieldRef := RecRef.Field(2);
    //     RecNo := FieldRef.Value;
    //     IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Human Resource Header", DocType, RecNo, true, false) THEN;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Bank Acc. Reconciliation", 'OnCancelBankReconApproval', '', false, false)]
    // local procedure OnCancelBankReconApproval(var BankAccountRecon: Record "Bank Acc. Reconciliation")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := BankAccountRecon.RecordId;
    //     RecRef := RecID.GetRecord();
    //     IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Bank Acc. Reconciliation", DocType::"Bank Reconciliation", BankAccountRecon."Reconciliation No", true, false) THEN;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Employee Journal Line", 'onCancelEmployeeJnlLineBatchApprovalRequest', '', false, false)]
    // local procedure onCancelEmployeeJnlLineBatchApprovalRequest(var HRMEmpJnlLine: Record "HRM Employee Journal Line")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    //     hrmJournalBatch: Record "HRM Employee Journal Batch";
    // begin
    //     hrmJournalBatch.SetRange("Journal Template Name", HRMEmpJnlLine."Journal Template Name");
    //     hrmJournalBatch.SetRange(Name, HRMEmpJnlLine."Journal Batch Name");
    //     if hrmJournalBatch.FindFirst() then begin
    //         RecID := hrmJournalBatch.RecordId;
    //         RecRef := RecID.GetRecord();
    //         ApprovalMgt.CancelApprovalRequest(RecRef, Database::"HRM Employee Journal Batch", DocType::"Leave Request", hrmJournalBatch.Name, true, false);
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Employee Journal Line", 'onCancelEmployeeJnlLineApprovalRequest', '', false, false)]
    // local procedure onCancelEmployeeJnlLineApprovalRequest(var HRMEmpJnlLine: Record "HRM Employee Journal Line")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := HRMEmpJnlLine.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Personal Devt. Plan Header", HRMEmpJnlLine."Approval Document Type", HRMEmpJnlLine."Document No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Personal Devt. Plan Header", 'onCancelPersonalDvtPlanApprovalRequest', '', false, false)]
    // local procedure onCancelPersonalDvtPlanApprovalRequest(var PersonalDvtPlan: Record "Personal Devt. Plan Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := PersonalDvtPlan.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Personal Devt. Plan Header", PersonalDvtPlan."Approval Document Type", PersonalDvtPlan."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Performance Header", 'onCancelIPAApprovalRequest', '', false, false)]
    // local procedure onCancelIPAApprovalRequest(var PerformanceHeader: Record "Performance Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := PerformanceHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Performance Header", PerformanceHeader."Document Type", PerformanceHeader."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Staff Handover", 'onCancelStaffHandoverApprovalRequest', '', false, false)]
    // local procedure onCancelStaffHandoverApprovalRequest(var StaffHandover: Record "Staff Handover")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := StaffHandover.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Staff Handover", StaffHandover."Approval Document Type", StaffHandover."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Training Request", 'onCancelTrainingRequestApprovalRequest', '', false, false)]
    // local procedure onCancelTrainingRequestApprovalRequest(var TrainingRequest: Record "Training Request")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := TrainingRequest.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Training Request", TrainingRequest."Approval Document Type", TrainingRequest."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Training Plan", 'onCancelTrainingPlanApprovalRequest', '', false, false)]
    // local procedure onCancelTrainingPlanApprovalRequest(var HRMTrainingPlan: Record "HRM Training Plan")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := HRMTrainingPlan.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"HRM Training Plan", HRMTrainingPlan."Approval Document Type", HRMTrainingPlan."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Exit Interview", 'onCancelExitInterviewApprovalRequest', '', false, false)]
    // local procedure onCancelExitInterviewApprovalRequest(var ExitInterview: Record "Exit Interview")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := ExitInterview.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Exit Interview", ExitInterview."Document Type", ExitInterview."No.", false, false)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"HRM Req. Employee Headers", 'onCancelEmployeeReqApprovalRequest', '', false, false)]
    // local procedure onCancelEmployeeReqApprovalRequest(var HRMReqEmpHeader: Record "HRM Req. Employee Headers")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    //     DocType: Enum "Approval Document Type";
    // begin
    //     RecID := HRMReqEmpHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"HRM Req. Employee Headers", HRMReqEmpHeader."Document Type", HRMReqEmpHeader."No.", false, false)
    // end;

    [EventSubscriber(ObjectType::Table, Database::"WorkPlan Header", 'OnCancelWorkplanApprovalRequest', '', false, false)]
    local procedure OnCancelWorkplanApprovalRequest(var WorkplanHeader: Record "WorkPlan Header")
    var
        RecID: RecordId;
        RecRef: RecordRef;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
    begin
        RecID := WorkplanHeader.RecordId;
        RecRef := RecID.GetRecord();
        IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"WorkPlan Header", DocType::Workplan, WorkplanHeader."No.", true, false) THEN;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Budget Realloc. Header", 'OnCancelBudgetReallocApprovalRequest', '', false, false)]
    local procedure OnCancelBudgetReallocApprovalRequest(var BudgetReallocHeader: Record "Budget Realloc. Header")
    var
        RecID: RecordId;
        RecRef: RecordRef;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
    begin
        RecID := BudgetReallocHeader.RecordId;
        RecRef := RecID.GetRecord();
        IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Budget Realloc. Header", DocType::"Budget Reallocation", BudgetReallocHeader."No.", true, false) THEN;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Requisition Header", 'OnCancelPurchaseReqApprovalRequest', '', false, false)]
    // local procedure OnCancelPurchaseReqApprovalRequest(var PurchaseReqHeader: Record "Purchase Requisition Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    // begin
    //     RecID := PurchaseReqHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Purchase Requisition Header", PurchaseReqHeader."Document Type", PurchaseReqHeader."No.", true, false) THEN;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCancelPurchaseApprovalRequest', '', false, false)]
    // local procedure OnCancelPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    // begin
    //     RecID := PurchaseHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Purchase Header", PurchaseHeader."Document Type", PurchaseHeader."No.", true, false) THEN;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Requisition Header", 'OnCancelPaymentApprovalRequest', '', false, false)]
    local procedure OnCancelPaymentApprovalRequest(var PaymentReqHeader: Record "Payment Requisition Header")
    var
        RecID: RecordId;
        RecRef: RecordRef;
    begin
        RecID := PaymentReqHeader.RecordId;
        RecRef := RecID.GetRecord();
        IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Payment Requisition Header", PaymentReqHeader."Document Type", PaymentReqHeader."No.", true, false) THEN;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Accountability Header", 'OnCancelAccountabilityApprovalRequest', '', false, false)]
    local procedure OnCancelAccountabilityApprovalRequest(var AccHeader: Record "Accountability Header")
    var
        RecID: RecordId;
        RecRef: RecordRef;
    begin
        RecID := AccHeader.RecordId;
        RecRef := RecID.GetRecord();
        IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Accountability Header", AccHeader."Document Type", AccHeader."No.", true, false) THEN;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Request Header", 'OnSendApprovalRequest', '', false, false)]
    // local procedure OnSendApprovalRequest(var RecRef: RecordRef; SenderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, SenderUserID)
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Request Header", 'OnCancelApprovalRequest', '', false, false)]
    // local procedure OnCancelApprovalRequest(var RequestHeader: Record "Request Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    // begin
    //     RecID := RequestHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     IF ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Request Header", RequestHeader."Document Type", RequestHeader."No.", true, false) THEN;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnSendGLAcountForApproval', '', false, false)]
    // local procedure OnSendGLAcountForApproval(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnCancelGLAcountApprovalRequest', '', false, false)]
    // local procedure OnCancelGLAcountApprovalRequest(var GLAccount: Record "G/L Account")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    // begin
    //     RecID := GLAccount.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"G/L Account", DocType::"G/L Account", GLAccount."No.", true, false);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Time Sheet Header", 'OnSendTimeSheetsForApproval', '', false, false)]
    // local procedure OnSendTimeSheetsForApproval(var RecRef: RecordRef; senderUserID: Code[50])
    // begin
    //     ApprovalMgt.SendRequest(RecRef, senderUserID);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Time Sheet Header", 'OnCancelTimeSheetsApprovalRequest', '', false, false)]
    // local procedure OnCancelTimeSheetsApprovalRequest(var TimesheetHeader: Record "Time Sheet Header")
    // var
    //     RecID: RecordId;
    //     RecRef: RecordRef;
    // begin
    //     RecID := TimesheetHeader.RecordId;
    //     RecRef := RecID.GetRecord();
    //     ApprovalMgt.CancelApprovalRequest(RecRef, Database::"Time Sheet Header", DocType::"Time Sheets", TimesheetHeader."No.", true, false);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Bank Acc. Reconciliation", 'OnViewBankReconApprovalHistory', '', false, false)]
    // local procedure OnViewBankReconApprovalHistory(var BankAccRecon: Record "Bank Acc. Reconciliation")
    // var
    //     ApprovalEntry: Record "Approval Entry";
    // begin
    //     ApprovalEntry.SetRange("Table ID", Database::"Bank Acc. Reconciliation");
    //     ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Bank Reconciliation");
    //     ApprovalEntry.SetRange("Document No.", BankAccRecon."Reconciliation No");
    //     ApprovalEntry.FindSet();
    //     Page.RunModal(Page::"Approval Entries", ApprovalEntry)
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ProcuretoPayActions, 'ApproveApprovalEntry', '', false, false)]
    // local procedure ApproveApprovalEntry(var ApprovalEntry: Record "Approval Entry")
    // begin
    //     ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ProcuretoPayActions, 'RejectApprovalEntry', '', false, false)]
    // local procedure RejectApprovalEntry(var ApprovalEntry: Record "Approval Entry")
    // begin
    //     ApprovalMgt.RejectApprovalRequest(ApprovalEntry, '');
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    local procedure OnDelegateApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        User: Record User;
        lvApproverUser: Record User;
    begin
        User.SetRange("User Name", UserId);
        if User.FindFirst() then;

        lvApproverUser.Reset();
        lvApproverUser.SetCurrentKey("User Name");
        lvApproverUser.SetRange("User Name", ApprovalEntry."Approver ID");
        if lvApproverUser.FindFirst() then begin
            ApprovalEntry."Approver's Email" := lvApproverUser."Authentication Email";
            ApprovalEntry.Modify();
        end;
        ApprovalMgtNotification.DelegationMail(ApprovalEntry, User."Full Name");
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Management", 'OnAfterApproveRequestEntry', '', false, false)]
    // local procedure OnAfterApproveRequestEntry(var ApprovalEntry: Record "Approval Entry"; var RecID: RecordId)
    // var
    //     lvHRSetup: Record "Human Resources Setup";
    //     lvHumanResourceHeader: Record "Human Resource Header";
    // begin
    //     lvHRSetup.Get();
    //     case ApprovalEntry."Table ID" of
    //         Database::"Human Resource Header":
    //             begin
    //                 if lvHRSetup."Automatic  Posting" then begin
    //                     lvHumanResourceHeader.SetRange("Document Type", ApprovalEntry."Document Type");
    //                     lvHumanResourceHeader.SetRange("No.", ApprovalEntry."Document No.");
    //                     if lvHumanResourceHeader.FindFirst() then
    //                         if lvHumanResourceHeader."Document Type" = lvHumanResourceHeader."Document Type"::"Leave Request" then
    //                             if lvHumanResourceHeader.Status = lvHumanResourceHeader.Status::Approved then
    //                                 CODEUNIT.Run(CODEUNIT::"Leave Request - Post", lvHumanResourceHeader);
    //                 end;
    //             end;

    //     end
    // end;

    procedure CheckForComments(DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; DocNo: Code[20]; TableID: Integer; RecID: RecordId)
    var
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Requisition Approval Comments";
    begin
        ApprovalCommentLine.SetRange("Table ID", TableID);
        ApprovalCommentLine.SetRange("Document Type", DocType);
        ApprovalCommentLine.SetRange("Document No.", DocNo);
        ApprovalCommentLine.SetRange("Record ID to Approve", RecID);
        ApprovalComments.SetTableView(ApprovalCommentLine);
        if ApprovalComments.RunModal() = ACTION::OK then begin
            ApprovalCommentLine.SetRange("Table ID", TableID);
            ApprovalCommentLine.SetRange("Document Type", DocType);
            ApprovalCommentLine.SetRange("Document No.", DocNo);
            ApprovalCommentLine.SetRange("Record ID to Approve", RecID);
            if ApprovalCommentLine.FindLast() then begin
                if not ApprovalCommentLine."New Comment" then begin
                    Error('Cancellation was unsuccessful because a new comment is required');
                    exit;
                end
                else begin
                    ApprovalCommentLine."New Comment" := false;
                    ApprovalCommentLine.Modify();
                end;
            end else begin
                Error('Cancellation was unsuccessful because a comment is required ...');
                exit;
            end;
            CLEAR(ApprovalComments);
        end
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Requisition Header", 'OnCheckCancelReqComments', '', false, false)]
    // local procedure OnCheckCancelReqComments(var PurchaseReqHeader: Record "Purchase Requisition Header")
    // begin
    //     CheckForComments(PurchaseReqHeader."Document Type", PurchaseReqHeader."No.", Database::"Purchase Requisition Header", PurchaseReqHeader.RecordId);
    // end;
    //Get CardPageIDs
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnaftergetPageId', '', false, false)]
    local procedure OnaftergetPageId(RecordRef: RecordRef; var PageID: Integer)
    var
        FieldRef: FieldRef;
        DocTYpe: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
    begin
        case RecordRef.Number of
            Database::"Payment Requisition Header":
                begin
                    FieldRef := RecordRef.Field(8);
                    DocTYpe := FieldRef.Value;

                    case DocTYpe of
                        DocTYpe::"Payment Requisition":
                            PageID := Page::"Payment Requisition";
                    // DocTYpe::"Bank Transfer":
                    //     PageID := Page::"Bank Transfer Card";
                    // DocTYpe::"Petty Cash":
                    //     PageID := Page::"Petty Cash Card";
                    // DocTYpe::"Travel Requests":
                    //     PageID := Page::"Travel Request Card";
                    end;

                end;

            // Database::"Purchase Requisition Header":
            //     begin
            //         FieldRef := RecordRef.Field(1);
            //         DocTYpe := FieldRef.Value;
            //         if DocTYpe = DocTYpe::"Purchase Requisition" then
            //             CardPageID := Page::"Purchase Requisition"
            //         else
            //             if DocTYpe = DocTYpe::"Stores Requisition" then
            //                 CardPageID := Page::"Stores Requisition";

            //     end;
            Database::"WorkPlan Header":
                begin
                    PageID := Page::"WorkPlan Header";
                end;
            // Database::"Human Resource Header":
            //     begin
            //         FieldRef := RecordRef.Field(1);
            //         DocTYpe := FieldRef.Value;
            //         if DocTYpe = DocTYpe::"Leave Request" then
            //             CardPageID := Page::"Leave Request Card";
            //         if DocTYpe = DocTYpe::"Leave Plan" then
            //             CardPageID := Page::"Leave plan";
            //     end;
            // Database::"Performance Header":
            //     begin
            //         FieldRef := RecordRef.Field(41);
            //         DocTYpe := FieldRef.Value;

            //         // if (DocTYpe = DocTYpe::"Performance Management") and (PerfTYpe = PerfTYpe::"Individual Performance Agreement") then
            //         //     CardPageID := Page::"Ipa";
            //         // if (DocTYpe = DocTYpe::"Performance Management") and (PerfTYpe = PerfTYpe::"Performance Appraisal") then
            //         //     CardPageID := Page::"Performance Appraisal"
            //         //     ;
            //     end;
            Database::"Budget Realloc. Header":
                begin
                    FieldRef := RecordRef.Field(1);
                    DocTYpe := FieldRef.Value;
                    if DocTYpe = DocTYpe::"Budget Reallocation" then
                        PageID := Page::"Budget Reallocation";
                end;
            // Database::"Bank Acc. Reconciliation":
            //     begin

            //     end;
            Database::"Accountability Header":
                begin
                    FieldRef := RecordRef.Field(8);
                    DocTYpe := FieldRef.Value;
                    if DocTYpe = DocTYpe::Accountability then
                        PageID := Page::"Accountability Card";
                end;
        // Database::"HRM Training Plan":
        //     begin
        //         CardPageID := Page::"HRM Training Plan Header";
        //     end;
        // Database::"Training Request":
        //     begin
        //         CardPageID := Page::"Training Request Card";
        //     end;
        // Database::"G/L Account":
        //     CardPageID := Page::"G/L Account Card";
        // Database::"Request Header":
        //     begin
        //         FieldRef := RecordRef.Field(1);
        //         DocTYpe := FieldRef.Value;
        //         if DocTYpe = DocTYpe::"Stores Requisition" then
        //             CardPageID := Page::"Stores Request Card";
        //     end;


        end;

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Time Sheet Approval Management", 'OnBeforeCheckApproverPermissions', '', false, false)]
    // local procedure OnBeforeCheckApproverPermissions(var IsHandled: Boolean)
    // begin
    //     IsHandled := true;
    // end;

    //Record Approval Requests
    [EventSubscriber(ObjectType::Codeunit, Codeunit::Subscriber, 'ApproveRecordRequest', '', false, false)]
    procedure ApproveRecordRequest(RecordID: RecordId)
    begin
        ApprovalMgt.ApproveRecordApprovalRequest(RecordID);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::Subscriber, 'RejectRecordApprovalRequest', '', false, false)]
    local procedure RejectRecordApprovalRequest(RecordID: RecordId)
    begin
        ApprovalMgt.RejectRecordApprovalRequest(RecordID);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::Subscriber, 'DelegateRecordApprovalRequest', '', false, false)]
    local procedure DelegateRecordApprovalRequest(RecordID: RecordId)
    begin
        ApprovalMgt.DelegateRecordApprovalRequest(RecordID);
    end;
    //Remove filter from approval entries page relating to user id so that approvers are able to see the approval history
    // [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeMarkAllWhereUserisApproverOrSender', '', false, false)]
    // local procedure OnBeforeMarkAllWhereUserisApproverOrSender(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    // begin
    //     IsHandled := true;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Advanced HR Processes", OnAfterCreateBodyOnSendTimeSheetNotifications, '', false, false)]
    // local procedure OnAfterCreateBodyOnSendTimeSheetNotifications(var Body: Text)
    // var
    //     ApprovalSetup: Record "Req Approval Setup";
    // begin
    //     IF ApprovalSetup."Approval Link Portal" <> '' then
    //         Body := Body + 'Please click on the link below to access the portal. <b><a href ="' + ApprovalSetup."Approval Link Portal" + '">Self Service Portal link</a></b>';
    // end;
}