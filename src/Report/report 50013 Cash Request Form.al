report 50013 "Cash Request Form"
{
    Caption = 'Cash Request Form';
    RDLCLayout = './src/Report/rdl/Cash Request Form.rdl';

    dataset
    {
        dataitem("Payment Requisition Header"; "Payment Requisition Header")
        {
            column(No_; "No.")
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
            column(Currency_Code; "Currency Code")
            {

            }
            column(Company_Name; CompanyInfo.Name)
            {

            }
            column(Company_Address1; CompanyInfo.Address)
            {

            }
            column(Company_Address2; CompanyInfo."Address 2")
            {

            }
            column(Company_Tel; CompanyInfo."Phone No.")
            {

            }
            column(Company_Email; CompanyInfo."E-Mail")
            {

            }
            column(Company_TIN; CompanyInfo.TIN)
            {

            }
            column(Company_Address; CompanyInfo.Address)
            {

            }
            column(Company_Logo; CompanyInfo.Picture)
            {

            }
            column(PreparedByTitle; PreparedbyTitle)
            {

            }
            column(PreparedSignature; UserSetup.Signature)
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
            column(Approver1Signature; UserSetup.Signature)
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
            column(Approver2Signature; UserSetup.Signature)
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
            column(Approver3Signature; UserSetup.Signature)
            {

            }
            column(Approver4; Approver4)
            {

            }
            column(Approver5; Approver5)
            {
            }
            column(ApproverDate4; ApproverDate4)
            {
            }
            column(ApproverDate5; ApproverDate5)
            {
            }
            column(JobTitle4; JobTitle4)
            {
            }
            column(JobTitle5; JobTitle5)
            {
            }
            column(Purpose; Purpose)
            {
            }
            column(Destination; Destination)
            {
            }
            column(Delegatee; Delegatee)
            {
            }
            column(Staff; Staff)
            {
            }
            column(Travel_Start_Date; "Travel Start Date")
            {
            }
            column(Travel_End_Date; "Travel End Date")
            {
            }
            dataitem("Payment Requisition Line"; "Payment Requisition Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No" = FIELD("No.");
                DataItemLinkReference = "Payment Requisition Header";
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
                column(Amount; Amount)
                {

                }

                dataitem("WorkPlan Line"; "WorkPlan Line")
                {
                    DataItemLink = "WorkPlan No" = FIELD("WorkPlan No"),
                                       "Entry No" = FIELD("WorkPlan Entry No");
                    DataItemLinkReference = "Payment Requisition Line";
                    //DataItemTableView = SORTING();
                    column(Entry_No; "Entry No")
                    {

                    }
                    column(Budget_Code; "Budget Code")
                    {

                    }
                    column(Account_No; "Account No")
                    {

                    }
                    column(Account_Name; "Account Name")
                    {

                    }
                    column(Global_Dimension_1_Code; "Global Dimension 1 Code")
                    {

                    }
                    column(Global_Dimension_2_Code; "Global Dimension 2 Code")
                    {

                    }
                    column(DescriptionWorkPlan; Description)
                    {

                    }
                    column(Actuals; Actuals)
                    {

                    }
                    column(Variance; Variance)
                    {

                    }
                }

            }

            trigger OnAfterGetRecord()

            begin
                Clear(Approver1);
                Clear(JobTitle1);
                Clear(ApproverDate1);
                Clear(Approver2);
                Clear(JobTitle2);
                Clear(ApproverDate2);
                Clear(Approver2);
                Clear(JobTitle2);
                Clear(ApproverDate2);
                clear(Approver3);
                Clear(ApproverDate3);

                Employee.Reset();

                if PreparedByEmployee.Get("Requisitioned By") then begin
                    PreparedBy := PreparedByEmployee.FullName();
                    PreparedbyTitle := PreparedByEmployee."Job Title";
                end;

                ApproverCount := 0;
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", DATABASE::"Payment Requisition Header");
                ApprovalEntry.SetRange("Document Type", "Document Type");
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetFilter("Sequence No.", '<>%1', 0);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindSet() then
                    repeat

                        if ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID" then begin
                            ApproverCount := ApproverCount + 1;
                            Employee.SetRange("User ID", ApprovalEntry."Approver ID");
                            if Employee.FindFirst() then;
                        end;
                        if ApproverCount = 1 then begin
                            Approver1 := Employee.FullName();
                            JobTitle1 := Employee."Job Title";
                            ApproverDate1 := ApprovalEntry."Last Date-Time Modified";
                        end
                        else
                            if ApproverCount = 2 then begin
                                Approver2 := Employee.FullName();
                                JobTitle2 := Employee."Job Title";
                                ApproverDate2 := ApprovalEntry."Last Date-Time Modified";
                            end
                            else
                                if ApproverCount = 3 then begin
                                    Approver3 := Employee.FullName();
                                    JobTitle3 := Employee."Job Title";
                                    ApproverDate3 := ApprovalEntry."Last Date-Time Modified";
                                end
                                else
                                    if ApproverCount = 4 then begin
                                        Approver4 := Employee.FullName();
                                        JobTitle4 := Employee."Job Title";
                                        ApproverDate4 := ApprovalEntry."Last Date-Time Modified";
                                    end
                                    else
                                        if ApproverCount = 5 then begin
                                            Approver5 := Employee.FullName();
                                            JobTitle5 := Employee."Job Title";
                                            ApproverDate5 := ApprovalEntry."Last Date-Time Modified";
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
    end;

    var
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
        userSignature: array[4] of Record "User Setup";
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
        Approver4: Text[100];
        Approver5: Text[100];
        JobTitle3: Text[100];
        ApproverDate3: DateTime;
        ApproverDate4: DateTime;
        ApproverDate5: DateTime;
        JobTitle4: Text[100];
        JobTitle5: Text[100];
}