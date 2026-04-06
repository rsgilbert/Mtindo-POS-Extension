report 50028 "Accountability Report"
{
    Caption = 'Imprest Accountability';
    RDLCLayout = './src/Report/rdl/Accountability Printout.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Accountability Header"; "Accountability Header")
        {
            column(No_; "No.")
            {

            }
            column(PV_No_; PVNo)
            {
            }
            column(Document_Date; "Document Date")
            {

            }
            column(Payee_Name; "Payee Name")
            {

            }
            column(Bank_Account_Name; "Bank Account Name")
            {

            }
            column(Bank_Account_No; "Bank Account No")
            {

            }
            column(Payment_Date; "Payment Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Requestor_Name; "Requestor Name")
            {

            }
            column(Requisitioned_By; "Requisitioned By")
            {

            }
            column(Currency_Code; CurrencyCode)
            {

            }
            column(Company_Name; CompanyInfo.Name)
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress_2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {

            }
            column(Company_TIN; CompanyInfo."VAT Registration No.")
            {
            }
            column(Company_Logo; CompanyInfo.Picture)
            {
            }
            column(CompanyWaterMark; CompanyInfo.Watermark)
            {
            }
            column(PreparedByTitle; PreparedbyTitle)
            {

            }
            column(PreparedSignature; PreparedBySignature)
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
            column(Approver1Signature; UserSignature1)
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
            column(Approver2Signature; UserSignature2)
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
            column(Approver3Signature; UserSignature3)
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
            column(Approver4Signature; UserSignature4)
            {
            }
            column(Approver5Signature; UserSignature5)
            {
            }
            column(Approver6Signature; UserSignature6)
            {
            }
            column(ModifiedByName; ModifiedBy)
            {
            }
            column(ModifiedByJobTitle; ModifiedByJobTitle)
            {
            }
            dataitem("Accountability Line"; "Accountability Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No" = FIELD("No.");
                DataItemLinkReference = "Accountability Header";
                DataItemTableView = SORTING("Document Type", "Document No", "Line No");
                column(Document_No; "Document No")
                {

                }
                column(Account_No_Line; "Account No")
                {

                }
                column(Description; Description)
                {

                }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {

                }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Rate; Rate)
                {

                }
                column(Amount; "Amount To Pay")
                {

                }

            }

            trigger OnAfterGetRecord()
            var
                PaymentReqArchiveHeader: Record "Payment Req. Header Archive";

            begin
                Clear(CurrencyCode);

                GeneralLedSetup.Reset();
                GeneralLedSetup.Get();
                if "Currency Code" = '' then
                    CurrencyCode := GeneralLedSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";

                Clear(Approver1);
                Clear(JobTitle1);
                Clear(ApproverDate1);
                Clear(Approver2);
                Clear(JobTitle2);
                Clear(ApproverDate2);
                Clear(Approver2);
                Clear(JobTitle2);
                Clear(ApproverDate2);
                Clear(Approver3);
                Clear(Approver4);
                Clear(Approver5);
                clear(Approver6);
                clear(JobTitle3);
                clear(JobTitle4);
                clear(JobTitle5);
                clear(JobTitle6);
                clear(ApproverDate3);
                clear(ApproverDate4);
                clear(ApproverDate5);
                Clear(ApproverDate6);
                Clear(ModifiedBy);
                clear(ModifiedByJobTitle);
                Clear(PreparedBySignature);
                clear(userSignature1);
                clear(userSignature2);
                clear(userSignature3);
                clear(userSignature4);
                clear(userSignature5);
                clear(userSignature6);
                Clear(PVNo);
                PaymentReqArchiveHeader.Reset();
                PaymentReqArchiveHeader.SetRange("No.", "Requisition No.");
                if PaymentReqArchiveHeader.FindFirst() then
                    PVNo := PaymentReqArchiveHeader."PV No.";

                Employee.Reset();

                Employee.Reset();

                if PreparedByEmployee.Get("Requisitioned By") then begin
                    PreparedBy := PreparedByEmployee.FullName();
                    PreparedbyTitle := PreparedByEmployee."Job Title";
                    PreparedBySignature := PreparedByEmployee."User ID";
                end;

                ApproverCount := 0;
                ApprovalEntry.SetRange("Table ID", DATABASE::"Accountability Header");
                ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::Accountability);
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetFilter("Sequence No.", '<>%1', 0);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindSet() then
                    repeat
                        if ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID" then begin
                            ApproverCount := ApproverCount + 1;
                            if ApprovalEntry."Approver ID" <> '' then begin
                                Employee.SetRange("User ID", ApprovalEntry."Approver ID");
                                if Employee.FindFirst() then;
                            end;
                        end;
                        if ApproverCount = 1 then begin
                            Approver1 := Employee.FullName();
                            JobTitle1 := Employee."Job Title";
                            ApproverDate1 := ApprovalEntry."Last Date-Time Modified";
                            userSignature1 := Employee."User ID";
                        end
                        else
                            if ApproverCount = 2 then begin
                                Approver2 := Employee.FullName();
                                JobTitle2 := Employee."Job Title";
                                ApproverDate2 := ApprovalEntry."Last Date-Time Modified";
                                userSignature2 := Employee."User ID";
                            end
                            else
                                if ApproverCount = 3 then begin
                                    Approver3 := Employee.FullName();
                                    JobTitle3 := Employee."Job Title";
                                    ApproverDate3 := ApprovalEntry."Last Date-Time Modified";
                                    userSignature3 := Employee."User ID";
                                end
                                else
                                    if ApproverCount = 4 then begin
                                        Approver4 := Employee.FullName();
                                        JobTitle4 := Employee."Job Title";
                                        ApproverDate4 := ApprovalEntry."Last Date-Time Modified";
                                        userSignature4 := Employee."User ID";
                                    end
                                    else
                                        if ApproverCount = 5 then begin
                                            Approver5 := Employee.FullName();
                                            JobTitle5 := Employee."Job Title";
                                            ApproverDate5 := ApprovalEntry."Last Date-Time Modified";
                                            userSignature5 := Employee."User ID";
                                        end
                                        else
                                            if ApproverCount = 6 then begin
                                                Approver6 := Employee.FullName();
                                                JobTitle6 := Employee."Job Title";
                                                ApproverDate6 := ApprovalEntry."Last Date-Time Modified";
                                                userSignature6 := Employee."User ID";
                                            end;
                    until ApprovalEntry.Next() = 0;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.CalcFields(Watermark);
    end;

    var
        PreparedBySignature: Code[20];
        PVNo: Code[20];
        CompanyInfo: Record "Company Information";
        GeneralLedSetup: Record "General Ledger Setup";
        DimensionValues: Record "Dimension Value";
        CostCenterName: Text;
        ApprovalEntry: Record "Approval Entry";
        ApproverCount: Integer;
        Employee: Record Employee;
        PreparedByEmployee: Record Employee;
        Approver: array[4] of Text[100];
        ApproverDate: array[4] of DateTime;
        userSignature: array[10] of Text;
        EmployeeRecords: array[4] of Record Employee;
        UserSetup: Record "User Setup";
        PreparedBy: Text[100];
        PreparedbyTitle: Text[100];
        PreparedDate: DateTime;
        Approver1: Text[100];
        JobTitle1: Text[100];
        ApproverDate1: DateTime;
        Approver2: Text[100];
        JobTitle2: Text[100];
        ApproverDate2: DateTime;
        Approver3: Text[100];
        JobTitle3: Text[100];
        ApproverDate3: DateTime;
        Approver4: Text[100];
        Approver5: Text[100];
        Approver6: Text[100];
        ApproverDate4: DateTime;
        ApproverDate5: DateTime;
        ApproverDate6: DateTime;
        JobTitle4: Text[100];
        JobTitle5: Text[100];
        JobTitle6: Text[100];
        ModifiedBy: Text[100];
        ModifiedByJobTitle: Text[100];
        CurrencyCode: Code[20];
        userSignature1: Code[20];
        userSignature2: Code[20];
        userSignature3: Code[20];
        userSignature4: Code[20];
        userSignature5: Code[20];
        userSignature6: Code[20];
        userSignature7: Code[20];

}