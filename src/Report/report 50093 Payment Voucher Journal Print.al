report 50093 "Payment Voucher Journal Print"
{
    Caption = 'Payment Voucher';
    RDLCLayout = './src/Report/rdl/Payment Voucher Printout.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Document No.", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Document No.";

            column(No_; VoucherNo) { }
            column(PV_No_; VoucherNo) { }
            column(Document_Date; "Document Date") { }
            column(JournalBatch; "Journal Batch Name") { }
            column(Payee_Name; PayeeName) { }
            column(Bank_Account_Name; BankAccountName) { }
            column(Bank_Account_No; BankAccountNo) { }
            column(Payment_Date; "Posting Date") { }
            column(Posting_Date; "Posting Date") { }
            column(Requestor_Name; RequestorName) { }
            column(Requisitioned_By; RequestedByEmployeeNo) { }
            column(Currency_Code; HeaderCurrencyCode) { }
            column(Company_Name; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress_2; CompanyInfo."Address 2") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(CompanyEMail; CompanyInfo."E-Mail") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyWaterMark; CompanyInfo.Watermark) { }
            column(Company_TIN; CompanyInfo."VAT Registration No.") { }
            column(Company_Logo; CompanyInfo.Picture) { }
            column(DimName; DimName) { }
            column(Dimension2Name; Dimension2Name) { }
            column(Registered_MM_Number; RegisteredMMNumber) { }
            column(Registered_MM_Name; RegisteredMMName) { }
            column(Mode_Of_Payment; ModeOfPayment) { }
            column(Prepared_By; PreparedByUserId) { }
            column(Prepared_By_Name; PreparedByName) { }
            column(PreparedByTitle; PreparedByTitle) { }
            column(PreparedSignature; PreparedByEmployee.Signature2) { }
            column(PreparedByDate; Today) { }
            column(PreparedAt_Time; Time) { }
            column(Modified_By; UserId) { }
            column(Approver1; Approver1) { }
            column(Approver1Date; ApproverDate1) { }
            column(Approver1Title; JobTitle1) { }
            column(Approver1Signature; Employee1.Signature2) { }
            column(Approver2; Approver2) { }
            column(Approver2Date; ApproverDate2) { }
            column(Approver2Title; JobTitle2) { }
            column(Approver2Signature; Employee2.Signature2) { }
            column(Approver3; Approver3) { }
            column(Approver3Date; ApproverDate3) { }
            column(Approver3Title; JobTitle3) { }
            column(Approver3Signature; Employee3.Signature2) { }
            column(Approver4; Approver4) { }
            column(Approver5; Approver5) { }
            column(Approver6; Approver6) { }
            column(ApproverDate4; ApproverDate4) { }
            column(ApproverDate5; ApproverDate5) { }
            column(ApproverDate6; ApproverDate6) { }
            column(JobTitle4; JobTitle4) { }
            column(JobTitle5; JobTitle5) { }
            column(JobTitle6; JobTitle6) { }
            column(Approver4Signature; Employee4.Signature2) { }
            column(Approver5Signature; Employee5.Signature2) { }
            column(Approver6Signature; Employee6.Signature2) { }
            column(RequestedByName; RequestorName) { }
            column(Requested_Date; "Document Date") { }
            column(RequestedByJobTitle; RequestedByJobTitle) { }
            column(RequestedBySignature; RequestedByEmployee.Signature2) { }
            column(Ext_Document_No; "External Document No.") { }

            dataitem("Gen. Journal Line2"; "Gen. Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"),
                               "Journal Batch Name" = FIELD("Journal Batch Name"),
                               "Document No." = FIELD("Document No.");
                DataItemLinkReference = "Gen. Journal Line";
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Document No.", "Line No.");

                column(Document_No; "Document No.") { }
                column(Account_No_Line; "Account No.") { }
                column(Description; Description) { }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
                column(Quantity; 1) { }
                column(Rate; Abs(Amount)) { }
                column(WHT_Amount; 0) { }
                column(Amount; Amount) { }
                column(Amount_To_Pay__LCY_; "Amount (LCY)") { }
                column(CurrencyCode; HeaderCurrencyCode) { }

                dataitem("WorkPlan Line"; "WorkPlan Line")
                {
                    DataItemLink = "WorkPlan No" = FIELD("Work Plan"),
                                   "Entry No" = FIELD("Work Plan Entry No.");
                    DataItemLinkReference = "Gen. Journal Line2";

                    column(Entry_No; "Entry No") { }
                    column(Budget_Code; "Budget Code") { }
                    column(WorkPlan_NoAndEntryNo; "WorkPlan No" + '-' + Format("Entry No")) { }
                    column(Account_No; "Account No") { }
                    column(Account_Name; "Account Name") { }
                    column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                    column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                    column(WorkPlan_Dimension_1_Code; "WorkPlan Dimension 1 Code") { }
                    column(DescriptionWorkPlan; Description) { }
                    column(Actuals; Actuals) { }
                    column(Variance; Variance) { }
                    column(WorkPlan_No; "WorkPlan No") { }
                }
            }

            trigger OnPreDataItem()
            begin
                LastVoucherKey := '';
            end;

            trigger OnAfterGetRecord()
            var
                CurrentVoucherKey: Text[250];
            begin
                CurrentVoucherKey := "Journal Template Name" + '|' + "Journal Batch Name" + '|' + "Document No.";
                if CurrentVoucherKey = LastVoucherKey then
                    CurrReport.Skip();
                LastVoucherKey := CurrentVoucherKey;

                PopulateHeaderFromJournal("Gen. Journal Line");
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture, Watermark);
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Employee1: Record Employee;
        Employee2: Record Employee;
        Employee3: Record Employee;
        Employee4: Record Employee;
        Employee5: Record Employee;
        Employee6: Record Employee;
        RequestedByEmployee: Record Employee;
        PreparedByEmployee: Record Employee;
        ApprovalEntry: Record "Approval Entry";
        PaymentReqHeader: Record "Payment Requisition Header";
        PaymentReqHeaderArchive: Record "Payment Req. Header Archive";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        LastVoucherKey: Text[250];
        VoucherNo: Code[20];
        HeaderCurrencyCode: Code[10];
        DimName: Text[100];
        Dimension2Name: Text[100];
        PayeeName: Text[100];
        BankAccountName: Text[100];
        BankAccountNo: Code[20];
        RequestorName: Text[100];
        RequestedByEmployeeNo: Code[50];
        RequestedByJobTitle: Text[100];
        PreparedByUserId: Code[50];
        PreparedByName: Text[100];
        PreparedByTitle: Text[100];
        ModeOfPayment: Text[100];
        RegisteredMMNumber: Code[20];
        RegisteredMMName: Text[100];
        Approver1: Text[100];
        Approver2: Text[100];
        Approver3: Text[100];
        Approver4: Text[100];
        Approver5: Text[100];
        Approver6: Text[100];
        JobTitle1: Text[100];
        JobTitle2: Text[100];
        JobTitle3: Text[100];
        JobTitle4: Text[100];
        JobTitle5: Text[100];
        JobTitle6: Text[100];
        ApproverDate1: DateTime;
        ApproverDate2: DateTime;
        ApproverDate3: DateTime;
        ApproverDate4: DateTime;
        ApproverDate5: DateTime;
        ApproverDate6: DateTime;

    local procedure PopulateHeaderFromJournal(var GenJournalLine: Record "Gen. Journal Line")
    begin
        ClearHeaderVars();
        GLSetup.Get();

        VoucherNo := GenJournalLine."Document No.";

        if GenJournalLine."Currency Code" <> '' then
            HeaderCurrencyCode := GenJournalLine."Currency Code"
        else
            HeaderCurrencyCode := GLSetup."LCY Code";

        DimName := GetDimensionName(GLSetup."Global Dimension 1 Code", GenJournalLine."Shortcut Dimension 1 Code");
        Dimension2Name := GetDimensionName(GLSetup."Global Dimension 2 Code", GenJournalLine."Shortcut Dimension 2 Code");
        ModeOfPayment := Format(GenJournalLine."Payment Method Code");

        ResolvePayee(GenJournalLine);
        ResolvePreparedAndRequestedBy();
        ResolveFromPaymentRequisition(GenJournalLine."Payment Requisition No.");
        ResolveRequestedByEmployee();
        ResolveApprovals(GenJournalLine."Payment Requisition No.");
    end;

    local procedure ResolvePayee(var GenJournalLine: Record "Gen. Journal Line")
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Vendor:
                if Vendor.Get(GenJournalLine."Account No.") then
                    PayeeName := Vendor.Name;
            GenJournalLine."Account Type"::Customer:
                if Customer.Get(GenJournalLine."Account No.") then
                    PayeeName := Customer.Name;
            GenJournalLine."Account Type"::"Bank Account":
                if BankAccount.Get(GenJournalLine."Account No.") then begin
                    PayeeName := BankAccount.Name;
                    BankAccountName := BankAccount.Name;
                    BankAccountNo := BankAccount."No.";
                end;
            GenJournalLine."Account Type"::"G/L Account":
                if GLAccount.Get(GenJournalLine."Account No.") then
                    PayeeName := GLAccount.Name;
        end;

        if (BankAccountNo = '') and (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"Bank Account") then
            if BankAccount.Get(GenJournalLine."Bal. Account No.") then begin
                BankAccountName := BankAccount.Name;
                BankAccountNo := BankAccount."No.";
            end;
    end;

    local procedure ResolvePreparedAndRequestedBy()
    begin
        PreparedByUserId := UserId;
        PreparedByEmployee.Reset();
        PreparedByEmployee.SetRange("User ID", UserId);
        if PreparedByEmployee.FindFirst() then begin
            PreparedByName := PreparedByEmployee.FullName();
            PreparedByTitle := PreparedByEmployee."Job Title";
            PreparedByEmployee.CalcFields(Signature2);
        end;

        RequestorName := PreparedByName;
        RequestedByJobTitle := PreparedByTitle;
        RequestedByEmployeeNo := PreparedByEmployee."No.";
        ResolveRequestedByEmployee();
    end;

    local procedure ResolveFromPaymentRequisition(PaymentReqNo: Code[20])
    begin
        if PaymentReqNo = '' then
            exit;

        if PaymentReqHeader.Get(PaymentReqNo) then begin
            if PaymentReqHeader."Payee Name" <> '' then
                PayeeName := PaymentReqHeader."Payee Name";
            if PaymentReqHeader."Bank Account Name" <> '' then
                BankAccountName := PaymentReqHeader."Bank Account Name";
            if PaymentReqHeader."Bank Account No" <> '' then
                BankAccountNo := PaymentReqHeader."Bank Account No";
            if PaymentReqHeader."Requestor Name" <> '' then
                RequestorName := PaymentReqHeader."Requestor Name";
            if PaymentReqHeader."Requisitioned By" <> '' then
                RequestedByEmployeeNo := PaymentReqHeader."Requisitioned By";
            ModeOfPayment := PaymentReqHeader."Mode Of Payment";
            RegisteredMMNumber := PaymentReqHeader."Registered MM Number";
            RegisteredMMName := PaymentReqHeader."Registered MM Name";
            if PaymentReqHeader."Prepared By" <> '' then
                PreparedByUserId := PaymentReqHeader."Prepared By";
            if PaymentReqHeader."Prepared By Name" <> '' then
                PreparedByName := PaymentReqHeader."Prepared By Name";
            exit;
        end;

        PaymentReqHeaderArchive.Reset();
        PaymentReqHeaderArchive.SetRange("No.", PaymentReqNo);
        if PaymentReqHeaderArchive.FindFirst() then begin
            if PaymentReqHeaderArchive."Payee Name" <> '' then
                PayeeName := PaymentReqHeaderArchive."Payee Name";
            if PaymentReqHeaderArchive."Bank Account Name" <> '' then
                BankAccountName := PaymentReqHeaderArchive."Bank Account Name";
            if PaymentReqHeaderArchive."Bank Account No" <> '' then
                BankAccountNo := PaymentReqHeaderArchive."Bank Account No";
            if PaymentReqHeaderArchive."Requestor Name" <> '' then
                RequestorName := PaymentReqHeaderArchive."Requestor Name";
            if PaymentReqHeaderArchive."Requisitioned By" <> '' then
                RequestedByEmployeeNo := PaymentReqHeaderArchive."Requisitioned By";
            ModeOfPayment := PaymentReqHeaderArchive."Mode Of Payment";
            RegisteredMMNumber := PaymentReqHeaderArchive."Registered MM Number";
            RegisteredMMName := PaymentReqHeaderArchive."Registered MM Name";
            if PaymentReqHeaderArchive."Prepared By" <> '' then
                PreparedByUserId := PaymentReqHeaderArchive."Prepared By";
            if PaymentReqHeaderArchive."Prepared By Name" <> '' then
                PreparedByName := PaymentReqHeaderArchive."Prepared By Name";
        end;
    end;

    local procedure ResolveApprovals(PaymentReqNo: Code[20])
    var
        ApproverCount: Integer;
    begin
        if PaymentReqNo = '' then
            exit;

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"Payment Requisition Header");
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Payment Requisition");
        ApprovalEntry.SetRange("Document No.", PaymentReqNo);
        ApprovalEntry.SetFilter("Sequence No.", '<>%1', 0);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.SetCurrentKey("Sequence No.");
        ApprovalEntry.SetAscending("Sequence No.", true);

        ApproverCount := 0;
        if ApprovalEntry.FindSet() then
            repeat
                if (ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID") and (ApprovalEntry."Approver ID" <> '') then begin
                    ApproverCount += 1;
                    case ApproverCount of
                        1:
                            SetApprover(Employee1, ApprovalEntry."Approver ID", Approver1, JobTitle1, ApproverDate1);
                        2:
                            SetApprover(Employee2, ApprovalEntry."Approver ID", Approver2, JobTitle2, ApproverDate2);
                        3:
                            SetApprover(Employee3, ApprovalEntry."Approver ID", Approver3, JobTitle3, ApproverDate3);
                        4:
                            SetApprover(Employee4, ApprovalEntry."Approver ID", Approver4, JobTitle4, ApproverDate4);
                        5:
                            SetApprover(Employee5, ApprovalEntry."Approver ID", Approver5, JobTitle5, ApproverDate5);
                        6:
                            SetApprover(Employee6, ApprovalEntry."Approver ID", Approver6, JobTitle6, ApproverDate6);
                    end;
                end;
            until (ApprovalEntry.Next() = 0) or (ApproverCount = 6);
    end;

    local procedure ResolveRequestedByEmployee()
    begin
        Clear(RequestedByEmployee);
        if RequestedByEmployeeNo = '' then
            exit;
        if RequestedByEmployee.Get(CopyStr(RequestedByEmployeeNo, 1, MaxStrLen(RequestedByEmployee."No."))) then begin
            RequestedByEmployee.CalcFields(Signature2);
            if RequestedByJobTitle = '' then
                RequestedByJobTitle := RequestedByEmployee."Job Title";
            if RequestorName = '' then
                RequestorName := RequestedByEmployee.FullName();
            exit;
        end;

        RequestedByEmployee.Reset();
        RequestedByEmployee.SetRange("User ID", RequestedByEmployeeNo);
        if RequestedByEmployee.FindFirst() then begin
            RequestedByEmployee.CalcFields(Signature2);
            if RequestedByJobTitle = '' then
                RequestedByJobTitle := RequestedByEmployee."Job Title";
            if RequestorName = '' then
                RequestorName := RequestedByEmployee.FullName();
        end;
    end;

    local procedure SetApprover(var Employee: Record Employee; ApproverUserId: Code[50]; var ApproverName: Text[100]; var ApproverTitle: Text[100]; var ApproverDate: DateTime)
    begin
        Employee.Reset();
        Employee.SetRange("User ID", ApproverUserId);
        if Employee.FindFirst() then begin
            ApproverName := Employee.FullName();
            ApproverTitle := Employee."Job Title";
            Employee.CalcFields(Signature2);
        end;
        ApproverDate := ApprovalEntry."Last Date-Time Modified";
    end;

    local procedure GetDimensionName(DimensionCode: Code[20]; DimensionValueCode: Code[20]): Text[100]
    begin
        if (DimensionCode = '') or (DimensionValueCode = '') then
            exit('');

        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", DimensionCode);
        DimensionValue.SetRange(Code, DimensionValueCode);
        if DimensionValue.FindFirst() then
            exit(DimensionValue.Name);
    end;

    local procedure ClearHeaderVars()
    begin
        Clear(VoucherNo);
        Clear(HeaderCurrencyCode);
        Clear(DimName);
        Clear(Dimension2Name);
        Clear(PayeeName);
        Clear(BankAccountName);
        Clear(BankAccountNo);
        Clear(RequestorName);
        Clear(RequestedByEmployeeNo);
        Clear(RequestedByJobTitle);
        Clear(PreparedByUserId);
        Clear(PreparedByName);
        Clear(PreparedByTitle);
        Clear(ModeOfPayment);
        Clear(RegisteredMMNumber);
        Clear(RegisteredMMName);
        Clear(Approver1);
        Clear(Approver2);
        Clear(Approver3);
        Clear(Approver4);
        Clear(Approver5);
        Clear(Approver6);
        Clear(JobTitle1);
        Clear(JobTitle2);
        Clear(JobTitle3);
        Clear(JobTitle4);
        Clear(JobTitle5);
        Clear(JobTitle6);
        Clear(ApproverDate1);
        Clear(ApproverDate2);
        Clear(ApproverDate3);
        Clear(ApproverDate4);
        Clear(ApproverDate5);
        Clear(ApproverDate6);
        Clear(RequestedByEmployee);
        Clear(PreparedByEmployee);
        Clear(Employee1);
        Clear(Employee2);
        Clear(Employee3);
        Clear(Employee4);
        Clear(Employee5);
        Clear(Employee6);
    end;
}
