report 50009 "Activity Advance Request"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Report/rdl/Activity Advance Request.rdl';

    dataset
    {
        dataitem("Payment Requisition Header"; "Payment Requisition Header")
        {
            column(No_; "No.")
            {

            }
            column(PV_No_; "PV No.")
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
            column(Purpose; Purpose) { }
            column(Currency_Code; CurrencyCode)
            {

            }
            column(Company_Name; CompanyInfo.Name)
            {

            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyAddress_2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPhoneNo; CompanyPhoneNo)
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyEMail)
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {

            }
            column(CompanyWaterMark; CompanyInfo.Watermark)
            {
            }
            column(Company_TIN; CompanyInfo."VAT Registration No.")
            {
            }
            column(Company_Logo; CompanyInfo.Picture)
            {

            }
            column(DimName; DimName)
            {
            }
            column(PreparedByTitle; PreparedbyTitle)
            {

            }
            column(PreparedSignature; PreparedBySignature)
            {

            }
            column(Modified_By; "Modified By")
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
            column(Modified_Date; "Modified Date")
            {
            }
            column(ModifiedByJobTitle; ModifiedByJobTitle)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(ExpenseCode; ExpenseCode)
            {
            }
            column(Fundsource; Fundsource)
            {
            }
            column(costCenter; costCenter)
            {
            }
            column(ExpenseName; ExpenseName)
            {
            }
            column(Registered_MM_Name; "Registered MM Name") { }
            column(Registered_MM_Number; "Registered MM Number") { }
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
                column(Frequency; Frequency) { }
                column(WHT_Amount; "WHT Amount")
                {

                }
                column(Amount; "Amount To Pay")
                {

                }
                column(WHT_on_VAT_Amount; "WHT on VAT Amount")
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

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if "Account Type" <> "Account Type"::Vendor then begin
                        Clear(ExpenseCode);
                        Clear(ExpenseName);
                        Clear(costCenter);
                        Clear(Fundsource);
                        ExpenseCode := "Account No";
                        ExpenseName := "Account Name";
                        costCenter := "Shortcut Dimension 1 Code";
                        Fundsource := "Shortcut Dimension 2 Code";
                    end;
                end;

            }

            trigger OnAfterGetRecord()

            begin
                Clear(CurrencyCode);

                GeneralLedSetup.Reset();
                GeneralLedSetup.Get();
                if "Currency Code" = '' then
                    CurrencyCode := GeneralLedSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";
                //Get Address Values
                Clear(DimName);
                DimensionValues.Reset();
                DimensionValues.SetRange("Dimension Code", GeneralLedSetup."Shortcut Dimension 1 Code");
                DimensionValues.SetRange(Code, "Global Dimension 1 Code");
                if DimensionValues.FindFirst() then begin
                    DimName := DimensionValues.Name;
                end;

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
                Clear(ExpenseCode);
                Clear(ExpenseName);
                Clear(AppliestoID);
                Clear(AppliestoID1);
                Clear(Fundsource);
                Clear(costCenter);

                Employee.Reset();
                if "Modified By" <> '' then begin
                    Employee.SetRange("User ID", "Modified By");
                    if Employee.FindFirst() then begin
                        ModifiedBy := Employee.FullName();
                        ModifiedByJobTitle := Employee."Job Title";
                    end;
                end;

                Employee.Reset();

                if PreparedByEmployee.Get("Requisitioned By") then begin
                    PreparedBy := PreparedByEmployee.FullName();
                    PreparedbyTitle := PreparedByEmployee."Job Title";
                    PreparedBySignature := PreparedByEmployee."User ID";
                end;

                ApproverCount := 0;
                ApprovalEntry.SetRange("Table ID", DATABASE::"Payment Requisition Header");
                ApprovalEntry.SetRange("Document Type", "Document Type");
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
                if "Payment Category" = 'VENDOR' then begin
                    vendLedgerEntries.SetRange("Applies-to ID", "No.");
                    if vendLedgerEntries.FindSet() then
                        repeat
                            AppliestoID := vendLedgerEntries."Document No.";
                            glEntries.SetRange("Document No.", AppliestoID);
                            if glEntries.FindSet() then
                                repeat
                                    AppliestoID1 := glEntries."G/L Account No.";

                                    chartofAccountts.SetRange("No.", AppliestoID1);
                                    chartofAccountts.SetRange("Income/Balance", chartofAccountts."Income/Balance"::"Income Statement");
                                    if chartofAccountts.FindSet() then
                                        repeat
                                            if ExpenseCode = '' then begin
                                                ExpenseCode := chartofAccountts."No.";
                                                ExpenseName := chartofAccountts.Name;

                                            end
                                            else
                                                if ExpenseCode.Contains(glEntries."G/L Account No.") then
                                                    exit
                                                else begin

                                                    ExpenseCode += ',' + chartofAccountts."No.";
                                                    ExpenseName += ',' + chartofAccountts.Name;

                                                end;

                                            glEntries.SetRange("G/L Account No.", ExpenseCode);
                                            if glEntries.FindFirst() then begin
                                                if costCenter = '' then begin
                                                    costCenter := glEntries."Global Dimension 1 Code";
                                                    Fundsource := glEntries."Global Dimension 2 Code";
                                                end
                                                else
                                                    if costCenter.Contains(glEntries."Global Dimension 1 Code") then
                                                        exit
                                                    else begin

                                                        costCenter += ',' + glEntries."Global Dimension 1 Code";
                                                        Fundsource += ',' + glEntries."Global Dimension 2 Code";
                                                    end;
                                            end;

                                        until chartofAccountts.Next() = 0;

                                until glEntries.Next() = 0;
                        until vendLedgerEntries.Next() = 0;
                end;
            end;
        }

    }


    var
        PreparedBySignature: Code[20];
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
        CompanyAddress: Text[100];
        CompanyPhoneNo: Text[30];
        CompanyMobileNo: Text[30];
        CompanyEmail: Text[80];
        DimName: Text[100];
        PaymentReqLine: Record "Payment Requisition Line";
        ExpenseCode: Text[1000];
        ExpenseName: Text[1000];
        vendLedgerEntries: Record "Vendor Ledger Entry";
        glEntries: Record "G/L Entry";
        AppliestoID: Code[20];
        AppliestoID1: Code[20];
        chartofAccountts: Record "G/L Account";
        costCenter: Text[1000];
        Fundsource: Text[1000];
        postedPurInvLine: Record "Purch. Inv. Line";
}