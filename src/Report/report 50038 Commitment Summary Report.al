report 50038 "Commitment Summary Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Commitment Summary Report';
    RDLCLayout = './src/Report/rdl/Commitment Summary Report.rdl';

    dataset
    {
        dataitem("WorkPlan Header"; "WorkPlan Header")
        {
            DataItemTableView = where(Status = filter(Approved), Blocked = filter(false), "Transferred To Budget" = filter(true));
            RequestFilterFields = "Budget Code", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(CompanyName; CompanyInformation.Name) { }
            column(ReportTitle; ReportTitle) { }
            column(ReportFilters; ReportFilters)
            {
            }
            column(gvShowSummary; gvShowSummary) { }
            dataitem("WorkPlan Line"; "WorkPlan Line")
            {
                DataItemLinkReference = "WorkPlan Header";
                DataItemLink = "WorkPlan No" = field("No."), "Budget Code" = field("Budget Code");
                RequestFilterFields = "Date Filter";
                column(Account_No; "Account No") { }
                column(Account_Name; "Account Name") { }
                column(Description; Description) { }
                column(Activity_Description_Details; "Activity Description Details") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(WorkPlan_Dimension_1_Code; "WorkPlan Dimension 1 Code") { }
                column(WorkPlan_Dimension_2_Code; "WorkPlan Dimension 2 Code") { }
                column(gvWorkplanDim2Name; gvWorkplanDim2Name) { }
                column(Annual_Amount; "Annual Amount" - "Reallocated Amount") { }
                column(Encumbrances; Encumbrances) { }
                // column(Pre_Encumbrances; "Pre-Encumbrances") { }
                column(Payment_Req__Pre_Encumbrances; "Payment Req. Pre-Encumbrances") { }
                column(Advances; Advances) { }
                column(Accountabilities; Accountabilities) { }
                column(TotalCommitments; TotalCommitments) { }
                column(TotalActuals; TotalActuals) { }
                trigger OnAfterGetRecord()
                begin
                    Clear(TotalCommitments);
                    Clear(TotalActuals);

                    CalcFields(Encumbrances, "Payment Req. Pre-Encumbrances", Advances, "Reallocated Amount", Accountabilities, "Actual Invoices", Actuals, "Credit Memos", "Journal Actuals");
                    TotalCommitments := Encumbrances + "Payment Req. Pre-Encumbrances" + Advances + Accountabilities;
                    TotalActuals := Actuals + "Journal Actuals" + ("Actual Invoices" - "Credit Memos");

                    Clear(gvWorkplanDim2Name);
                    GLSetup.get();
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                    DimensionValue.SetRange(Code, "WorkPlan Dimension 2 Code");
                    if DimensionValue.FindFirst() then
                        gvWorkplanDim2Name := DimensionValue.Name;

                    if TotalCommitments = 0 then
                        CurrReport.Skip();

                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(gvShowSummary; gvShowSummary)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Summary By Activity';
                        ToolTip = 'Specifies the report should be displayed based on the summary';
                    }

                }
            }
        }

        actions
        {
        }
    }

    var
        CompanyInformation: Record "Company Information";
        DimensionValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        TotalActuals: Decimal;
        TotalCommitments: Decimal;
        DateFilter: Text;
        ReportTitle: Label 'Commitment Summary Report';
        PeriodText: Label 'FOR THE PERIOD ENDED %1';
        ReportFilters: Text;
        gvWorkplanDim2Name: Text;
        gvShowSummary: Boolean;

    trigger OnPreReport()
    begin
        CompanyInformation.get();
        DateFilter := "WorkPlan Line".GetFilter("Date Filter");
        ReportFilters := "WorkPlan Header".GetFilters();
    end;

}