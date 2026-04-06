table 50040 "Budget Control Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Activate Budget Control"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Budget Control Method"; Option)
        {
            Caption = 'Budget Control Method';
            OptionCaption = ' ,Soft Control,Hard Control';
            OptionMembers = " ","Soft Control","Hard Control";
        }
        field(4; "Original Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Preliminary Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Budget Revision"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Budget Transfers"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Actual Expenditure"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Unposted Expenditure"; Boolean)
        {
            Caption = 'Unposted Expenditures';
            DataClassification = ToBeClassified;
        }
        field(10; "Encumbrances"; Boolean)
        {
            Caption = 'Encumbrances';
            DataClassification = ToBeClassified;
        }
        field(11; "Unconfirmed Encumbrances"; Boolean)
        {
            Caption = 'Unconfirmed Encumbrances';
            DataClassification = ToBeClassified;
        }
        field(12; "Pre-encumbrances"; Boolean)
        {
            Caption = 'Pre-encumbrance';
            DataClassification = ToBeClassified;
        }
        field(13; "Unconfirmed Pre-encumbrances"; Boolean)
        {
            Caption = 'Unconfirmed Pre-encumbrances';
            DataClassification = ToBeClassified;
        }
        field(81; "Budget Dimension 1 Code"; Code[20])
        {
            Caption = 'Budget Dimension 1 Code';
            TableRelation = Dimension;
        }
        field(82; "Budget Dimension 2 Code"; Code[20])
        {
            Caption = 'Budget Dimension 2 Code';
            TableRelation = Dimension;
        }
        field(83; "Budget Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            Caption = 'Budget Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(84; "Budget Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            Caption = 'Budget Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(86; "Budget Dimension 5 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            Caption = 'Budget Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(87; "Budget Dimension 6 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            Caption = 'Budget Dimension 6 Code';
            TableRelation = Dimension;
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure CheckBudget(WorkPlan: Code[20]; WorkPlanEntry: Integer; BudgetCode: Code[20]; LineAmount: Decimal; ExistingLineAmt: Decimal): Decimal
    var
        WorkPlanLine: Record "WorkPlan Line";
        BudgetControlSetup: Record "Budget Control Setup";
        lvTotalDeductions: Decimal;
        lvTotalEntitlement: Decimal;
        lvAvailableBudget: Decimal;
        Text01: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual & Commitments = %4\\Pending Amount = %5\\Available Amount = %6';
        Text02: Label 'There is no budget that was allocated for this line';
    begin
        BudgetControlSetup.Get();
        if BudgetControlSetup."Activate Budget Control" then begin
            WorkPlanLine.SetRange("WorkPlan No", WorkPlan);
            WorkPlanLine.SetRange("Entry No", WorkPlanEntry);
            WorkPlanLine.SetRange("Budget Code", BudgetCode);
            if WorkPlanLine.FindFirst() then begin
                WorkPlanLine.CalcFields(Actuals, "Journal Actuals", "Reallocated Amount", "Actual Invoices", Encumbrances, "Credit Memos", "Payment Req. Pre-Encumbrances", "Unconfirmed Encumbrances", Advances, Accountabilities, "General Journals");

                //Sums to Add ==========================================
                if BudgetControlSetup."Original Budget" then
                    lvTotalEntitlement += WorkPlanLine."Annual Amount";
                //======================================================

                //Sums to Subtract =====================================
                if BudgetControlSetup."Actual Expenditure" then
                    lvTotalDeductions := WorkPlanLine.Actuals + WorkPlanLine."Journal Actuals" + (WorkPlanLine."Actual Invoices" - WorkPlanLine."Credit Memos");
                if BudgetControlSetup.Encumbrances then
                    lvTotalDeductions += WorkPlanLine.Encumbrances + WorkPlanLine.Advances + WorkPlanLine.Accountabilities + WorkPlanLine."General Journals";
                if BudgetControlSetup."Unconfirmed Encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Unconfirmed Encumbrances";
                if BudgetControlSetup."Pre-encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Payment Req. Pre-Encumbrances";

                //    lvTotalDeductions += WorkPlanLine."Pre-Encumbrances" + WorkPlanLine."Payment Req. Pre-Encumbrances";
                // if BudgetControlSetup."Unconfirmed Pre-encumbrances" then
                //     lvTotalDeductions += WorkPlanLine."Unconfirmed Pre-Encumbrances";
                //======================================================

                lvAvailableBudget := lvTotalEntitlement - lvTotalDeductions - ExistingLineAmt - WorkPlanLine."Reallocated Amount";
                if LineAmount > lvAvailableBudget then
                    Error(Text01, WorkPlanLine."Account No", LineAmount, lvTotalEntitlement, lvTotalDeductions, ExistingLineAmt, lvAvailableBudget);

            end
            else
                Error(Text02);

            exit(lvAvailableBudget);
        end;

    end;

    procedure CheckBudget(WorkPlan: Code[20]; WorkPlanEntry: Integer; BudgetCode: Code[20]; LineAmount: Decimal; ExistingLineAmt: Decimal; AdditionalAmountToExclude: Decimal): Decimal
    var
        WorkPlanLine: Record "WorkPlan Line";
        BudgetControlSetup: Record "Budget Control Setup";
        lvTotalDeductions: Decimal;
        lvTotalEntitlement: Decimal;
        lvAvailableBudget: Decimal;
        Text01: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual & Commitments = %4\\Pending Amount = %5\\Available Amount = %6';
        Text02: Label 'There is no budget that was allocated for this line';
    begin
        //Additional amount to exclude refers to the amount on a line that is already part of the commitments and should be deducted to support the budget check.
        BudgetControlSetup.Get();
        if BudgetControlSetup."Activate Budget Control" then begin
            WorkPlanLine.SetRange("WorkPlan No", WorkPlan);
            WorkPlanLine.SetRange("Entry No", WorkPlanEntry);
            WorkPlanLine.SetRange("Budget Code", BudgetCode);
            if WorkPlanLine.FindFirst() then begin
                WorkPlanLine.CalcFields(Actuals, "Journal Actuals", "Reallocated Amount", "Actual Invoices", Encumbrances, "Credit Memos", "Payment Req. Pre-Encumbrances", "Unconfirmed Encumbrances", Advances, Accountabilities, "General Journals");

                //Sums to Add ==========================================
                if BudgetControlSetup."Original Budget" then
                    lvTotalEntitlement += WorkPlanLine."Annual Amount";
                //======================================================

                //Sums to Subtract =====================================
                if BudgetControlSetup."Actual Expenditure" then
                    lvTotalDeductions := WorkPlanLine.Actuals + WorkPlanLine."Journal Actuals" + (WorkPlanLine."Actual Invoices" - WorkPlanLine."Credit Memos");
                if BudgetControlSetup.Encumbrances then
                    lvTotalDeductions += WorkPlanLine.Encumbrances + WorkPlanLine.Advances + WorkPlanLine.Accountabilities + WorkPlanLine."General Journals";
                if BudgetControlSetup."Unconfirmed Encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Unconfirmed Encumbrances";
                if BudgetControlSetup."Pre-encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Payment Req. Pre-Encumbrances";

                //lvTotalDeductions += WorkPlanLine."Pre-Encumbrances" + WorkPlanLine."Payment Req. Pre-Encumbrances";
                // if BudgetControlSetup."Unconfirmed Pre-encumbrances" then
                //     lvTotalDeductions += WorkPlanLine."Unconfirmed Pre-Encumbrances";

                //Deduct the amount that needs to be excluded from the total deductions.
                lvTotalDeductions := lvTotalDeductions - AdditionalAmountToExclude;
                //======================================================

                lvAvailableBudget := lvTotalEntitlement - lvTotalDeductions - ExistingLineAmt - WorkPlanLine."Reallocated Amount";
                if LineAmount > lvAvailableBudget then
                    Error(Text01, WorkPlanLine."Account No", LineAmount, lvTotalEntitlement, lvTotalDeductions, ExistingLineAmt, lvAvailableBudget);

            end
            else
                Error(Text02);

            exit(lvAvailableBudget);
        end;

    end;

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}