report 50032 "Budget vs Actual"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Report/rdl/Budget vs Actual.rdl';

    dataset
    {
        dataitem("WorkPlan Header"; "WorkPlan Header")
        {
            DataItemTableView = where(Status = filter(Approved), Blocked = filter(false), "Transferred To Budget" = filter(true));
            RequestFilterFields = "Budget Code", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(CompanyInformation; CompanyInformation.Name) { }
            column(ReportTitle; ReportTitle) { }
            column(ReportFilters; ReportFilters)
            {
            }
            column(PeriodText; StrSubstNo(PeriodText, PeriodEndDate)) { }
            dataitem("WorkPlan Line"; "WorkPlan Line")
            {
                DataItemLinkReference = "WorkPlan Header";
                DataItemLink = "WorkPlan No" = field("No."), "Budget Code" = field("Budget Code");
                RequestFilterFields = "Account No", "Date Filter";
                column(Account_No; "Account No") { }
                column(Account_Name; "Account Name") { }
                column(Description; Description) { }
                column(Activity_Description_Details; "Activity Description Details") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(MonthlyBudget; MonthlyBudget) { }
                column(YTDBudget; YTDBudget) { }
                column(Annual_Amount; "Annual Amount") { }
                column(YTDActuals; YTDActuals) { }
                column(MonthlyExpenses; MonthlyExpenses) { }
                column(TotalCommitments; TotalCommitments) { }
                column(TotalExpenses; TotalExpenses) { }
                column(YTDVariance; YTDVariance) { }
                column(YTDVaraincePercentage; YTDVaraincePercentage) { }
                column(Reallocated_amount; "Reallocated Amount") { }
                trigger OnAfterGetRecord()
                begin
                    Clear(MonthlyBudget);
                    Clear(YTDBudget);
                    Clear(YTDActuals);
                    Clear(TotalCommitments);
                    Clear(TotalExpenses);
                    Clear(MonthlyExpenses);
                    Clear(YTDVariance);
                    Clear(YTDVaraincePercentage);
                    MonthlyBudget := GetMonthyBudget(Date2DMY(GetRangeMax("Date Filter"), 2), "WorkPlan Line");
                    YTDBudget := GetYTDBudgetAmount(Date2DMY(GetRangeMax("Date Filter"), 2), "WorkPlan Line");

                    YTDActuals := calculateYTDActuals("WorkPlan Line");
                    CalcFields(Encumbrances, "Payment Req. Pre-Encumbrances", Advances, "Reallocated Amount", Accountabilities, "Actual Invoices", Actuals, "Credit Memos", "Journal Actuals");
                    MonthlyExpenses := Actuals + "Journal Actuals" + ("Actual Invoices" - "Credit Memos");
                    TotalCommitments := Encumbrances + "Payment Req. Pre-Encumbrances" + Advances + "Reallocated Amount";
                    TotalExpenses := YTDActuals + TotalCommitments;

                    //YTDVariance := YTDBudget - YTDActuals; // Commented out to follow ((YTD Actuals + YTD Commitments)/YTD Budget)*100).
                    YTDVariance := YTDBudget - (YTDActuals + TotalCommitments);
                    // Last colum on the report should be = (Fields!YTDActuals.Value + YTDCommitments)/Fields!Annual_Amount.Value)*100
                    if YTDBudget <> 0 then
                        YTDVaraincePercentage := (YTDVariance / YTDBudget) * 100;
                end;
            }
        }
    }



    var
        myInt: Integer;
        TotalExpenses: Decimal;
        YTDActuals: Decimal;
        TotalCommitments: Decimal;
        MonthlyBudget: Decimal;
        YTDBudget: Decimal;
        MonthlyExpenses: Decimal;
        YTDVariance: Decimal;
        glAccount: Record "G/L Account";
        DateFilter: Text;
        PeriodEndDate: Date;
        YTDVaraincePercentage: Decimal;
        ReportTitle: Label 'ANALYSIS OF ACTUAL EXPENSES AGAINST BUDGET';
        PeriodText: Label 'FOR THE PERIOD ENDED %1';
        CompanyInformation: Record "Company Information";
        ReportFilters: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.get;
        DateFilter := "WorkPlan Line".GetFilter("Date Filter");
        PeriodEndDate := "WorkPlan Line".GetRangeMax("Date Filter");
        ReportFilters := "WorkPlan Header".GetFilters();
    end;

    procedure calculateYTDActuals(var WorkPlanLine: Record "WorkPlan Line"): Decimal
    var
        lvGLEntry: Record "G/L Entry";
        lvPurchInvLine: Record "Purch. Inv. Line";
        lvPurchCrmLine: Record "Purch. Cr. Memo Line";
        lvTotalInvAmount: Decimal;
        lvTotalCrmAmount: Decimal;
        lvTotalActuals: Decimal;
        lvTotalJournalActuals: Decimal;
    begin
        //Calculate Purchase Invoice Actuals.
        // Clear(lvTotalInvAmount);
        // lvPurchInvLine.Reset();
        // lvPurchInvLine.SetCurrentKey("Work Plan", "Work Plan Entry No.", "Budget Name", "Budget Control A/C", "Posting Date");
        // lvPurchInvLine.SetRange("Work Plan", WorkPlanLine."WorkPlan No");
        // lvPurchCrmLine.SetRange("Budget Name", WorkPlanLine."Budget Code");
        // lvPurchInvLine.SetRange("Work Plan Entry No.", WorkPlanLine."Entry No");
        // lvPurchInvLine.SetRange("Budget Control A/C", WorkPlanLine."Account No");
        // lvPurchInvLine.Setfilter("Posting Date", '%1..%2', 0D, WorkPlanLine.GetRangeMax("Date Filter"));
        // if lvPurchInvLine.FindSet() then
        //     repeat
        //         lvTotalInvAmount := lvTotalInvAmount + lvPurchInvLine."Amount (LCY)";
        //     until lvPurchInvLine.Next() = 0;

        //Calculate Purchase Credit memo Actuals.
        // Clear(lvTotalCrmAmount);
        // lvPurchCrmLine.Reset();
        // lvPurchCrmLine.SetCurrentKey("Work Plan", "Work Plan Entry No.", "Budget Name", "Budget Control A/C", "Posting Date");
        // lvPurchCrmLine.SetRange("Work Plan", WorkPlanLine."WorkPlan No");
        // lvPurchCrmLine.SetRange("Budget Name", WorkPlanLine."Budget Code");
        // lvPurchCrmLine.SetRange("Work Plan Entry No.", WorkPlanLine."Entry No");
        // lvPurchCrmLine.SetRange("Budget Control A/C", WorkPlanLine."Account No");
        // lvPurchCrmLine.Setfilter("Posting Date", '%1..%2', 0D, WorkPlanLine.GetRangeMax("Date Filter"));
        // if lvPurchCrmLine.FindSet() then
        //     repeat
        //         lvTotalCrmAmount := lvTotalCrmAmount + lvPurchCrmLine."Amount (LCY)";
        //     until lvPurchCrmLine.Next() = 0;

        //Calculate Totals Actuals
        Clear(lvTotalActuals);
        lvGLEntry.Reset();
        lvGLEntry.SetCurrentKey("Work Plan", "Work Plan Entry No.", "Budget Name", "Budget Control A/C", "Posting Date", "Document Type", "System-Created Entry");
        lvGLEntry.SetFilter("Document Type", '%1|%2|%3', lvGLEntry."Document Type"::Payment, lvGLEntry."Document Type"::Refund, lvGLEntry."Document Type"::" ");
        lvGLEntry.SetRange("Work Plan", WorkPlanLine."WorkPlan No");
        lvGLEntry.SetRange("Budget Name", WorkPlanLine."Budget Code");
        lvGLEntry.SetRange("Work Plan Entry No.", WorkPlanLine."Entry No");
        lvGLEntry.SetRange("G/L Account No.", WorkPlanLine."Account No");
        lvGLEntry.Setfilter("Posting Date", '%1..%2', 0D, WorkPlanLine.GetRangeMax("Date Filter"));
        lvGLEntry.SetRange("System-Created Entry", true);
        if lvGLEntry.FindSet() then
            repeat
                lvTotalActuals := lvTotalActuals + lvGLEntry.Amount;
            until lvGLEntry.Next() = 0;

        //Calculate Totals Actuals from direct Journal entries
        Clear(lvTotalJournalActuals);
        lvGLEntry.Reset();
        lvGLEntry.SetCurrentKey("Work Plan", "Work Plan Entry No.", "Budget Name", "Budget Control A/C", "Posting Date", "Document Type", "System-Created Entry");
        lvGLEntry.SetRange("Work Plan", WorkPlanLine."WorkPlan No");
        lvGLEntry.SetRange("Budget Name", WorkPlanLine."Budget Code");
        lvGLEntry.SetRange("Work Plan Entry No.", WorkPlanLine."Entry No");
        lvGLEntry.SetRange("G/L Account No.", WorkPlanLine."Account No");
        lvGLEntry.Setfilter("Posting Date", '%1..%2', 0D, WorkPlanLine.GetRangeMax("Date Filter"));
        lvGLEntry.SetRange("System-Created Entry", false);
        if lvGLEntry.FindSet() then
            repeat
                lvTotalJournalActuals := lvTotalJournalActuals + lvGLEntry.Amount;
            until lvGLEntry.Next() = 0;
        exit(lvTotalActuals + lvTotalJournalActuals + (lvTotalInvAmount - lvTotalCrmAmount));
    end;

    procedure GetMonthyBudget(Month: Integer; var WorkPlanLine: Record "WorkPlan Line"): Decimal
    begin
        case Month of
            1:
                exit(WorkPlanLine.Month1);
            2:
                exit(WorkPlanLine.Month2);
            3:
                exit(WorkPlanLine.Month3);
            4:
                exit(WorkPlanLine.Month4);
            5:
                exit(WorkPlanLine.Month5);
            6:
                exit(WorkPlanLine.Month6);
            7:
                exit(WorkPlanLine.Month7);
            8:
                exit(WorkPlanLine.Month8);
            9:
                exit(WorkPlanLine.Month9);
            10:
                exit(WorkPlanLine.Month10);
            11:
                exit(WorkPlanLine.Month11);
            12:
                exit(WorkPlanLine.Month12);
        end;
    end;

    procedure GetYTDBudgetAmount(Month: Integer; var WorkPlanLine: Record "WorkPlan Line"): Decimal
    begin
        case Month of
            1:
                exit(WorkPlanLine.Month1);
            2:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2);
            3:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3);
            4:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4);
            5:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5);
            6:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6);
            7:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6 + WorkPlanLine.Month7);
            8:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6 + WorkPlanLine.Month7 + WorkPlanLine.Month8);
            9:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6 + WorkPlanLine.Month7 + WorkPlanLine.Month8 + WorkPlanLine.Month9);
            10:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6 + WorkPlanLine.Month7 + WorkPlanLine.Month8 + WorkPlanLine.Month9 + WorkPlanLine.Month10);
            11:
                exit(WorkPlanLine.Month1 + WorkPlanLine.Month2 + WorkPlanLine.Month3 + WorkPlanLine.Month4 + WorkPlanLine.Month5 + WorkPlanLine.Month6 + WorkPlanLine.Month7 + WorkPlanLine.Month8 + WorkPlanLine.Month9 + WorkPlanLine.Month10 + WorkPlanLine.Month11);
            12:
                exit(WorkPlanLine."Annual Amount");
        end;
    end;

}