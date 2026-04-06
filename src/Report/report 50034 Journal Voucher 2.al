report 50034 "Journal Voucher 2"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Report/rdl/Journal Voucher2.rdl';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Account_Type; "Account Type")
            {
            }
            column(Account_No_; "Account No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Amount__LCY_; "Amount (LCY)")
            {
            }
            column(Payee; PayeeName) { }
            column(Bal__Account_Type; "Bal. Account Type")
            {
            }
            column(Bal__Account_No_; "Bal. Account No.")
            {
            }
            column(gvBalAccName; gvBalAccName)
            {
            }
            column(Payment_Method_Code; PaymentMethod)
            {
            }
            column(External_Document_No_; "External Document No.")
            {
            }
            column(Currency_Code; gvCurrency)
            {
            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {
                IncludeCaption = true;
            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {
                IncludeCaption = true;
            }
            column(gvDimName1; gvDimName1)
            {
            }
            column(gvDimName2; gvDimName2)
            {
            }
            column(Company_Name; CompanyInformation.Name)
            {

            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyAddress_2; CompanyInformation."Address 2")
            {
            }
            column(CompanyPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(CompanyEMail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyFaxNo; CompanyInformation."Fax No.")
            {

            }
            column(Company_TIN; CompanyInformation."VAT Registration No.")
            {
            }
            column(Company_Logo; CompanyInformation.Picture)
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(Prepared_By; PreparedBy) { }
            column(Prepared_By_Name; PreparedBy) { }
            column(PreparedByTitle; PreparedbyTitle)
            {

            }
            column(PreparedSignature; PreparedByEmployee.Signature2)
            {

            }
            column(Approver1; Approver1)
            {

            }
            column(Approver1Date; ApproverDate1)
            {

            }
            column(Approver1Title; JobTitle1)
            {

            }
            column(Approver1Signature; Employee1.Signature2)
            {

            }
            column(Approver2; Approver2)
            {

            }
            column(Approver2Date; ApproverDate2)
            {

            }
            column(Approver2Title; JobTitle2)
            {

            }
            column(Approver2Signature; Employee2.Signature2)
            {
            }

            column(Approver3; Approver3)
            {

            }
            column(Approver3Date; ApproverDate3)
            {

            }
            column(Approver3Title; JobTitle3)
            {

            }
            column(Approver3Signature; Employee3.Signature2)
            {

            }
            column(Approver4; Approver4)
            {

            }
            column(Approver5; Approver5)
            {
            }
            column(Approver6; Approver6)
            {
            }
            column(ApproverDate4; ApproverDate4)
            {
            }
            column(ApproverDate5; ApproverDate5)
            {
            }
            column(ApproverDate6; ApproverDate6)
            {
            }
            column(JobTitle4; JobTitle4)
            {
            }
            column(JobTitle5; JobTitle5)
            {
            }
            column(JobTitle6; JobTitle6)
            {
            }
            column(Approver4Signature; Employee4.Signature2)
            {
            }
            column(Approver5Signature; Employee5.Signature2)
            {
            }
            column(Approver6Signature; Employee6.Signature2)
            {
            }
            column(RequestedByName; RequestedBy)
            {
            }
            column(Requested_Date; "Document Date")
            {
            }
            column(RequestedByJobTitle; RequestedbyJobTitle)
            {
            }
            column(RequestedBySignature; RequestedByEmployee.Signature2) { }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                gvemployee: record employee;
                GenReqsetup: Record "Gen. Requisition Setup";
                lvPaymentReqHeader: Record "Payment Requisition Header";
                lvPaymentReqHeaderArchive: Record "Payment Req. Header Archive";
            begin
                Clear("Currency Code");
                Clear(gvDimName1);
                Clear(gvDimName2);
                GenLedgerSetup.Get();
                if "Currency Code" <> '' then
                    gvCurrency := "Currency Code"
                else
                    gvCurrency := GenLedgerSetup."LCY Code";

                DimensionValues.Reset();
                DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 1 Code");
                DimensionValues.SetRange(Code, "Shortcut Dimension 1 Code");
                if DimensionValues.FindFirst() then
                    gvDimName1 := DimensionValues.Name;

                DimensionValues.Reset();
                DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 2 Code");
                DimensionValues.SetRange(Code, "Shortcut Dimension 2 Code");
                if DimensionValues.FindFirst() then
                    gvDimName2 := DimensionValues.Name;

                //Get Balancing Account Name
                Clear(gvBalAccName);
                gvCustomer.Reset();
                gvVendor.Reset();
                gvGLAccount.Reset();
                gvBankAccount.Reset();

                if "Bal. Account No." <> '' then
                    case "Bal. Account Type" of
                        "Bal. Account Type"::"Bank Account":

                            if gvBankAccount.get("Bal. Account No.") then
                                gvBalAccName := gvBankAccount.Name;

                        "Bal. Account Type"::Customer:


                            if gvCustomer.get("Bal. Account No.") then
                                gvBalAccName := gvCustomer.Name;

                        "Bal. Account Type"::Vendor:

                            if gvVendor.get("Bal. Account No.") then
                                gvBalAccName := gvVendor.Name;

                        "Bal. Account Type"::"G/L Account":

                            if gvGLAccount.get("Bal. Account No.") then
                                gvBalAccName := gvGLAccount.Name;

                    end;




                lvPaymentReqHeaderArchive.Reset();
                lvPaymentReqHeaderArchive.SetRange("No.", "Gen. Journal Line"."Payment Requisition No.");
                // Message('Payment Requisition No.: %1', "Gen. Journal Line"."Payment Requisition No.");
                if lvPaymentReqHeaderArchive.FindFirst() then begin
                    RequestedBy := lvPaymentReqHeaderArchive."Requestor Name";
                    PreparedBy := lvPaymentReqHeaderArchive."Prepared By Name";
                    // Message('RequestedBy: %1, PreparedBy: %2', RequestedBy, PreparedBy);
                    // RequestedbyJobTitle := lvPaymentReqHeader."Requested By Job Title";
                end;

                //request by signature
                lvPaymentReqHeaderArchive.Reset();
                lvPaymentReqHeaderArchive.SetRange("No.", "Gen. Journal Line"."Payment Requisition No.");
                if lvPaymentReqHeaderArchive.FindFirst() then begin
                    RequestedByEmployee.Reset();
                    RequestedByEmployee.SetRange("No.", lvPaymentReqHeaderArchive."Requisitioned By");
                    if RequestedByEmployee.FindFirst() then
                        RequestedByEmployee.CalcFields(Signature2);
                end;


                lvPaymentReqHeaderArchive.Reset();
                lvPaymentReqHeaderArchive.SetRange("No.", "Gen. Journal Line"."Payment Requisition No.");
                if lvPaymentReqHeaderArchive.FindFirst() then
                    if PreparedByEmployee.Get(lvPaymentReqHeaderArchive."Prepared By") then begin
                        PreparedBy := PreparedByEmployee.FullName();
                        PreparedbyTitle := PreparedByEmployee."Job Title";
                        PaymentMethod := lvPaymentReqHeaderArchive."Mode Of Payment";
                        PayeeName := lvPaymentReqHeaderArchive."Payee Name";
                        PreparedByEmployee.CalcFields(Signature2);
                    end;

                ApproverCount := 0;
                ApprovalEntry.SetRange("Table ID", DATABASE::"Payment Requisition Header");
                ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Payment Requisition");
                ApprovalEntry.SetRange("Document No.", "Gen. Journal Line"."Payment Requisition No.");
                ApprovalEntry.SetFilter("Sequence No.", '<>%1', 0);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);

                if ApprovalEntry.FindSet() then begin
                    ApprovalEntry.SetCurrentKey("Sequence No.");
                    ApprovalEntry.SetAscending("Sequence No.", true);
                    repeat
                        if ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID" then
                            if ApprovalEntry."Approver ID" <> '' then begin
                                ApproverCount := ApproverCount + 1;
                                case ApproverCount of
                                    1:
                                        begin
                                            Employee1.Reset();
                                            Employee1.SetRange(Employee1."User ID", ApprovalEntry."Approver ID");
                                            if Employee1.FindFirst() then begin
                                                Approver1 := Employee1.FullName();
                                                JobTitle1 := Employee1."Job Title";
                                                ApproverDate1 := ApprovalEntry."Last Date-Time Modified";
                                                Employee1.CalcFields(Signature2);
                                            end;
                                        end;
                                    2:
                                        begin
                                            Employee2.Reset();
                                            Employee2.SetRange(Employee2."User ID", ApprovalEntry."Approver ID");
                                            if Employee2.FindFirst() then begin
                                                Approver2 := Employee2.FullName();
                                                JobTitle2 := Employee2."Job Title";
                                                ApproverDate2 := ApprovalEntry."Last Date-Time Modified";
                                                Employee2.CalcFields(Signature2);
                                            end;
                                        end;
                                    3:
                                        begin
                                            Employee3.Reset();
                                            Employee3.SetRange(Employee3."User ID", ApprovalEntry."Approver ID");
                                            if Employee3.FindFirst() then begin
                                                Approver3 := Employee3.FullName();
                                                JobTitle3 := Employee3."Job Title";
                                                ApproverDate3 := ApprovalEntry."Last Date-Time Modified";
                                                Employee3.CalcFields(Signature2);
                                            end;
                                        end;
                                    4:
                                        begin
                                            Employee4.Reset();
                                            Employee4.SetRange(Employee4."User ID", ApprovalEntry."Approver ID");
                                            if Employee4.FindFirst() then begin
                                                Approver4 := Employee4.FullName();
                                                JobTitle4 := Employee4."Job Title";
                                                ApproverDate4 := ApprovalEntry."Last Date-Time Modified";
                                                Employee4.CalcFields(Signature2);
                                            end;
                                        end;
                                    5:
                                        begin
                                            Employee5.Reset();
                                            Employee5.SetRange(Employee5."User ID", ApprovalEntry."Approver ID");
                                            if Employee5.FindFirst() then begin
                                                Approver5 := Employee5.FullName();
                                                JobTitle5 := Employee5."Job Title";
                                                ApproverDate5 := ApprovalEntry."Last Date-Time Modified";
                                                Employee5.CalcFields(Signature2);
                                            end;
                                        end;
                                    6:
                                        begin
                                            Employee6.Reset();
                                            Employee6.SetRange(Employee6."User ID", ApprovalEntry."Approver ID");
                                            if Employee6.FindFirst() then begin
                                                Approver6 := Employee6.FullName();
                                                JobTitle6 := Employee6."Job Title";
                                                ApproverDate6 := ApprovalEntry."Last Date-Time Modified";
                                                Employee6.CalcFields(Signature2);
                                            end;
                                        end;
                                end;
                            end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        gvDimName1: Text;
        gvDimName2: Text;
        gvCurrency: Text;
        GenLedgerSetup: Record "General Ledger Setup";
        DimensionValues: Record "Dimension Value";
        CompanyInformation: Record "Company Information";
        ReportTitle: Label 'Journal Voucher';
        gvCustomer: Record Customer;
        gvVendor: Record Vendor;
        gvGLAccount: Record "G/L Account";
        gvBankAccount: Record "Bank Account";
        gvBalAccName: Text;

        Approver1: Text[100];
        Approver2: Text[100];
        Approver3: Text[100];
        Approver4: Text[100];

        Approver5: Text[100];

        Approver6: Text[100];

        ApproverDate1: DateTime;
        ApproverDate2: DateTime;
        ApproverDate3: DateTime;
        ApproverDate4: DateTime;

        ApproverDate5: DateTime;

        ApproverDate6: DateTime;

        JobTitle1: Text[100];
        JobTitle2: Text[100];
        JobTitle3: Text[100];
        JobTitle4: Text[100];
        JobTitle5: Text[100];
        JobTitle6: Text[100];

        userSignature1: Code[50];
        userSignature2: Code[50];
        userSignature3: Code[50];
        userSignature4: Code[50];
        userSignature5: Code[50];
        userSignature6: Code[50];
        userSignature7: Code[50];


        Employee1: Record Employee;
        Employee2: Record Employee;
        Employee3: Record Employee;
        Employee4: Record Employee;
        Employee5: Record Employee;
        Employee6: Record Employee;

        ApprovalEntry: Record "Approval Entry";

        PaymentReqHeader: Record "Payment Requisition Header";

        RequestedByEmployee: Record Employee;

        PreparedByEmployee: Record Employee;


        RequestedBy: Text[100];
        RequestedbyJobTitle: Text[100];



        PreparedBy: Text[100];
        PreparedbyTitle: Text[100];


        ApproverCount: Integer;


        PaymentMethod: Text[100];

        PayeeName: Text[100];





}