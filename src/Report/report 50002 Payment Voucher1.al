report 50002 "Payment Voucher1"
{
    Caption = 'Payment Voucher';
    RDLCLayout = './src/Report/rdl/Payment Voucher Printout.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

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
            column(JournalBatch; JournalBatch) { }
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
            column(Dimension2Name; Dimension2Name) { }
            column(Registered_MM_Number; "Registered MM Number") { }
            column(Registered_MM_Name; "Registered MM Name") { }
            column(Mode_Of_Payment; "Mode Of Payment") { }
            column(Prepared_By; "Prepared By") { }
            column(Prepared_By_Name; "Prepared By Name") { }
            column(PreparedByTitle; PreparedbyTitle)
            {

            }
            column(PreparedSignature; PreparedByEmployee.Signature2)
            {

            }
            column(PreparedByDate; "Modified Date") { }
            column(PreparedAt_Time; "Modified Time") { }
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
            column(Ext_Document_No; "Ext Document No")
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
                column(WHT_Amount; "WHT Amount")
                {

                }
                column(Amount; "Amount To Pay")
                {

                }
                column(Amount_To_Pay__LCY_; "Amount To Pay (LCY)")
                {

                }
                column(CurrencyCode; CurrencyCode)
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
                    column(WorkPlan_NoAndEntryNo; "WorkPlan No" + '-' + Format("Entry No")) { }
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
                    column(WorkPlan_Dimension_1_Code; "WorkPlan Dimension 1 Code")
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
                    column(WorkPlan_No; "WorkPlan No") { }
                }

            }

            trigger OnAfterGetRecord()
            var
                gvemployee: record employee;
                GenReqsetup: Record "Gen. Requisition Setup";
            begin
                Clear(CurrencyCode);
                // alm begin

                if "Gen. Batch Name" <> '' then
                    JournalBatch := "Gen. Batch Name"
                else
                    JournalBatch := GenReqsetup."Req Journal Batch";

                GeneralLedSetup.Reset();
                GeneralLedSetup.Get();
                if "Currency Code" = '' then
                    CurrencyCode := GeneralLedSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";
                //Get Address Values
                Clear(CompanyAddress);
                Clear(CompanyEmail);
                Clear(CompanyPhoneNo);
                Clear(CompanyMobileNo);
                Clear(DimName);
                Clear(Dimension2Name);
                DimensionValues.Reset();
                DimensionValues.SetRange("Dimension Code", GeneralLedSetup."Shortcut Dimension 1 Code");
                DimensionValues.SetRange(Code, "Global Dimension 1 Code");


                DimensionValues.Reset();
                DimensionValues.SetRange("Dimension Code", GeneralLedSetup."Shortcut Dimension 2 Code");
                DimensionValues.SetRange(Code, "Global Dimension 2 Code");
                if DimensionValues.FindFirst() then
                    Dimension2Name := DimensionValues.Name;

                Clear(Approver1);
                Clear(JobTitle1);
                Clear(ApproverDate1);
                Clear(Approver2);
                Clear(JobTitle2);
                Clear(ApproverDate2);
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
                Clear(RequestedBy);
                clear(RequestedbyJobTitle);
                clear(userSignature1);
                clear(userSignature2);
                clear(userSignature3);
                clear(userSignature4);
                clear(userSignature5);
                clear(userSignature6);

                RequestedByEmployee.Reset();
                RequestedByEmployee.SetRange("No.", "Request No.");
                if RequestedByEmployee.FindFirst() then begin
                    RequestedBy := RequestedByEmployee.FullName();
                    RequestedbyJobTitle := RequestedByEmployee."Job Title";
                    RequestedByEmployee.CalcFields(Signature2);
                end;

                if PreparedByEmployee.Get("Prepared By") then begin
                    PreparedBy := PreparedByEmployee.FullName();
                    PreparedbyTitle := PreparedByEmployee."Job Title";
                    PreparedByEmployee.CalcFields(Signature2);
                end;

                ApproverCount := 0;
                ApprovalEntry.SetRange("Table ID", DATABASE::"Payment Requisition Header");
                ApprovalEntry.SetRange("Document Type", "Document Type");
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetFilter("Sequence No.", '<>%1', 0);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindSet() then begin
                    ApprovalEntry.SetCurrentKey("Sequence No.");
                    ApprovalEntry.SetAscending("Sequence No.", true);
                    repeat

                        if ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID" then
                            if ApprovalEntry."Approver ID" <> '' then begin
                                ApproverCount := ApproverCount + 1;
                                if ApproverCount = 1 then begin
                                    Employee1.Reset();
                                    Employee1.SetRange(Employee1."User ID", ApprovalEntry."Approver ID");
                                    if Employee1.FindFirst() then begin
                                        Approver1 := Employee1.FullName();
                                        JobTitle1 := Employee1."Job Title";
                                        ApproverDate1 := ApprovalEntry."Last Date-Time Modified";
                                        Employee1.CalcFields(Signature2);
                                    end;
                                end else if ApproverCount = 2 then begin
                                    Employee2.Reset();
                                    Employee2.SetRange(Employee2."User ID", ApprovalEntry."Approver ID");
                                    if Employee2.FindFirst() then;
                                    begin
                                        Approver2 := Employee2.FullName();
                                        JobTitle2 := Employee2."Job Title";
                                        ApproverDate2 := ApprovalEntry."Last Date-Time Modified";
                                        Employee2.CalcFields(Signature2);
                                    end;
                                end else if ApproverCount = 3 then begin
                                    Employee3.Reset();
                                    Employee3.SetRange(Employee3."User ID", ApprovalEntry."Approver ID");
                                    if Employee3.FindFirst() then;
                                    begin
                                        Approver3 := Employee3.FullName();
                                        JobTitle3 := Employee3."Job Title";
                                        ApproverDate3 := ApprovalEntry."Last Date-Time Modified";
                                        Employee3.CalcFields(Signature2);
                                    end;
                                end else if ApproverCount = 4 then begin
                                    Employee4.Reset();
                                    Employee4.SetRange(Employee4."User ID", ApprovalEntry."Approver ID");
                                    if Employee4.FindFirst() then;
                                    begin
                                        Approver4 := Employee4.FullName();
                                        JobTitle4 := Employee4."Job Title";
                                        ApproverDate4 := ApprovalEntry."Last Date-Time Modified";
                                        Employee4.CalcFields(Signature2);
                                    end;
                                end else if ApproverCount = 5 then begin
                                    Employee5.Reset();
                                    Employee5.SetRange(Employee5."User ID", ApprovalEntry."Approver ID");
                                    if Employee5.FindFirst() then;
                                    begin
                                        Approver5 := Employee5.FullName();
                                        JobTitle5 := Employee5."Job Title";
                                        ApproverDate5 := ApprovalEntry."Last Date-Time Modified";
                                        Employee5.CalcFields(Signature2);
                                    end;
                                end else if ApproverCount = 6 then begin
                                    Employee6.Reset();
                                    Employee6.SetRange(Employee6."User ID", ApprovalEntry."Approver ID");
                                    if Employee6.FindFirst() then;
                                    begin
                                        Approver6 := Employee6.FullName();
                                        JobTitle6 := Employee6."Job Title";
                                        ApproverDate6 := ApprovalEntry."Last Date-Time Modified";
                                        Employee6.CalcFields(Signature2);
                                    end;
                                end;
                            end;
                    until ApprovalEntry.Next() = 0;
                end;
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
        //CompanyInfo.CalcFields(Watermark);
    end;

    var
        CompanyInfo: Record "Company Information";
        GeneralLedSetup: Record "General Ledger Setup";
        DimensionValues: Record "Dimension Value";
        Dimension2Name: Text;
        CostCenterName: Text;
        ApprovalEntry: Record "Approval Entry";
        ApproverCount: Integer;
        RequestedByEmployee: Record Employee;
        Employee1: Record Employee;
        Employee2: Record Employee;
        Employee3: Record Employee;
        Employee4: Record Employee;
        Employee5: Record Employee;
        Employee6: Record Employee;
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
        RequestedBy: Text[100];
        RequestedbyJobTitle: Text[100];
        CurrencyCode: Code[20];
        userSignature1: Code[50];
        userSignature2: Code[50];
        userSignature3: Code[50];
        userSignature4: Code[50];
        userSignature5: Code[50];
        userSignature6: Code[50];
        userSignature7: Code[50];
        CompanyAddress: Text[100];
        CompanyPhoneNo: Text[30];
        CompanyMobileNo: Text[30];
        CompanyEmail: Text[80];
        DimName: Text[100];
        JournalBatch: Code[20];

}