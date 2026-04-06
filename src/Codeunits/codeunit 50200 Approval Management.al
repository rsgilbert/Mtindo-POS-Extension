codeunit 50200 "Approval Management"
{
    Permissions = tabledata "Approval Entry" = rimd;
    procedure SendRequest(var RecRef: RecordRef; SenderUserID: Code[50]): Boolean
    var

        UserSetup: Record "User Setup";
        WorkplanHeader: Record "WorkPlan Header";
        BdgtReallocationHeader: Record "Budget Realloc. Header";
        // PurchaseReqHeader: Record "Purchase Requisition Header";
        PurchaseHeader: Record "Purchase Header";
        salesHeader: Record "Sales Header";
        PaymentReqHeader: Record "Payment Requisition Header";
        AccountabilityHeader: Record "Accountability Header";
        // RequestHeader: Record "Request Header";
        AppTemplate: Record "Requisition Approval Templates";
        CurrExchRate: Record "Currency Exchange Rate";
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        BankAccountRecon: Record "Bank Acc. Reconciliation";
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        RecNo: Code[20];
        OrderNo: Code[20];
        lineNo: Integer;
        JnlBatch: Code[10];
        JnlTemplate: Code[10];
        FieldRef: FieldRef;
        Amount: Decimal;
        AmountLCY: Decimal;
        periodID: Code[20];
        // TimeSheetHeader: Record "Time Sheet Header";
        Txt001Err: Label 'You cannot submit an empty requisition without lines';
        Txt002Msg: Label 'Supporting documents are missing';
    begin
        IF NOT ApprovalSetup.GET() THEN
            ERROR(Text004);
        AmountLCY := 0;
        Amount := 0;
        case RecRef.Number of

            Database::"WorkPlan Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    if WorkplanHeader.Get(RecNo) then;
                    WorkplanHeader.CalcFields(Amount);

                    if CheckTemplate(RecRef.Number, RecNo, DocType::Workplan) then begin
                        IF NOT FindApprover(RecRef, Database::"WorkPlan Header", ApprovalSetup, TemplateRec, TemplateRec."Document Type"::Workplan, WorkplanHeader."No.", WorkplanHeader.Description, '', WorkplanHeader.Amount, WorkplanHeader.Amount, 0, '', '', '', WorkplanHeader."Shortcut Dimension 1 Code", WorkplanHeader."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
                            ERROR(Text010);
                        IF DispMessage THEN BEGIN
                            MESSAGE(MsgTxt001Err, FORMAT(DocType::Workplan), WorkplanHeader."No.");
                        END;
                    end;
                end;
            Database::"Budget Realloc. Header":
                begin

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    BdgtReallocationHeader.Reset();
                    BdgtReallocationHeader.SetRange("Document Type", DocType);
                    BdgtReallocationHeader.SetRange("No.", RecNo);
                    if BdgtReallocationHeader.FindFirst() then;
                    BdgtReallocationHeader.CalcFields("Total Amount");

                    if CheckTemplate(RecRef.Number, RecNo, DocType) then begin
                        IF NOT FindApprover(RecRef, Database::"Budget Realloc. Header", ApprovalSetup, TemplateRec, TemplateRec."Document Type"::"Budget Reallocation", BdgtReallocationHeader."No.", BdgtReallocationHeader.Purpose, '', BdgtReallocationHeader."Total Amount", BdgtReallocationHeader."Total Amount", 0, '', '', '', BdgtReallocationHeader."Global Dimension 1 Code", '', '', '', 0, SenderUserID) THEN
                            ERROR(Text010);
                        IF DispMessage THEN BEGIN
                            MESSAGE(MsgTxt001Err, FORMAT(DocType), BdgtReallocationHeader."No.");
                        END;
                    end;
                end;

            // Database::"Purchase Requisition Header":
            //     begin
            //         FieldRef := RecRef.Field(2);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(1);
            //         DocType := FieldRef.Value;
            //         PurchaseReqHeader.Reset();
            //         PurchaseReqHeader.SetRange("Document Type", DocType);
            //         PurchaseReqHeader.SetRange("No.", RecNo);
            //         if PurchaseReqHeader.FindFirst() then;
            //         PurchaseReqHeader.CalcFields(Amount);
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then begin
            //             IF NOT FindApprover(RecRef, Database::"Purchase Requisition Header", ApprovalSetup, TemplateRec, DocType, PurchaseReqHeader."No.", PurchaseReqHeader."Procurement Description", PurchaseReqHeader."Currency Code", PurchaseReqHeader.Amount, PurchaseReqHeader.Amount, 0, '', '', '', PurchaseReqHeader."Shortcut Dimension 1 Code", PurchaseReqHeader."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);

            //             IF DispMessage THEN BEGIN
            //                 MESSAGE(MsgTxt001Err, FORMAT(PurchaseReqHeader."Document Type"), PurchaseReqHeader."No.");
            //             END;
            //         END
            //     end;
            // Database::"Purchase Header":
            //     begin
            //         FieldRef := RecRef.Field(3);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(1);
            //         DocType := FieldRef.Value;
            //         PurchaseHeader.Reset();
            //         PurchaseHeader.SetRange("Document Type", DocType);
            //         PurchaseHeader.SetRange("No.", RecNo);
            //         PurchaseHeader.FindFirst();
            //         PurchaseHeader.CalcFields("Amount Including VAT");
            //         If PurchaseHeader."Currency Code" <> '' then
            //             AmountLCY := CurrExchRate.ExchangeAmtFCYToLCY(PurchaseHeader."Document Date", PurchaseHeader."Currency Code", PurchaseHeader."Amount Including VAT", PurchaseHeader."Currency Factor")
            //         else
            //             AmountLCY := PurchaseHeader."Amount Including VAT";
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then begin
            //             IF NOT FindApprover(RecRef, Database::"Purchase Header", ApprovalSetup, TemplateRec, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader."Posting Description", PurchaseHeader."Currency Code", PurchaseHeader."Amount Including VAT", AmountLCY, 0, '', '', '', PurchaseHeader."Shortcut Dimension 1 Code", PurchaseHeader."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //             IF DispMessage THEN BEGIN
            //                 MESSAGE(MsgTxt001Err, FORMAT(PurchaseHeader."Document Type"), PurchaseHeader."No.");
            //             END;
            //         END;
            //     end;
            Database::"Payment Requisition Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    FieldRef := RecRef.Field(8);
                    DocType := FieldRef.Value;
                    PaymentReqHeader.Reset();
                    PaymentReqHeader.SetRange("Document Type", DocType);
                    PaymentReqHeader.SetRange("No.", RecNo);
                    if PaymentReqHeader.FindFirst() then;
                    PaymentReqHeader.CalcFields("Total Amount");
                    if PaymentReqHeader."Currency Code" <> '' then
                        AmountLCY := CurrExchRate.ExchangeAmtFCYToLCY(PaymentReqHeader."Document Date", PaymentReqHeader."Currency Code", PaymentReqHeader."Total Amount", PaymentReqHeader."Currency Factor")
                    else
                        AmountLCY := PaymentReqHeader."Total Amount";
                    if CheckTemplate(RecRef.Number, RecNo, DocType) then
                        IF NOT FindApprover(RecRef, Database::"Payment Requisition Header", ApprovalSetup, TemplateRec, PaymentReqHeader."Document Type", PaymentReqHeader."No.", PaymentReqHeader.Purpose, PaymentReqHeader."Currency Code", PaymentReqHeader."Total Amount", AmountLCY, 0, PaymentReqHeader."Requestor Name", PaymentReqHeader."Payee Name", '', PaymentReqHeader."Global Dimension 1 Code", PaymentReqHeader."Global Dimension 2 Code", '', '', 0, SenderUserID) THEN
                            ERROR(Text010);
                    IF DispMessage THEN BEGIN
                        MESSAGE(MsgTxt001Err, FORMAT(PaymentReqHeader."Document Type"), PaymentReqHeader."No.");
                    END;
                end;
            Database::"Accountability Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    FieldRef := RecRef.Field(8);
                    DocType := FieldRef.Value;
                    AccountabilityHeader.Reset();
                    AccountabilityHeader.SetRange("Document Type", DocType);
                    AccountabilityHeader.SetRange("No.", RecNo);
                    AccountabilityHeader.FindFirst();
                    AccountabilityHeader.CalcFields("Total Amount");
                    if AccountabilityHeader."Currency Code" <> '' then
                        AmountLCY := CurrExchRate.ExchangeAmtFCYToLCY(AccountabilityHeader."Document Date", AccountabilityHeader."Currency Code", AccountabilityHeader."Total Amount", AccountabilityHeader."Currency Factor")
                    else
                        AmountLCY := AccountabilityHeader."Total Amount";
                    if CheckTemplate(RecRef.Number, RecNo, DocType) then
                        IF NOT FindApprover(RecRef, Database::"Accountability Header", ApprovalSetup, TemplateRec, AccountabilityHeader."Document Type", AccountabilityHeader."No.", AccountabilityHeader.Purpose, AccountabilityHeader."Currency Code", AccountabilityHeader."Total Amount", AmountLCY, 0, AccountabilityHeader."Requestor Name", AccountabilityHeader."Payee Name", '', AccountabilityHeader."Global Dimension 1 Code", AccountabilityHeader."Global Dimension 2 Code", '', '', 0, SenderUserID) THEN
                            ERROR(Text010);
                    IF DispMessage THEN BEGIN
                        MESSAGE(MsgTxt001Err, FORMAT(AccountabilityHeader."Document Type"), AccountabilityHeader."No.");
                    end;
                end;
            // Database::"Human Resource Header":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         DocType := FieldRef.Value;
            //         FieldRef := RecRef.Field(2);
            //         RecNo := FieldRef.Value;
            //         HumanResourceHeader.SetRange("Document Type", DocType);
            //         HumanResourceHeader.SetRange("No.", RecNo);
            //         HumanResourceHeader.FindFirst();
            //         if not FindApproverLeaveRequest(HumanResourceHeader."Employee No.", RecRef, Database::"Human Resource Header", DocType, RecNo, '', ApprovalSetup, '', '', UserSetup, 0, 0, '', AppTemplate, 0, HumanResourceHeader."Employee Name", '', HumanResourceHeader."Posting Description", PerformanceAppraisal."Shortcut Dimension 1 Code", PerformanceAppraisal."Shortcut Dimension 2 Code", SenderUserID) then
            //             IF DispMessage THEN BEGIN
            //                 MESSAGE(MsgTxt001Err, FORMAT(DocType), RecNo);
            //             end;

            //     end;
            // Database::"HRM Req. Employee Headers":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(18);
            //         DocType := FieldRef.Value;
            //         HRMReqEmpHeader.SetRange("Document Type", DocType);
            //         HRMReqEmpHeader.SetRange("No.", RecNo);
            //         HRMReqEmpHeader.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"HRM Req. Employee Headers", ApprovalSetup, TemplateRec, HRMReqEmpHeader."Document Type", HRMReqEmpHeader."No.", HRMReqEmpHeader.Description, '', 0, 0, 0, HRMReqEmpHeader."Requisitioner Name", '', '', HRMReqEmpHeader."Shortcut Dimension 1 Code", HRMReqEmpHeader."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(HRMReqEmpHeader."Document Type"), HRMReqEmpHeader."No.");
            //         end;
            //     end;
            // Database::"Exit Interview":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(27);
            //         DocType := FieldRef.Value;
            //         ExitInterview.SetRange("No.", RecNo);
            //         ExitInterview.findfirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Exit Interview", ApprovalSetup, TemplateRec, ExitInterview."Document Type", ExitInterview."No.", ExitInterview."Reasons for Leaving", '', 0, 0, 0, ExitInterview."Employee Name", '', '', ExitInterview."Shortcut Dimension 1 Code", ExitInterview."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(ExitInterview."Document Type"), ExitInterview."No.");
            //         end;
            //     end;
            // Database::"HRM Training Plan":
            //     begin
            //         FieldRef := RecRef.Field(11);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(35);
            //         DocType := FieldRef.Value;
            //         HRMTrainingPlan.SetRange("No.", RecNo);
            //         HRMTrainingPlan.SetRange("Approval Document Type", DocType);
            //         HRMTrainingPlan.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"HRM Training Plan", ApprovalSetup, TemplateRec, HRMTrainingPlan."Approval Document Type", HRMTrainingPlan."No.", HRMTrainingPlan."Training Description", '', 0, 0, 0, '', '', '', HRMTrainingPlan."Shortcut Dimension 1 Code", HRMTrainingPlan."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(HRMTrainingPlan."Approval Document Type"), HRMTrainingPlan."No.");
            //         end;
            //     end;
            // Database::"Training Request":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(2);
            //         DocType := FieldRef.Value;
            //         TrainingRequest.SetRange("No.", RecNo);
            //         TrainingRequest.SetRange("Approval Document Type", DocType);
            //         TrainingRequest.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Training Request", ApprovalSetup, TemplateRec, TrainingRequest."Approval Document Type", TrainingRequest."No.", TrainingRequest.Description, '', 0, 0, 0, TrainingRequest."Employee Name", '', '', TrainingRequest."Shortcut Dimension 1 Code", TrainingRequest."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(TrainingRequest."Approval Document Type"), TrainingRequest."No.");
            //         end;
            //     end;
            // Database::"Staff Handover":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(27);
            //         DocType := FieldRef.Value;
            //         StaffHandover.SetRange("Approval Document Type", DocType);
            //         StaffHandover.SetRange("No.", RecNo);
            //         StaffHandover.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Staff Handover", ApprovalSetup, TemplateRec, StaffHandover."Approval Document Type", StaffHandover."No.", 'Handover form for ' + StaffHandover."Employee Name", '', 0, 0, 0, StaffHandover."Employee Name", '', '', StaffHandover."Shortcut Dimension 1 Code", StaffHandover."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(StaffHandover."Approval Document Type"), StaffHandover."No.");
            //         end;
            //     end;
            // Database::"Personal Devt. Plan Header":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(15);
            //         DocType := FieldRef.Value;
            //         PersonalDevtPlan.SetRange("Approval Document Type", DocType);
            //         PersonalDevtPlan.SetRange("No.", RecNo);
            //         PersonalDevtPlan.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Personal Devt. Plan Header", ApprovalSetup, TemplateRec, PersonalDevtPlan."Approval Document Type", PersonalDevtPlan."No.", 'Development Plan form for ' + PersonalDevtPlan."Employee Name", '', 0, 0, 0, PersonalDevtPlan."Employee Name", '', '', PersonalDevtPlan."Shortcut Dimension 1 Code", PersonalDevtPlan."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(PersonalDevtPlan."Approval Document Type"), PersonalDevtPlan."No.");
            //         end;
            //     end;
            // Database::"HRM Employee Journal Line":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         JnlTemplate := FieldRef.Value;
            //         FieldRef := RecRef.Field(2);
            //         JnlBatch := FieldRef.value;
            //         FieldRef := RecRef.Field(3);
            //         lineNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(9);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(4);
            //         DocType := FieldRef.Value;
            //         HRMEmployeeJnlLine.SetRange("Journal Template Name", JnlTemplate);
            //         HRMEmployeeJnlLine.SetRange("Journal Batch Name", JnlBatch);
            //         HRMEmployeeJnlLine.SetRange("Line No.", lineNo);
            //         HRMEmployeeJnlLine.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"HRM Employee Journal Line", ApprovalSetup, TemplateRec, HRMEmployeeJnlLine."Approval Document Type", HRMEmployeeJnlLine."Document No.", HRMEmployeeJnlLine.Description, '', 0, 0, 0, '', '', '', HRMEmployeeJnlLine."Global Dimension 1 Code", HRMEmployeeJnlLine."Global Dimension 2 Code", JnlTemplate, JnlBatch, lineNo, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(HRMEmployeeJnlLine."Approval Document Type"), HRMEmployeeJnlLine."Document No.");
            //         end;
            //     end;
            // Database::"HRM Employee Journal Batch":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         JnlTemplate := FieldRef.Value;
            //         FieldRef := RecRef.Field(2);
            //         JnlBatch := FieldRef.Value;
            //         HRMEmployeeBatch.SetRange("Journal Template Name", JnlTemplate);
            //         HRMEmployeeBatch.SetRange(Name, JnlBatch);
            //         if HRMEmployeeBatch.FindFirst() then;
            //         if CheckTemplate(RecRef.Number, JnlBatch, DocType::"Leave Request") then begin
            //             IF NOT FindApprover(RecRef, Database::"HRM Employee Journal Batch", ApprovalSetup, TemplateRec, TemplateRec."Document Type"::"Leave Request", JnlBatch, 'Employee Journal Batch Approval : ' + JnlBatch, '', 0, 0, 0, '', '', '', '', '', JnlTemplate, JnlBatch, 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //             IF DispMessage THEN BEGIN
            //                 MESSAGE(MsgTxt001Err, FORMAT(DocType::"Leave Request"), JnlBatch);
            //             END;
            //         end;
            //     end;
            // Database::"Performance Header":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         RecNo := FieldRef.Value;
            //         FieldRef := RecRef.Field(41);
            //         DocType := FieldRef.Value;
            //         PerformanceAppraisal.SetRange("No.", RecNo);
            //         PerformanceAppraisal.SetRange("Document Type", DocType);
            //         if PerformanceAppraisal.FindFirst() then;
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Performance Header", ApprovalSetup, TemplateRec, PerformanceAppraisal."Document Type", PerformanceAppraisal."No.", 'Performance Appraisal for ' + PerformanceAppraisal."Appraisee Full Names", '', 0, 0, 0, PerformanceAppraisal."Appraisee Full Names", '', '', PerformanceAppraisal."Shortcut Dimension 1 Code", PerformanceAppraisal."Shortcut Dimension 2 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(PerformanceAppraisal."Document Type"), PerformanceAppraisal."No.");
            //         end;
            //     end;
            // Database::"Bank Acc. Reconciliation":
            //     begin
            //         FieldRef := RecRef.Field(50103);
            //         RecNo := FieldRef.Value;
            //         DocType := DocType::"Bank Reconciliation";
            //         BankAccountRecon.SetRange("Reconciliation No", RecNo);
            //         BankAccountRecon.FindFirst();
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Bank Acc. Reconciliation", ApprovalSetup, TemplateRec, DocType, BankAccountRecon."Reconciliation No", 'Bank Account Reconciliation for Bank ' + BankAccountRecon."Bank Account No.", '', BankAccountRecon."Statement Ending Balance", 0, 0, '', '', '', BankAccountRecon."Shortcut Dimension 1 Code", BankAccountRecon."Shortcut Dimension 1 Code", '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(DocType), BankAccountRecon."Reconciliation No");
            //         end;
            //     end;
            // Database::"Request Header":
            //     begin
            //         FieldRef := RecRef.Field(1);
            //         DocType := FieldRef.Value;
            //         FieldRef := RecRef.Field(2);
            //         RecNo := FieldRef.Value;
            //         RequestHeader.Reset();
            //         RequestHeader.SetRange("Document Type", DocType);
            //         RequestHeader.SetRange("No.", RecNo);
            //         if RequestHeader.FindFirst() then;
            //         if CheckTemplate(RecRef.Number, RecNo, DocType) then
            //             IF NOT FindApprover(RecRef, Database::"Request Header", ApprovalSetup, TemplateRec, DocType, RequestHeader."No.", RequestHeader.Purpose, '', 0, 0, 0, RequestHeader."Requestor Name", '', '', RequestHeader."Global Dimension 1 Code", '', '', '', 0, SenderUserID) THEN
            //                 ERROR(Text010);
            //         IF DispMessage THEN BEGIN
            //             MESSAGE(MsgTxt001Err, FORMAT(DocType), RecNo);
            //         end;
            //     end;
            Database::"G/L Account":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    if GLAccount.get(RecNo) then;
                    if CheckTemplate(RecRef.Number, RecNo, DocType::"G/L Account") then
                        IF NOT FindApprover(RecRef, Database::"G/L Account", ApprovalSetup, TemplateRec, DocType::"G/L Account", GLAccount."No.", 'Request approval for G/L account ' + GLAccount.Name, '', 0, 0, 0, '', '', '', '', '', '', '', 0, SenderUserID) THEN
                            ERROR(Text010);
                    IF DispMessage THEN BEGIN
                        MESSAGE(MsgTxt001Err, FORMAT(DocType::"G/L Account"), RecNo);
                    end;
                end;
        // Database::"Time Sheet Header":
        //     begin
        //         FieldRef := RecRef.Field(1);
        //         RecNo := FieldRef.Value;
        //         if TimeSheetHeader.Get(RecNo) then;
        //         if CheckTemplate(RecRef.Number, RecNo, DocType::"Time Sheets") then
        //             if not FindApprover(RecRef, Database::"Time Sheet Header", ApprovalSetup, TemplateRec, DocType::"Time Sheets", TimeSheetHeader."No.", 'Time sheets for ' + TimeSheetHeader.Description, '', 0, 0, 0, TimeSheetHeader."Resource Name", '', '', '', '', '', '', 0, SenderUserID) then
        //                 Error(Text010);
        //         if DispMessage then
        //             Message(MsgTxt001Err, Format(DocType::"Time Sheets"), RecNo);
        //     end;
        end;
    end;

    // procedure FindApproverLeaveRequest(EmployeeNo: Code[20]; RecRef: RecordRef; TableID: Integer; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; DocNo: Code[20]; SalespersonPurchaser: Code[10]; lvApprovalSetup: Record "Req Approval Setup"; ApproverId: Code[50]; ApprovalCode: Code[20]; UserSetup: Record "User Setup"; ApprovalAmount: Decimal; ApprovalAmountLCY: Decimal; CurrencyCode: Code[10]; AppTemplate: Record "Requisition Approval Templates"; ExeedAmountLCY: Decimal; Requestor: Text[100]; Payee: Text[100]; Narration: Text[100]; Dim1: Code[20]; Dim2: Code[20]; SenderUserID: Code[50]): Boolean
    // var
    //     lvEmployee: Record Employee;
    //     // lvOrganisationUnit: Record "HRM Org Units";
    //     ApproverEmployeeNo: list of [Code[20]];
    //     lvApproverEmployee: Record Employee;
    //     ArrayLoopCount: Integer;
    //     EntryApproved: Boolean;
    //     DocReleased: Boolean;
    //     ApprovalEntry: Record "Approval Entry";
    //     Status: Option Open,"Pending Approval",Approved,Rejected;
    // begin
    //     lvApprovalSetup.Get();
    //     Clear(ApproverEmployeeNo);
    //     ApproverEmployeeNo.Add(EmployeeNo);
    //     if EmployeeNo <> '' then begin
    //         lvEmployee.Reset();
    //         if lvEmployee.Get(EmployeeNo) then begin
    //             lvEmployee.TestField("Supervisor Employee No.");
    //             if not ApproverEmployeeNo.Contains(lvEmployee."Supervisor Employee No.") then
    //                 ApproverEmployeeNo.Add(lvEmployee."Supervisor Employee No.");

    //             lvOrganisationUnit.Reset();
    //             if lvOrganisationUnit.Get(lvEmployee."Org.Unit") then begin
    //                 lvOrganisationUnit.TestField("Emp in charge No.");
    //                 if not ApproverEmployeeNo.Contains(lvOrganisationUnit."Emp in charge No.") then
    //                     ApproverEmployeeNo.Add(lvOrganisationUnit."Emp in charge No.");
    //             end;
    //         end
    //     end;
    //     ArrayLoopCount := 0;
    //     if ApproverEmployeeNo.Count <> 0 then begin
    //         for ArrayLoopCount := 1 to ApproverEmployeeNo.Count do begin
    //             lvApproverEmployee.Reset();
    //             if lvApproverEmployee.Get(ApproverEmployeeNo.Get(ArrayLoopCount)) then begin
    //                 lvApproverEmployee.TestField("User ID");
    //                 MakeApprovalEntry(RecRef,
    //                                                    TableID, DocType, DocNo,
    //                                                    SalespersonPurchaser,
    //                                                    lvApprovalSetup, lvApproverEmployee."User ID", AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
    //                                                    CurrencyCode, AppTemplate, 0, Requestor, '', Narration, Dim1, Dim2, SenderUserID);
    //             end;
    //         end;
    //         EntryApproved := FALSE;
    //         DocReleased := FALSE;
    //         IsSenderSameAsApprover := false;
    //         ApprovalEntry.INIT;
    //         ApprovalEntry.SETRANGE("Table ID", TableID);
    //         ApprovalEntry.SETRANGE("Document Type", DocType);
    //         ApprovalEntry.SETRANGE("Document No.", DocNo);
    //         ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
    //         IF ApprovalEntry.FINDSET() THEN
    //             REPEAT
    //                 IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
    //                     ApprovalEntry.Status := ApprovalEntry.Status::Approved;
    //                     ApprovalEntry.MODIFY;
    //                 END ELSE
    //                     IF NOT IsOpenStatusSet THEN BEGIN
    //                         ApprovalEntry.Status := ApprovalEntry.Status::Open;
    //                         ApprovalEntry.MODIFY;
    //                         IsOpenStatusSet := TRUE;
    //                         IF lvApprovalSetup.Approvals THEN
    //                             ApprovalNotification.SendApprovalMail(ApprovalEntry);
    //                     END;
    //             UNTIL ApprovalEntry.NEXT = 0;
    //         ApprovalEntry.SETFILTER(Status, '=%1|%2|%3', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
    //         IF ApprovalEntry.FIND('-') THEN
    //             REPEAT
    //                 IF ApprovalEntry.Status = ApprovalEntry.Status::Approved THEN
    //                     EntryApproved := TRUE
    //                 ELSE
    //                     EntryApproved := FALSE;
    //             UNTIL ApprovalEntry.NEXT = 0;
    //         IF EntryApproved THEN begin
    //             IsSenderSameAsApprover := EntryApproved;
    //             DocReleased := ApproveApprovalRequest(ApprovalEntry);
    //         end;
    //         DispMessage := FALSE;
    //         IF NOT DocReleased THEN BEGIN
    //             ChangeDocumentStatus(TableID, DocNo, DocType, Status::"Pending Approval", RecRef.RecordId, false);
    //             DispMessage := TRUE;
    //         END;
    //         IF DocReleased THEN
    //             MESSAGE(Text003, DocType, DocNo);
    //         exit(DocReleased);

    //     end;

    // end;

    local procedure CheckTemplate(TableID: Integer; DocNo: Code[20]; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"): Boolean
    var
    begin
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE("Table ID", TableID);
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE(Enabled, TRUE);
        IF TemplateRec.FindFirst() then
            repeat
                // IF TemplateRec."Limit Type" = TemplateRec."Limit Type": THEN
                //     ERROR(STRSUBSTNO(Text025, FORMAT(TemplateRec."Limit Type"), FORMAT(DocType), DocNo))
                // ELSE
                exit(true);
            until TemplateRec.next() = 0
        ELSE
            ERROR(STRSUBSTNO(Text129, DocType))
    end;

    procedure MakeApprovalEntry(RecRef: RecordRef; TableID: Integer; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
                                                                                  DocNo: Code[20];
                                                                                  SalespersonPurchaser: Code[10];
                                                                                  lvApprovalSetup: Record "Req Approval Setup";
                                                                                  ApproverId: Code[50];
                                                                                  ApprovalCode: Code[20];
                                                                                  UserSetup: Record "User Setup";
                                                                                  ApprovalAmount: Decimal;
                                                                                  ApprovalAmountLCY: Decimal;
                                                                                  CurrencyCode: Code[10];
                                                                                  AppTemplate: Record "Requisition Approval Templates";
                                                                                  ExeedAmountLCY: Decimal;
                                                                                  Requestor: Text[100];
                                                                                  Payee: Text[100];
                                                                                  Narration: Text[100];
                                                                                  Dim1: Code[20];
                                                                                  Dim2: Code[20];
                                                                                  SenderUserID: Code[50])
    var
        ApprovalEntry: Record "Approval Entry";
        NewSequenceNo: Integer;
        NoOfIterations: Integer;
        NewWrkFlwSequenceNo: Integer;
        ApprovalEntry2: Record "Approval Entry";
        EntryNo: Integer;
        lvEmployee: Record Employee;
        //purchaseHdr: Record "Purchase Requisition Header";
        PaymentRq: Record "Payment Requisition Header";
        lvUser: Record User;
    begin
        Clear(EntryNo);
        ApprovalEntry2.Reset();
        if ApprovalEntry2.FindLast() then
            EntryNo := ApprovalEntry."Entry No."
        else
            EntryNo := 1;
        ApprovalEntry.Reset();
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", DocNo);
        IF ApprovalEntry.FIND('+') THEN
            NewSequenceNo := ApprovalEntry."Sequence No." + 1
        ELSE
            NewSequenceNo := 1;
        ApprovalEntry."Entry No." := EntryNo;
        ApprovalEntry."Table ID" := TableID;
        ApprovalEntry."Document Type" := DocType;
        ApprovalEntry."Document No." := DocNo;
        ApprovalEntry."Sequence No." := NewSequenceNo;
        ApprovalEntry."Approval Code" := ApprovalCode;
        ApprovalEntry."Sender ID" := SenderUserID;
        ApprovalEntry.Amount := ApprovalAmount;
        ApprovalEntry."Amount (LCY)" := ApprovalAmountLCY;
        ApprovalEntry."Currency Code" := CurrencyCode;
        ApprovalEntry."Approver ID" := ApproverId;
        ApprovalEntry.Purpose := Narration;
        ApprovalEntry."Payee Name" := Payee;
        ApprovalEntry."Global Dimension 1 Code" := Dim1;
        ApprovalEntry."Global Dimension 2 Code" := Dim2;
        ApprovalEntry."Requested By" := Requestor;
        IF ApproverId = SenderUserID THEN BEGIN
            ApprovalEntry.Status := ApprovalEntry.Status::Approved;
        END
        ELSE
            ApprovalEntry.Status := ApprovalEntry.Status::Created;
        ApprovalEntry."Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
        ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
        ApprovalEntry."Last Modified By User ID" := USERID;
        ApprovalEntry."Due Date" := CALCDATE(lvApprovalSetup."Due Date Formula", TODAY);
        ApprovalEntry."Approval Type" := AppTemplate."Approval Type";
        ApprovalEntry."Limit Type" := AppTemplate."Limit Type";
        ApprovalEntry."Available Credit Limit (LCY)" := ExeedAmountLCY;
        ApprovalEntry."Record ID to Approve" := RecRef.RecordId;

        //Add Approver's email.
        lvUser.Reset();
        lvUser.SetRange("User Name", ApprovalEntry."Approver ID");
        if lvUser.FindSet() then
            ApprovalEntry."Approver's Email" := lvUser."Authentication Email";
        ApprovalEntry.INSERT;
    end;

    procedure FindApprover(RecRef: RecordRef; TableID: Integer; ApprovalSetup: Record "Req Approval Setup"; AppTemplate: Record "Requisition Approval Templates"; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
                                                                                                                                                                               DocNo: Code[20];
                                                                                                                                                                               Description: Text[100];
                                                                                                                                                                               CurrencyCode: Code[20];
                                                                                                                                                                               ApprovalAmount: Decimal;
                                                                                                                                                                               ApprovalAmountLCY: Decimal;
                                                                                                                                                                               ExceedingAmountLCY: Decimal;
                                                                                                                                                                               Requestor: Text[100];
                                                                                                                                                                               PayeeName: Text[100];
                                                                                                                                                                               SalesPurchaseCode: Code[20];
                                                                                                                                                                               Dim1: Code[20];
                                                                                                                                                                               Dim2: Code[20];
                                                                                                                                                                               JnlTemplate: Code[10];
                                                                                                                                                                               JnlBatch: Code[10];
                                                                                                                                                                               LineNo: Integer;
                                                                                                                                                                               SenderUserID: Code[50]): Boolean
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        ApproverId: Code[50];
        EntryApproved: Boolean;
        DocReleased: Boolean;
        DepartmentalUserSetup: Record "Departmental User Setup";
        ReqApprovalDocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        ApprovalEntry2: Record "Approval Entry";
        Status: Option Open,"Pending Approval",Approved,Rejected;
    begin
        ApprovalSetup.GET;
        IF NOT ApprovalSetup."Departmental Level Approval" THEN BEGIN
            CASE AppTemplate."Approval Type" OF
                AppTemplate."Approval Type"::"Sales Pers./Purchaser":
                    BEGIN
                        IF SalesPurchaseCode <> '' THEN BEGIN
                            CASE AppTemplate."Limit Type" OF
                                AppTemplate."Limit Type"::"Approval Limits":
                                    BEGIN
                                        UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        UserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text008, UserSetup."User ID", UserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              UserSetup."Salespers./Purch. Code")
                                        ELSE BEGIN
                                            ApproverId := UserSetup."User ID";
                                            MakeApprovalEntry(RecRef,
                                               TableID, DocType, DocNo,
                                               SalesPurchaseCode,
                                               ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                               CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                            ApproverId := UserSetup."Approver ID";
                                            IF NOT UserSetup."Unlimited Purchase Approval" AND
                                               ((ApprovalAmountLCY > UserSetup."Purchase Amount Approval Limit") OR
                                                (UserSetup."Purchase Amount Approval Limit" = 0))
                                            THEN BEGIN
                                                UserSetup.RESET;
                                                UserSetup.SETCURRENTKEY("User ID");
                                                UserSetup.SETRANGE("User ID", ApproverId);
                                                REPEAT
                                                    IF NOT UserSetup.FIND('-') THEN
                                                        ERROR(Text006, ApproverId);
                                                    ApproverId := UserSetup."User ID";
                                                    MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                                    UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                                UNTIL UserSetup."Unlimited Purchase Approval" OR
                                                      ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND
                                                       (UserSetup."Purchase Amount Approval Limit" <> 0)) OR
                                                      (UserSetup."User ID" = UserSetup."Approver ID")
                                            END;
                                        END;
                                    END;

                                AppTemplate."Limit Type"::"Request Limits":
                                    BEGIN
                                        UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        UserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text008, UserSetup."User ID", UserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              UserSetup."Salespers./Purch. Code");
                                        UserSetup.RESET;
                                        UserSetup.SETRANGE("User ID", SenderUserID);
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, SenderUserID);
                                        ApproverId := UserSetup."User ID";

                                        MakeApprovalEntry(RecRef,
                                                  TableID, DocType, DocNo,
                                                  SalesPurchaseCode,
                                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                  CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                        IF NOT UserSetup."Unlimited Request Approval" AND
                                           ((ApprovalAmountLCY > UserSetup."Request Amount Approval Limit") OR
                                            (UserSetup."Request Amount Approval Limit" = 0))
                                        THEN
                                            REPEAT
                                                UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                                IF NOT UserSetup.FIND('-') THEN
                                                    ERROR(Text005, SenderUserID);
                                                ApproverId := UserSetup."User ID";

                                                MakeApprovalEntry(RecRef,
                                                  TableID, DocType, DocNo,
                                                  SalesPurchaseCode,
                                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                  CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                            UNTIL UserSetup."Unlimited Request Approval" OR
                                                  ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") AND
                                                   (UserSetup."Request Amount Approval Limit" <> 0)) OR
                                                  (UserSetup."User ID" = UserSetup."Approver ID");
                                    END;

                                AppTemplate."Limit Type"::"No Limits":
                                    BEGIN
                                        UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        UserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text008, UserSetup."User ID", UserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              UserSetup."Salespers./Purch. Code")
                                        ELSE BEGIN
                                            ApproverId := UserSetup."User ID";

                                            MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                        END;
                                    END;
                            END;
                        END;
                    END;
                AppTemplate."Approval Type"::Approver:
                    BEGIN
                        UserSetup.SETRANGE("User ID", SenderUserID);
                        IF NOT UserSetup.FIND('-') THEN
                            ERROR(Text005, SenderUserID);

                        CASE AppTemplate."Limit Type" OF
                            AppTemplate."Limit Type"::"Approval Limits":
                                BEGIN
                                    ApproverId := UserSetup."User ID";

                                    MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);


                                    IF NOT UserSetup."Unlimited Purchase Approval" AND
                                       ((ApprovalAmountLCY > UserSetup."Purchase Amount Approval Limit") OR
                                        (UserSetup."Purchase Amount Approval Limit" = 0))
                                    THEN
                                        REPEAT
                                            UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                            IF NOT UserSetup.FIND('-') THEN
                                                ERROR(Text005, USERID);
                                            ApproverId := UserSetup."User ID";
                                            MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode, ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY, CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);


                                        UNTIL UserSetup."Unlimited Purchase Approval" OR
                                              ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND
                                               (UserSetup."Purchase Amount Approval Limit" <> 0)) OR
                                              (UserSetup."User ID" = UserSetup."Approver ID");

                                END;

                            AppTemplate."Limit Type"::"Request Limits":
                                BEGIN
                                    UserSetup.SETRANGE("User ID", SenderUserID);
                                    IF NOT UserSetup.FIND('-') THEN
                                        ERROR(Text005, SenderUserID);
                                    ApproverId := UserSetup."User ID";

                                    MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                    IF NOT UserSetup."Unlimited Request Approval" AND
                                       ((ApprovalAmountLCY > UserSetup."Request Amount Approval Limit") OR
                                        (UserSetup."Request Amount Approval Limit" = 0))
                                    THEN
                                        REPEAT
                                            UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                            IF NOT UserSetup.FIND('-') THEN
                                                ERROR(Text005, USERID);
                                            ApproverId := UserSetup."User ID";
                                            MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);


                                        UNTIL UserSetup."Unlimited Request Approval" OR
                                              ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") AND
                                               (UserSetup."Request Amount Approval Limit" <> 0)) OR
                                              (UserSetup."User ID" = UserSetup."Approver ID");

                                END;

                            AppTemplate."Limit Type"::"No Limits":
                                BEGIN
                                    ApproverId := UserSetup."Approver ID";
                                    IF ApproverId = '' THEN
                                        ApproverId := UserSetup."User ID";
                                    MakeApprovalEntry(RecRef,
                                                          TableID, DocType, DocNo,
                                                          SalesPurchaseCode,
                                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                          CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                END;
                        END;
                    END;
            END;

        END ELSE BEGIN
            CASE AppTemplate."Approval Type" OF
                AppTemplate."Approval Type"::"Sales Pers./Purchaser":
                    BEGIN
                        IF SalesPurchaseCode <> '' THEN BEGIN
                            CASE AppTemplate."Limit Type" OF
                                AppTemplate."Limit Type"::"Approval Limits":
                                    BEGIN
                                        DepartmentalUserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        DepartmentalUserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                                            ERROR(Text008, DepartmentalUserSetup."User ID", DepartmentalUserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              DepartmentalUserSetup."Salespers./Purch. Code")
                                        ELSE BEGIN
                                            ApproverId := DepartmentalUserSetup."User ID";
                                            MakeApprovalEntry(RecRef,
                                                          TableID, DocType, DocNo,
                                                          SalesPurchaseCode,
                                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                          CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                            ApproverId := DepartmentalUserSetup."Approver ID";
                                            IF NOT IsSufficientApprover(DepartmentalUserSetup, DocType, ApprovalAmountLCY)
                                            THEN BEGIN
                                                DepartmentalUserSetup.RESET;
                                                DepartmentalUserSetup.SETCURRENTKEY("User ID");
                                                DepartmentalUserSetup.SETRANGE("User ID", ApproverId);
                                                DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                                DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                                REPEAT
                                                    IF NOT DepartmentalUserSetup.FIND('-') THEN
                                                        ERROR(Text006, ApproverId);
                                                    ApproverId := DepartmentalUserSetup."User ID";
                                                    MakeApprovalEntry(RecRef,
                                                          TableID, DocType, DocNo,
                                                          SalesPurchaseCode,
                                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                          CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                                    DepartmentalUserSetup.SETRANGE("User ID", DepartmentalUserSetup."Approver ID");
                                                    DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                                    DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                                UNTIL IsSufficientApprover(DepartmentalUserSetup, DocType, ApprovalAmountLCY)
                                            END;
                                        END;
                                    END;

                                AppTemplate."Limit Type"::"Request Limits":
                                    BEGIN
                                        DepartmentalUserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        DepartmentalUserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                                            ERROR(Text008, DepartmentalUserSetup."User ID", DepartmentalUserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              DepartmentalUserSetup."Salespers./Purch. Code");
                                        DepartmentalUserSetup.RESET;
                                        DepartmentalUserSetup.SETRANGE("User ID", SenderUserID);
                                        DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                                            ERROR(Text155, SenderUserID, DocType, Dim1);
                                        ApproverId := DepartmentalUserSetup."User ID";
                                        MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);


                                        IF NOT DepartmentalUserSetup."Unlimited Request Approval" AND
                                           ((ApprovalAmountLCY > DepartmentalUserSetup."Request Amount Approval Limit") OR
                                            (DepartmentalUserSetup."Request Amount Approval Limit" = 0))
                                        THEN
                                            REPEAT
                                                DepartmentalUserSetup.SETRANGE("User ID", DepartmentalUserSetup."Approver ID");
                                                DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                                DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                                IF NOT DepartmentalUserSetup.FIND('-') THEN
                                                    ERROR(Text155, DepartmentalUserSetup."Approver ID", DocType, Dim1);
                                                ApproverId := DepartmentalUserSetup."User ID";
                                                MakeApprovalEntry(RecRef,
                                                      TableID, DocType, DocNo,
                                                      SalesPurchaseCode,
                                                      ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                      CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                            UNTIL DepartmentalUserSetup."Unlimited Request Approval" OR
                                                  ((ApprovalAmountLCY <= DepartmentalUserSetup."Request Amount Approval Limit") AND
                                                   (DepartmentalUserSetup."Request Amount Approval Limit" <> 0)) OR
                                                  (DepartmentalUserSetup."User ID" = DepartmentalUserSetup."Approver ID");
                                    END;

                                AppTemplate."Limit Type"::"No Limits":
                                    BEGIN
                                        DepartmentalUserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                        DepartmentalUserSetup.SETRANGE("Salespers./Purch. Code", SalesPurchaseCode);
                                        DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", '');

                                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                                            ERROR(Text008, DepartmentalUserSetup."User ID", DepartmentalUserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                                              DepartmentalUserSetup."Salespers./Purch. Code")
                                        ELSE BEGIN
                                            ApproverId := DepartmentalUserSetup."User ID";
                                            MakeApprovalEntry(RecRef,
                                                           TableID, DocType, DocNo,
                                                           SalesPurchaseCode,
                                                           ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                           CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);
                                        END;
                                    END;
                            END;
                        END;
                    END;

                AppTemplate."Approval Type"::Approver:
                    BEGIN
                        DepartmentalUserSetup.SETRANGE("User ID", SenderUserID);
                        DepartmentalUserSetup.SETRANGE(DepartmentalUserSetup."Document Type", DocType);
                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", dim1);

                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                            ERROR(Text155, SenderUserID, DocType, Dim1);

                        CASE AppTemplate."Limit Type" OF
                            AppTemplate."Limit Type"::"Approval Limits":
                                BEGIN
                                    ApproverId := DepartmentalUserSetup."User ID";

                                    MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode,
                                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                    CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                    IF NOT IsSufficientApprover(DepartmentalUserSetup, DocType, ApprovalAmountLCY)
                                    THEN
                                        REPEAT
                                            DepartmentalUserSetup.SETRANGE("User ID", DepartmentalUserSetup."Approver ID");
                                            DepartmentalUserSetup.SETRANGE(DepartmentalUserSetup."Document Type", DocType);
                                            DepartmentalUserSetup.SETRANGE("Approval Dimension Code", Dim1); //SEJ

                                            IF NOT DepartmentalUserSetup.FIND('-') THEN
                                                ERROR(Text155, DepartmentalUserSetup."Approver ID", DocType, Dim1);

                                            ApproverId := DepartmentalUserSetup."User ID";

                                            //Skipping line for the limit
                                            // IF (DepartmentalUserSetup."Purchase Amount Approval Limit" = 0) OR
                                            // ((ApprovalAmountLCY <= DepartmentalUserSetup."Purchase Amount Approval Limit") AND (DepartmentalUserSetup."Purchase Amount Approval Limit" <> 0)) then
                                            MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode, ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY, CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                        UNTIL IsSufficientApprover(DepartmentalUserSetup, DocType, ApprovalAmountLCY);

                                END;

                            AppTemplate."Limit Type"::"Request Limits":
                                BEGIN
                                    IF ReqApprovalDocType <> DocType THEN
                                        ERROR(STRSUBSTNO(Text026, FORMAT(AppTemplate."Limit Type"), FORMAT
                                        (DocType)))
                                    ELSE BEGIN
                                        DepartmentalUserSetup.SETRANGE("User ID", SenderUserID);
                                        DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                        DepartmentalUserSetup.SETRANGE("Approval Dimension Code", Dim1);

                                        IF NOT DepartmentalUserSetup.FIND('-') THEN
                                            ERROR(Text155, SenderUserID, DocType, Dim1);
                                        ApproverId := DepartmentalUserSetup."User ID";

                                        MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode,
                                                   ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                   CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                        IF NOT DepartmentalUserSetup."Unlimited Request Approval" AND
                                           ((ApprovalAmountLCY > DepartmentalUserSetup."Request Amount Approval Limit") OR
                                            (DepartmentalUserSetup."Request Amount Approval Limit" = 0))
                                        THEN
                                            REPEAT
                                                DepartmentalUserSetup.SETRANGE("User ID", DepartmentalUserSetup."Approver ID");
                                                DepartmentalUserSetup.SETRANGE("Document Type", DocType);
                                                DepartmentalUserSetup.SETRANGE("Approval Dimension Code", Dim1);

                                                IF NOT DepartmentalUserSetup.FIND('-') THEN
                                                    ERROR(Text155, DepartmentalUserSetup."Approver ID", DocType, Dim1);
                                                ApproverId := DepartmentalUserSetup."User ID";
                                                MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode,
                                                   ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                   CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);

                                            UNTIL DepartmentalUserSetup."Unlimited Request Approval" OR
                                                  ((ApprovalAmountLCY <= DepartmentalUserSetup."Request Amount Approval Limit") AND
                                                   (DepartmentalUserSetup."Request Amount Approval Limit" <> 0)) OR
                                                  (DepartmentalUserSetup."User ID" = DepartmentalUserSetup."Approver ID");
                                    END;
                                END;

                            AppTemplate."Limit Type"::"No Limits":
                                BEGIN
                                    ApproverId := DepartmentalUserSetup."Approver ID";
                                    IF ApproverId = '' THEN
                                        ApproverId := DepartmentalUserSetup."User ID";
                                    MakeApprovalEntry(RecRef, TableID, DocType, DocNo, SalesPurchaseCode,
                                                   ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                                   CurrencyCode, AppTemplate, 0, Requestor, '', Description, Dim1, Dim2, SenderUserID);
                                END;
                        END;
                    END;
            END;


        END; //Departmental Approvals

        EntryApproved := FALSE;
        DocReleased := FALSE;
        IsSenderSameAsApprover := false;
        ApprovalEntry.INIT;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", DocNo);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.FINDSET() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        IF ApprovalSetup.Approvals THEN
                            ApprovalNotification.SendApprovalMail(ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;
        ApprovalEntry.SETFILTER(Status, '=%1|%2|%3', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FIND('-') THEN
            REPEAT
                IF ApprovalEntry.Status = ApprovalEntry.Status::Approved THEN
                    EntryApproved := TRUE
                ELSE
                    EntryApproved := FALSE;
            UNTIL ApprovalEntry.NEXT = 0;
        IF EntryApproved THEN begin
            IsSenderSameAsApprover := EntryApproved;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;
        DispMessage := FALSE;
        IF NOT DocReleased THEN BEGIN
            ChangeDocumentStatus(TableID, DocNo, DocType, Status::"Pending Approval", RecRef.RecordId, false);
            DispMessage := TRUE;
        END;
        IF DocReleased THEN
            MESSAGE(Text003, DocType, DocNo);

        EXIT(TRUE);

    end;

    procedure IsSufficientApprover(DepartmentUserSetup: Record "Departmental User Setup"; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; ApprovalAmountLCY: Decimal): Boolean
    begin
        if DepartmentUserSetup."User ID" = DepartmentUserSetup."Approver ID" then
            exit(true);
        case DocType of
            DocType::"Purchase Requisition":
                if DepartmentUserSetup."Unlimited Purchase Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Purchase Amount Approval Limit") and (DepartmentUserSetup."Purchase Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::Order:
                if DepartmentUserSetup."Unlimited Purchase Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Purchase Amount Approval Limit") and (DepartmentUserSetup."Purchase Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::Invoice:
                if DepartmentUserSetup."Unlimited Purchase Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Purchase Amount Approval Limit") and (DepartmentUserSetup."Purchase Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::"Payment Requisition":
                if DepartmentUserSetup."Unlimited Payment Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Payment Amount Approval Limit") and (DepartmentUserSetup."Payment Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::"Travel Requests":
                if DepartmentUserSetup."Unlimited Payment Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Payment Amount Approval Limit") and (DepartmentUserSetup."Payment Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::"Payment Voucher":
                if DepartmentUserSetup."Unlimited Payment Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Payment Amount Approval Limit") and (DepartmentUserSetup."Payment Amount Approval Limit" <> 0)) then
                    exit(true);
            DocType::"Petty Cash":
                if DepartmentUserSetup."Unlimited Payment Approval" or ((ApprovalAmountLCY <= DepartmentUserSetup."Payment Amount Approval Limit") and (DepartmentUserSetup."Payment Amount Approval Limit" <> 0)) then
                    exit(true);
        end;
        exit(false);
    end;

    procedure ChangeDocumentStatus(TableID: Integer; DocNo: Code[20]; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; Status: Option Open,"Pending Approval",Approved,Rejected;
                                                                                   RecID: RecordId;
                                                                                   SenderSimilarToApprover: Boolean)
    var
        WorkplanHeader: Record "WorkPlan Header";
        BdgtReallocationHeader: Record "Budget Realloc. Header";
        // PurchaseReqHeader: Record "Purchase Requisition Header";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        PurchaseLine: Record "Purchase Line";
        PaymentReqHeader: Record "Payment Requisition Header";
        AccountabilityHeader: Record "Accountability Header";
        // lvPayrollHeader: Record "Payroll Header";
        // HRHeader: Record "Human Resource Header";
        // HRMReqEmpHeader: Record "HRM Req. Employee Headers";
        // ExitInterview: Record "Exit Interview";
        // HRMTrainingPlan: Record "HRM Training Plan";
        // TrainingRequest: Record "Training Request";
        // StaffHandover: Record "Staff Handover";
        // PersonalDevtPlan: Record "Personal Devt. Plan Header";
        // PerformanceHeader: Record "Performance Header";
        // HRMEmpJnlLine: Record "HRM Employee Journal Line";
        // HRMJournalBatch: Record "HRM Employee Journal Batch";
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        GlAccount: Record "G/L Account";
        BankAccountRecon: Record "Bank Acc. Reconciliation";
        lvGenReqSetup: Record "Gen. Requisition Setup";
        // RequestHeader: Record "Request Header";
        // TimeSheetHeader: Record "Time Sheet Header";
        // TimeSheetLine: Record "Time Sheet Line";
        // TimeSheetMgt: Codeunit "Time Sheet Management";
        ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject;
        // TimesheetApprovalMgt: Codeunit "Time Sheet Approval Management";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        lineNo: Integer;
    begin
        lvGenReqSetup.Get();
        case TableID of
            // Database::"Payroll Header":
            //     begin
            //         lvPayrollHeader.SetRange("Payroll ID", DocNo);
            //         if lvPayrollHeader.FindSet() then
            //             repeat
            //                 lvPayrollHeader.Status := Status;
            //                 lvPayrollHeader.Modify();
            //             until lvPayrollHeader.Next() = 0;
            //     end;
            Database::"WorkPlan Header":
                if WorkplanHeader.get(DocNo) then begin
                    WorkplanHeader.Status := Status;
                    WorkplanHeader.Modify();
                end;
            Database::"Budget Realloc. Header":
                begin
                    BdgtReallocationHeader.SetRange("Document Type", DocType);
                    BdgtReallocationHeader.SetRange("No.", DocNo);
                    if BdgtReallocationHeader.FindFirst() then begin
                        BdgtReallocationHeader.Status := Status;
                        BdgtReallocationHeader.Modify();
                    end;
                end;
            // Database::"Purchase Requisition Header":
            //     begin
            //         PurchaseReqHeader.SetRange("Document Type", DocType);
            //         PurchaseReqHeader.SetRange("No.", DocNo);
            //         if PurchaseReqHeader.FindFirst() then begin
            //             PurchaseReqHeader.Status := Status;
            //             if PurchaseReqHeader.Status = PurchaseReqHeader.Status::Approved then
            //                 if format(lvGenReqSetup."Purchase Req Due Date formula") <> '' then
            //                     PurchaseReqHeader."Over due Date" := CalcDate('<+' + format(lvGenReqSetup."Purchase Req Due Date formula") + '>', Today);
            //             PurchaseReqHeader.Modify();
            //             PurchaseReqHeader.UpdateLineStatus(PurchaseReqHeader);
            //         end;
            //     end;
            // Database::"Purchase Header":
            //     begin
            //         PurchaseHeader.SetRange("Document Type", DocType);
            //         PurchaseHeader.SetRange("No.", DocNo);
            //         if PurchaseHeader.FindFirst() then begin
            //             if Status = Status::Open then
            //                 PurchaseHeader.Status := PurchaseHeader.Status::Open
            //             else
            //                 if Status = Status::"Pending Approval" then
            //                     PurchaseHeader.Status := PurchaseHeader.Status::"Pending Approval"
            //                 else
            //                     if Status = Status::Approved then
            //                         PurchaseHeader.Status := PurchaseHeader.Status::Released;
            //             PurchaseHeader.Modify();
            //             PurchaseHeader.UpdateLineStatus(PurchaseHeader);
            //         end;
            //     end;
            Database::"Payment Requisition Header":
                begin
                    PaymentReqHeader.SetRange("Document Type", DocType);
                    PaymentReqHeader.SetRange("No.", DocNo);
                    if PaymentReqHeader.FindFirst() then begin
                        PaymentReqHeader.Status := Status;
                        PaymentReqHeader.Modify();
                        PaymentReqHeader.UpdateLineStatus(PaymentReqHeader);
                    end;
                end;
            Database::"Accountability Header":
                begin
                    AccountabilityHeader.SetRange("Document Type", DocType);
                    AccountabilityHeader.SetRange("No.", DocNo);
                    if AccountabilityHeader.FindFirst() then begin
                        AccountabilityHeader.Status := Status;
                        AccountabilityHeader.Modify();
                    end;
                end;

            // Database::"Human Resource Header":
            //     begin
            //         HRHeader.SetRange("Document Type", DocType);
            //         HRHeader.SetRange("No.", DocNo);
            //         if HRHeader.FindFirst() then begin
            //             HRHeader.validate(Status, Status);
            //             HRHeader.Modify();
            //         end;
            //     end;
            // Database::"HRM Req. Employee Headers":
            //     begin
            //         HRMReqEmpHeader.SetRange("Document Type", DocType);
            //         HRMReqEmpHeader.SetRange("No.", DocNo);
            //         if HRMReqEmpHeader.FindFirst() then begin
            //             HRMReqEmpHeader.Status := Status;
            //             HRMReqEmpHeader.Modify();
            //         end;
            //     end;
            // Database::"Exit Interview":
            //     begin
            //         ExitInterview.SetRange("No.", DocNo);
            //         ExitInterview.SetRange("Document Type", DocType);
            //         if ExitInterview.FindFirst() then begin
            //             ExitInterview.Status := Status;
            //             ExitInterview.Modify();
            //         end;
            //     end;
            // Database::"HRM Training Plan":
            //     begin
            //         HRMTrainingPlan.SetRange("No.", DocNo);
            //         HRMTrainingPlan.SetRange("Approval Document Type", DocType);
            //         if HRMTrainingPlan.FindFirst() then begin
            //             HRMTrainingPlan.Status := Status;
            //             HRMTrainingPlan.Modify();
            //         end;
            //     end;
            // Database::"Training Request":
            //     begin
            //         TrainingRequest.SetRange("Approval Document Type", DocType);
            //         TrainingRequest.SetRange("No.", DocNo);
            //         if TrainingRequest.FindSet() then begin
            //             TrainingRequest.Status := Status;
            //             TrainingRequest.Modify();
            //         end;
            //     end;
            // Database::"Staff Handover":
            //     begin
            //         StaffHandover.SetRange("Approval Document Type", DocType);
            //         StaffHandover.SetRange("No.", DocNo);
            //         if StaffHandover.FindFirst() then begin
            //             StaffHandover.Status := Status;
            //             StaffHandover.Modify();
            //         end;
            //     end;
            // Database::"Personal Devt. Plan Header":
            //     begin
            //         PersonalDevtPlan.SetRange("Approval Document Type", DocType);
            //         PersonalDevtPlan.SetRange("No.", DocNo);
            //         if PersonalDevtPlan.FindFirst() then begin
            //             PersonalDevtPlan.Status := Status;
            //             PersonalDevtPlan.Modify();
            //         end;
            //     end;
            // Database::"Performance Header":
            //     begin
            //         PerformanceHeader.SetRange("Document Type", DocType);
            //         PerformanceHeader.SetRange("No.", DocNo);
            //         if PerformanceHeader.FindFirst() then begin
            //             PerformanceHeader.Status := Status;
            //             PerformanceHeader.Modify();
            //         end;
            //     end;
            // Database::"HRM Employee Journal Line":
            //     begin
            //         HRMEmpJnlLine.SetRange("Approval Document Type", DocType);
            //         HRMEmpJnlLine.SetRange("Document No.", DocNo);
            //         if HRMEmpJnlLine.FindFirst() then
            //             repeat
            //                 HRMEmpJnlLine.Status := Status;
            //                 HRMEmpJnlLine.Modify();
            //             until HRMEmpJnlLine.Next() = 0;
            //     end;
            // Database::"HRM Employee Journal Batch":
            //     begin
            //         RecRef.Get(RecID);
            //         RecRef.SetTable(HRMJournalBatch);
            //         Message('Journal Template %1, Journal Batch %2', HRMJournalBatch."Journal Template Name", HRMJournalBatch.Name);
            //         HRMEmpJnlLine.SetRange("Journal Template Name", HRMJournalBatch."Journal Template Name");
            //         HRMEmpJnlLine.SetRange("Journal Batch Name", HRMJournalBatch.Name);
            //         if HRMEmpJnlLine.FindSet() then
            //             repeat
            //                 HRMEmpJnlLine.Status := Status;
            //                 HRMEmpJnlLine.Modify();
            //             until HRMEmpJnlLine.Next() = 0;
            //     end;
            // Database::"Bank Acc. Reconciliation":
            //     begin
            //         BankAccountRecon.SetRange("Reconciliation No", DocNo);
            //         if BankAccountRecon.FindFirst() then begin
            //             BankAccountRecon.Status := Status;
            //             BankAccountRecon.Modify();
            //         end;
            //     end;
            // Database::"Request Header":
            //     begin
            //         RequestHeader.SetRange("Document Type", DocType);
            //         RequestHeader.SetRange("No.", DocNo);
            //         if RequestHeader.FindFirst() then begin
            //             if Status = Status::Open then
            //                 RequestHeader.Status := RequestHeader.Status::Open
            //             else
            //                 if Status = Status::"Pending Approval" then
            //                     RequestHeader.Status := RequestHeader.Status::"Pending Approval"
            //                 else
            //                     if Status = Status::Approved then
            //                         RequestHeader.Status := RequestHeader.Status::Released;
            //             RequestHeader.Modify();
            //         end;
            //     end;
            Database::"G/L Account":
                begin
                    GlAccount.Reset();
                    if GlAccount.Get(DocNo) then begin
                        GlAccount.Status := Status;
                        GlAccount.Modify();
                    end;
                end;
        // Database::"Time Sheet Header":
        //     begin
        //         case Status of
        //             Status::"Pending Approval":
        //                 ActionType := ActionType::Submit;
        //             Status::Open:
        //                 ActionType := ActionType::ReopenSubmitted;
        //             Status::Approved:
        //                 ActionType := ActionType::Approve
        //         end;
        //         TimeSheetHeader.Reset();
        //         if TimeSheetHeader.Get(DocNo) then begin
        //             TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        //             if IsSenderSameAsApprover then
        //                 TimeSheetMgt.FilterAllTimeSheetLines(TimeSheetLine, ActionType::Submit)
        //             else
        //                 TimeSheetMgt.FilterAllTimeSheetLines(TimeSheetLine, ActionType);
        //             if TimeSheetLine.FindSet() then
        //                 repeat
        //                     if IsSenderSameAsApprover then begin
        //                         TimeSheetApprovalMgt.ProcessAction(TimeSheetLine, ActionType::Submit);
        //                         TimesheetApprovalMgt.ProcessAction(TimeSheetLine, ActionType);
        //                     end
        //                     else
        //                         TimeSheetApprovalMgt.ProcessAction(TimeSheetLine, ActionType);
        //                 until TimeSheetLine.Next() = 0
        //             else begin
        //                 Error('There are no time sheet lines to process in %1 action.', Format(ActionType));
        //             end;
        //         end;
        //     end;
        end;
    end;

    procedure CancelApprovalRequest(RecRef: RecordRef; TableID: Integer; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; DocNo: Code[20];
                                                                                      ShowMessage: Boolean;
                                                                                      ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalSetup: Record "Req Approval Setup";
        //AppManagement: Codeunit "Req Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
        OutCome: Text[50];
        Descrip: Text[30];
        ApproverID: Code[20];
        UserSetup: Record "User Setup";
        CurrencyFactor: Decimal;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        gvPurchLine: Record "Purchase Line";
        // NFLRequisitionLine: Record "Purchase Requisition Line";
        // gvNFLRequisitionLine: Record "Purchase Requisition Line";
        Status: Option Open,"Pending Approval",Approved,Rejected;
    begin
        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);
        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", DocNo);
        ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
        SendMail := FALSE;
        MailCreated := false;
        IF ApprovalEntry.FIND('-') THEN BEGIN
            REPEAT
                IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                   (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                    SendMail := TRUE;
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                ApprovalEntry."Last Modified By User ID" := USERID;
                ApprovalEntry.MODIFY;
                IF ApprovalSetup.Cancellations and (ApprovalEntry."Approver ID" <> ApprovalEntry."Sender ID") then BEGIN
                    ApprovalNotification.CancelApprovalMail(ApprovalEntry, MailCreated);
                    MailCreated := true;
                END;
            UNTIL ApprovalEntry.NEXT = 0;
            ChangeDocumentStatus(ApprovalEntry."Table ID", ApprovalEntry."Document No.", ApprovalEntry."Document Type", Status::Open, ApprovalEntry."Record ID to Approve", false);
            if MailCreated and ApprovalSetup.Cancellations then begin
                ApprovalNotification.SendMail(SendMail);
                MailCreated := false;
            end;
            IF ShowMessage THEN
                MESSAGE(Txt002Err, DocType, DocNo);

        END;
    end;


    // procedure CalcPurchaseDocAmount(PurchaseHeader: Record "Purchase Requisition Header"; var ApprovalAmount: Decimal; var ApprovalAmountLCY: Decimal)
    // var
    //     PurchasePost: Codeunit "Purch.-Post";
    //     TempAmount: Decimal;
    //     VAtText: Text[30];
    //     ReqnLine: Record "Purchase Requisition Line";
    //     CurrencyXRate: Record "Currency Exchange Rate";
    // begin
    //     PurchaseHeader.TestField("Procurement Description");
    //     ReqnLine.SETFILTER("Document Type", FORMAT(PurchaseHeader."Document Type"));
    //     ReqnLine.SETFILTER("Document No", PurchaseHeader."No.");
    //     IF ReqnLine.FINDFIRST THEN
    //         REPEAT
    //             ApprovalAmount += ReqnLine."Line Amount";
    //             IF PurchaseHeader."Currency Code" = '' THEN
    //                 ApprovalAmountLCY += ReqnLine."Line Amount"
    //             ELSE
    //                 ApprovalAmountLCY += CurrencyXRate.ExchangeAmtFCYToLCY(PurchaseHeader."Posting Date",
    //                     PurchaseHeader."Currency Code", ReqnLine."Line Amount", PurchaseHeader."Currency Factor");
    //         UNTIL ReqnLine.NEXT() = 0;
    // end;

    procedure ApproveApprovalRequest(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        ApprovalSetup: Record "Req Approval Setup";
        GenReqSetup: Record "Gen. Requisition Setup";
        NextApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        OutCome: Text[50];
        Descrip: Text[30];
        MailCreated: Boolean;
        RecID: RecordId;
        RecRef: RecordRef;
        Status: Option Open,"Pending Approval",Approved,Rejected;
    begin
        ApprovalSetup.Get();
        GenReqSetup.Get();
        IF ApprovalEntry."Table ID" <> 0 THEN BEGIN
            ApprovalEntry.Status := ApprovalEntry.Status::Approved;
            ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
            ApprovalEntry."Last Modified By User ID" := USERID;
            ApprovalEntry.MODIFY;


            NextApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.");
            NextApprovalEntry.SETRANGE("Table ID", ApprovalEntry."Table ID");
            NextApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type");
            NextApprovalEntry.SETRANGE("Document No.", ApprovalEntry."Document No.");
            NextApprovalEntry.SETFILTER(Status, '%1|%2', NextApprovalEntry.Status::Created, NextApprovalEntry.Status::Open);
            IF NextApprovalEntry.FIND('-') THEN BEGIN
                IF NextApprovalEntry.Status = NextApprovalEntry.Status::Open THEN
                    EXIT(FALSE)
                ELSE BEGIN
                    NextApprovalEntry.Status := NextApprovalEntry.Status::Open;
                    NextApprovalEntry."Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
                    NextApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    NextApprovalEntry."Last Modified By User ID" := USERID;
                    NextApprovalEntry.MODIFY;
                    IF ApprovalSetup.Approvals THEN BEGIN
                        ApprovalNotification.SendApprovalMail(NextApprovalEntry);
                    END;

                    EXIT(FALSE);
                END;
            END ELSE BEGIN
                ChangeDocumentStatus(ApprovalEntry."Table ID", ApprovalEntry."Document No.", ApprovalEntry."Document Type", Status::Approved, ApprovalEntry."Record ID to Approve", IsSenderSameAsApprover);
                if ApprovalSetup.Approvals then begin
                    ApprovalNotification.RequestApprovedMail(ApprovalEntry);
                    if ApprovalEntry."Document Type" = ApprovalEntry."Document Type"::"Purchase Requisition" then
                        ApprovalNotification.SendProcurementTeamMail(ApprovalEntry);
                end;
                RecID := ApprovalEntry."Record ID to Approve";
                OnAfterApproveRequestEntry(ApprovalEntry, RecID);
                EXIT(TRUE);
            END;
        END;

    end;

    procedure RejectApprovalRequest(ApprovalEntry: Record "Approval Entry"; RejectionComment: Text)
    var
        SendMail: Boolean;
        ApproverId: Code[20];
        OutCome: Text[50];
        Descrip: Text[30];
        MailCreated: Boolean;
        RecID: RecordId;
        RecRef: RecordRef;
        Status: Option Open,"Pending Approval",Approved,Rejected;
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        IF ApprovalEntry."Table ID" <> 0 THEN BEGIN
            ApprovalSetup.GET;
            ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
            ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
            ApprovalEntry."Last Modified By User ID" := USERID;
            ApprovalEntry.MODIFY;
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", ApprovalEntry."Table ID");
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type");
            ApprovalEntry.SETRANGE("Document No.", ApprovalEntry."Document No.");

            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
            SendMail := FALSE;
            MailCreated := false;
            IF ApprovalEntry.FIND('-') THEN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;

                    ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
                    ApprovalEntry."Rejection Comment" := RejectionComment;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY();

                    IF ApprovalSetup.Rejections AND (ApprovalEntry."Approver ID" <> ApprovalEntry."Sender ID") THEN
                        ApprovalNotification.RejectionMail(ApprovalEntry, MailCreated);

                UNTIL ApprovalEntry.NEXT = 0;

            ChangeDocumentStatus(ApprovalEntry."Table ID", ApprovalEntry."Document No.", ApprovalEntry."Document Type", Status::Open, ApprovalEntry."Record ID to Approve", false);

            if MailCreated and ApprovalSetup.Rejections then begin
                ApprovalNotification.SendMail(SendMail);
                MailCreated := false;
            end;

            ApprovalCommentLine.Reset();
            ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
            ApprovalCommentLine.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalCommentLine.SetRange("New Comment", true);
            if ApprovalCommentLine.FindSet() then
                repeat
                    ApprovalCommentLine."New Comment" := false;
                    ApprovalCommentLine.Modify();
                until ApprovalCommentLine.Next() = 0;

        END;
    end;

    procedure ShowApprovalComments(Variant: Variant; ActionName: Text)
    var
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalEntry: Record "Approval Entry";
        ApprovalComments: Page "Approval Comments";
        RecRef: RecordRef;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        DocNo: Code[20];
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    RecRef.Get(ApprovalEntry.RecordId);
                    ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
                    ApprovalCommentLine.SetRange("User ID", ApprovalEntry."Approver ID");
                    ApprovalCommentLine.SetRange("Document Type", ApprovalEntry."Document Type");
                    ApprovalCommentLine.SetRange("Document No.", ApprovalEntry."Document No.");
                    ApprovalCommentLine.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
                end;
            DATABASE::"Purchase Header":
                begin
                    ApprovalCommentLine.SetRange("Table ID", RecRef.Number);
                    ApprovalCommentLine.SetRange("Record ID to Approve", RecRef.RecordId);
                    FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RecordId);
                end;
            DATABASE::"Sales Header":
                begin
                    ApprovalCommentLine.SetRange("Table ID", RecRef.Number);
                    ApprovalCommentLine.SetRange("Record ID to Approve", RecRef.RecordId);
                    FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RecordId);
                end;

            else
                SetCommonApprovalCommentLineFilters(RecRef, ApprovalEntry, ApprovalCommentLine);
        end;
        if RecRef.Number = Database::"Approval Entry" then begin
            ApprovalComments.SetTableView(ApprovalCommentLine);
            if ApprovalComments.RunModal() = ACTION::OK then begin
                ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
                ApprovalCommentLine.SetRange("Document Type", ApprovalEntry."Document Type");
                ApprovalCommentLine.SetRange("Document No.", ApprovalEntry."Document No.");
                if ApprovalCommentLine.FindLast() then begin
                    if not ApprovalCommentLine."New Comment" then begin
                        Error(ActionName + ' was unsuccessful because a new ' + ActionName + ' comment is required');
                        exit;
                    end;
                end else begin
                    Error(ActionName + ' was unsuccessful because a ' + ActionName + ' comment is required ...');
                    exit;
                end;
                CLEAR(ApprovalComments);
                RejectApprovalRequest(ApprovalEntry, '');
            end
        end else
            RunApprovalCommentsPage(ApprovalCommentLine);
    end;


    local procedure SetCommonApprovalCommentLineFilters(var RecRef: RecordRef; var ApprovalEntry: Record "Approval Entry"; var ApprovalCommentLine: Record "Approval Comment Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        ApprovalCommentLine.SetRange("Table ID", RecRef.Number);
        ApprovalCommentLine.SetRange("Record ID to Approve", RecRef.RecordId);
        FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RecordId);
    end;

    local procedure RunApprovalCommentsPage(var ApprovalCommentLine: Record "Approval Comment Line")
    var
        ApprovalComments: Page "Approval Comments";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        ApprovalComments.SetTableView(ApprovalCommentLine);
        //ApprovalComments.SetWorkflowStepInstanceID(WorkflowStepInstanceID);
        ApprovalComments.Run();
    end;

    procedure ApproveRecordApprovalRequest(RecordID: RecordID)
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if not FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) then
            Error(NoReqToApproveErr);
        if GuiAllowed then
            if not Confirm('Are you sure you would like to approve this request?') then
                exit;
        ApprovalEntry.SetRecFilter();
        ApproveApprovalRequest(ApprovalEntry);
    end;

    procedure RejectRecordApprovalRequest(RecordID: RecordID)
    var
        Txt001: Label 'Are you really sure, you would like to reject this entry';
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        if not FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) then
            Error(NoReqToRejectErr);

        ApprovalEntry.SetRecFilter();
        IF NOT Confirm(Txt001, false) then
            exit;

        RecRef.GetTable(ApprovalEntry);
        ShowApprovalComments(RecRef, 'Rejection');
    end;

    procedure DelegateRecordApprovalRequest(RecordID: RecordID)
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        if not FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) then
            Error(NoReqToDelegateErr);

        ApprovalEntry.SetRecFilter();
        if GuiAllowed then
            if not confirm('Are you sure you would like to delegate the request?') then
                exit;
        ApprovalMgt.DelegateApprovalRequests(ApprovalEntry);
    end;

    procedure FindOpenApprovalEntryForCurrUser(var ApprovalEntry: Record "Approval Entry"; RecordID: RecordID): Boolean
    begin
        ApprovalEntry.SetRange("Table ID", RecordID.TableNo);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID", UserId);
        ApprovalEntry.SetRange("Related to Change", false);

        exit(ApprovalEntry.FindFirst());
    end;

    var
        MsgTxt001Err: Label '%1 %2 requires further approval.\\Approval request entries have been created.';
        Txt002Err: Label '%1 %2 approval request cancelled.';
        Text003: Label '%1 %2 has been automatically approved and released.';
        Text004: Label 'Approval Setup not found.';
        Text005: Label 'User ID %1 does not exist in the User Setup table.';
        Text006: Label 'Approver ID %1 does not exist in the User Setup table.';
        Text007: Label '%1 for %2  does not exist in the User Setup table.';
        Text008: Label 'User ID %1 does not exist in the User Setup table for %2 %3.';
        Text013: Label 'Document %1 must be approved and released before you can perform this action.';
        Text009: Label 'Document %1 must have status Pending Prepayment before you can perform this action.';
        Text010: Label 'Approver not found.';
        Text025: Label '%1 is not a valid limit type for %2 %3.';
        Text129: Label 'No Approval Templates are enabled for document type %1.';
        NoReqToApproveErr: Label 'There is no approval request to approve.';
        NoReqToRejectErr: Label 'There is no approval request to reject.';
        NoReqToDelegateErr: Label 'There is no approval request to delegate.';
        DispMessage: Boolean;
        IsOpenStatusSet: Boolean;
        TemplateRec: Record "Requisition Approval Templates";
        Text155: Label 'User ID %1 does not exist in the Departmental User Setup table for this Document Type %2 and Approval Dimension %3.';
        Text026: Label '%1 is only a valid limit type for %2.';
        ApprovalSetup: Record "Req Approval Setup";
        ApprovalNotification: Codeunit "Approval Notification";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        IsSenderSameAsApprover: Boolean;

    [IntegrationEvent(false, false)]
    procedure OnAfterApproveRequestEntry(var ApprovalEntry: Record "Approval Entry"; var RecID: RecordId)
    begin
    end;

}
