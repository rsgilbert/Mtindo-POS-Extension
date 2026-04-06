table 50021 "Budget Realloc. Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";


        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Workplan No."; Code[20])
        {
            TableRelation = "WorkPlan Header" where(Blocked = filter(false), "Transferred To Budget" = filter(true), Status = filter(Approved));

            trigger Onvalidate()
            var
                lvWorkplanHeader: Record "WorkPlan Header";
                TempLine: Record "Budget Realloc. Lines" temporary;
            begin
                if (xRec."Workplan No." <> Rec."Workplan No.") AND (xRec."Workplan No." <> '') then begin
                    ClearFields();
                end;
                lvWorkplanHeader.Reset();
                lvWorkplanHeader.SetRange("No.", "Workplan No.");
                if lvWorkplanHeader.FindFirst() then begin
                    "Budget Code" := lvWorkplanHeader."Budget Code";
                    "Global Dimension Code 1" := lvWorkplanHeader."Shortcut Dimension 1 Code";
                    if lvWorkplanHeader."Shortcut Dimension 2 Code" <> '' then
                        if lvWorkplanHeader."Shortcut Dimension 2 Code" <> '' then
                            "Global Dimension Code 2" := lvWorkplanHeader."Shortcut Dimension 2 Code";
                end;
            end;
        }

        field(5; "Account No"; Code[20])
        {
            Caption = 'From Account';
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Add to Work Plan" = const(true));

        }
        field(6; "Workplan Entry No."; Integer)
        {
            Caption = 'Budget Line';
            trigger OnValidate()
            var
                myInt: Integer;
                lvWorkplanLine: Record "WorkPlan Line";
                BudControlSetup: Record "Budget Control Setup";
            begin
                BudControlSetup.Get();
                lvWorkplanLine.Reset();
                lvWorkplanLine.SetRange("WorkPlan No", "Workplan No.");
                lvWorkplanLine.SetRange("Budget Code", "Budget Code");
                lvWorkplanLine.SetRange("Account No", "Account No");
                lvWorkplanLine.SetRange("Entry No", "Workplan Entry No.");
                if lvWorkplanLine.FindFirst() then begin
                    lvWorkplanLine.CalcFields(Actuals, "Reallocated Amount", Encumbrances, "Payment Req. Pre-Encumbrances", "Credit Memos", "Actual Invoices", Advances);
                    "Available Amount" := BudControlSetup.CheckBudget("WorkPlan No.", "Workplan Entry No.", "Budget Code", Amount, 0);
                    //"Available Amount" :=  lvWorkplanLine."Annual Amount" - (lvWorkplanLine.Commitment + lvWorkplanLine.Actuals + lvWorkplanLine."Reallocated Amount");
                    "Activity Description" := lvWorkplanLine.Description;
                    "Global Dimension Code 2" := lvWorkplanLine."Global Dimension 2 Code";
                    "WorkPlan Dimension 1 Code" := lvWorkplanLine."WorkPlan Dimension 1 Code";
                    "WorkPlan Dimension 2 Code" := lvWorkplanLine."WorkPlan Dimension 2 Code";
                    "WorkPlan Dimension 3 Code" := lvWorkplanLine."WorkPlan Dimension 3 Code";
                    "WorkPlan Dimension 4 Code" := lvWorkplanLine."WorkPlan Dimension 4 Code";
                    "WorkPlan Dimension 5 Code" := lvWorkplanLine."WorkPlan Dimension 5 Code";
                    "WorkPlan Dimension 6 Code" := lvWorkplanLine."WorkPlan Dimension 6 Code";
                    Validate("Dimension Set ID", lvWorkplanLine."Dimension Set ID");
                end;

            end;

            trigger OnLookup()
            var
                WorkPlanEntry: Page "Budget Entries";
                WorkPlanLne: Record "WorkPlan Line";
            begin
                WorkPlanLne.SetRange("WorkPlan No", "Workplan No.");
                WorkPlanLne.SetRange("Budget Code", "Budget Code");
                WorkPlanLne.SetRange("Account No", "Account No");
                if WorkPlanLne.FindFirst() then begin
                    WorkPlanEntry.SetTableView(WorkPlanLne);
                    WorkPlanEntry.SetRecord(WorkPlanLne);
                    WorkPlanEntry.LookupMode(true);
                    if WorkPlanEntry.RunModal() = Action::LookupOK then begin
                        WorkPlanEntry.GetRecord(WorkPlanLne);
                        Validate("Workplan Entry No.", WorkPlanLne."Entry No");
                    end;
                end
                else
                    Error('There is no budget for account No %1 in workplan %2', "Account No", "Workplan No.");

            end;

        }
        field(7; "Available Amount"; Decimal)
        {
        }
        field(8; "Activity Description"; Text[100])
        {

        }
        field(9; "WorkPlan Dimension 1 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(1, "Workplan No.");
            Caption = 'WorkPlan Dimension 1 Code';
        }
        field(10; "Global Dimension Code 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Global Dimension Code 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(12; "WorkPlan Dimension 2 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(2, "Workplan No.");
            Caption = 'WorkPlan Dimension 2 Code';
        }

        field(13; "WorkPlan Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(3, "Workplan No.");
            Caption = 'WorkPlan Dimension 3 Code';
        }
        field(14; "WorkPlan Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(4, "Workplan No.");
            Caption = 'WorkPlan Dimension 4 Code';
        }
        field(15; "WorkPlan Dimension 5 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(5, "Workplan No.");
            Caption = 'WorkPlan Dimension 5 Code';
        }
        field(16; "WorkPlan Dimension 6 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(6, "Workplan No.");
            Caption = 'WorkPlan Dimension 6 Code';
        }
        field(17; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            trigger OnValidate()
            begin
                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                    Error(DimMgt.GetDimCombErr);
            end;
        }
        field(18; "New Workplan No."; Code[20])
        {
            TableRelation = "WorkPlan Header" where(Blocked = const(false), "Transferred To Budget" = const(true));
            // TableRelation = "WorkPlan Header" where(Blocked = const(false), "Transferred To Budget" = const(true), "Shortcut Dimension 1 Code" = field("Global Dimension Code 1"), "Shortcut Dimension 2 Code" = field("Global Dimension Code 2"));

            trigger OnValidate()
            var
                lvWorkplanHeader: Record "WorkPlan Header";
            begin
                lvWorkplanHeader.Reset();
                lvWorkplanHeader.SetRange("No.", "New Workplan No.");
                if lvWorkplanHeader.FindFirst() then begin
                    Validate("New Global Dimension Code 1", lvWorkplanHeader."Shortcut Dimension 1 Code");
                    Validate("New Global Dimension Code 2", lvWorkplanHeader."Shortcut Dimension 2 Code");
                    Validate("New Budget Code", lvWorkplanHeader."Budget Code");
                end;
            end;
        }
        field(19; "New G/L Account"; Code[20])
        {
            Caption = 'To Account';
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Add to Work Plan" = const(true));
        }
        field(20; Amount; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                lvbudgetReallocationLine: Record "Budget Realloc. Lines";
                lvPendingAmount: Decimal;
            begin
                TestBudgetReallocHeaderStatusOpen();
                Amount := Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12;
                lvPendingAmount := 0;
                lvbudgetReallocationLine.Reset();
                lvbudgetReallocationLine.SetRange("Workplan No.", "Workplan No.");
                lvbudgetReallocationLine.SetRange("Account No", "Account No");
                lvbudgetReallocationLine.SetRange("Workplan Entry No.", "Workplan Entry No.");
                if lvbudgetReallocationLine.FindSet() then
                    repeat
                        lvPendingAmount := lvPendingAmount + lvbudgetReallocationLine.Amount;
                    until lvbudgetReallocationLine.Next() = 0;
                if Amount > "Available Amount" then
                    Error('You cannot reallocate more than the available annual amount %1, pending amount %2.', "Available Amount", lvPendingAmount);
            end;
        }
        field(21; "New Global Dimension Code 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                if "New Global Dimension Code 1" = xRec."New Global Dimension Code 1" then
                    exit;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
            end;

            trigger OnLookup()
            begin
                "New Global Dimension Code 1" := OnLookupDimCode(0, "New Global Dimension Code 1");
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
            end;
        }
        field(22; "New Global Dimension Code 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                if "New Global Dimension Code 2" = xRec."New Global Dimension Code 2" then
                    exit;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
            end;

            trigger OnLookup()
            begin
                "New Global Dimension Code 2" := OnLookupDimCode(1, "New Global Dimension Code 2");
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
            end;
        }
        field(23; "New WorkPlan Dimension 1 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(1, "New Workplan No.");

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 1 Code" := OnLookupDimCode(2, "New WorkPlan Dimension 1 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 1 Code", "New WorkPlan Dimension 1 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 1 Code", "New WorkPlan Dimension 1 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 1 Code" = xRec."New WorkPlan Dimension 1 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 1 Code", "New WorkPlan Dimension 1 Code");
                UpdateDimensionSetId(workPlan."WorkPlan Dimension 1 Code", "New WorkPlan Dimension 1 Code");
            end;
        }
        field(24; "New WorkPlan Dimension 2 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(2, "New Workplan No.");
            Caption = 'WorkPlan Dimension 4 Code';

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 2 Code" := OnLookupDimCode(3, "New WorkPlan Dimension 2 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 2 Code", "New WorkPlan Dimension 2 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 2 Code", "New WorkPlan Dimension 2 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 2 Code" = xRec."New WorkPlan Dimension 2 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 2 Code", "New WorkPlan Dimension 2 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 2 Code", "New WorkPlan Dimension 2 Code");
            end;
        }

        field(25; "New WorkPlan Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(3, "New Workplan No.");

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 3 Code" := OnLookupDimCode(4, "New WorkPlan Dimension 3 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 3 Code", "New WorkPlan Dimension 3 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 3 Code", "New WorkPlan Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 3 Code" = xRec."New WorkPlan Dimension 3 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 3 Code", "New WorkPlan Dimension 3 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 3 Code", "New WorkPlan Dimension 3 Code");
            end;
        }
        field(26; "New WorkPlan Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(4, "New Workplan No.");
            Caption = 'WorkPlan Dimension 4 Code';

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 4 Code" := OnLookupDimCode(5, "New WorkPlan Dimension 4 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 4 Code", "New WorkPlan Dimension 4 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 4 Code", "New WorkPlan Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 4 Code" = xRec."New WorkPlan Dimension 4 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 4 Code", "New WorkPlan Dimension 4 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 4 Code", "New WorkPlan Dimension 4 Code");
            end;
        }
        field(28; "New WorkPlan Dimension 5 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(5, "New Workplan No.");
            Caption = 'WorkPlan Dimension 5 Code';

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 5 Code" := OnLookupDimCode(6, "New WorkPlan Dimension 5 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 5 Code", "New WorkPlan Dimension 5 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 5 Code", "New WorkPlan Dimension 5 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 5 Code" = xRec."New WorkPlan Dimension 5 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 5 Code", "New WorkPlan Dimension 5 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 5 Code", "New WorkPlan Dimension 5 Code");
            end;
        }
        field(30; "New WorkPlan Dimension 6 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(6, "New Workplan No.");
            Caption = 'WorkPlan Dimension 6 Code';

            trigger OnLookup()
            begin
                "New WorkPlan Dimension 6 Code" := OnLookupDimCode(7, "New WorkPlan Dimension 6 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 6 Code", "New WorkPlan Dimension 6 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 6 Code", "New WorkPlan Dimension 6 Code");
            end;

            trigger OnValidate()
            begin
                if "New WorkPlan Dimension 6 Code" = xRec."New WorkPlan Dimension 6 Code" then
                    exit;
                if WorkPlan."No." <> "New Workplan No." then
                    WorkPlan.Get("New Workplan No.");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 6 Code", "New WorkPlan Dimension 6 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 6 Code", "New WorkPlan Dimension 6 Code");
            end;
        }
        field(32; "New Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            trigger OnValidate()
            begin
                if not DimMgt.CheckDimIDComb("New Dimension Set ID") then
                    Error(DimMgt.GetDimCombErr);
            end;
        }

        field(34; "New Activity Description"; Text[100])
        {

        }
        field(36; "Fully Reallocated"; Boolean)
        {
        }
        field(38; "Quarter 1 Amount"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestField("New Workplan No.");
                TestField("New G/L Account");
                //TestField("New WorkPlan Dimension 1 Code");
                //TestField("New WorkPlan Dimension 2 Code");
                validate(Amount);
            end;
        }
        field(40; "Quarter 2 Amount"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestField("New Workplan No.");
                TestField("New G/L Account");
                //TestField("New WorkPlan Dimension 1 Code");
                //TestField("New WorkPlan Dimension 2 Code");
                validate(Amount);
            end;
        }
        field(42; "Quarter 3 Amount"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestField("New Workplan No.");
                TestField("New G/L Account");
                //TestField("New WorkPlan Dimension 1 Code");
                //TestField("New WorkPlan Dimension 2 Code");
                validate(Amount);
            end;
        }
        field(44; "Quarter 4 Amount"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestField("New Workplan No.");
                TestField("New G/L Account");
                //TestField("New WorkPlan Dimension 1 Code");
                //TestField("New WorkPlan Dimension 2 Code");
                validate(Amount);
            end;
        }
        field(46; "New Budget Code"; Code[20])
        {

        }
        field(48; "Reallocate"; Boolean)
        {

        }

        field(50; "Budget Code"; Code[20])
        {

        }

        field(51; Month1; Decimal)
        {
            Caption = 'Month 1';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(52; Month2; Decimal)
        {
            Caption = 'Month 2';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(53; Month3; Decimal)
        {
            Caption = 'Month 3';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));

                CheckMandatoryDimensions();
            end;
        }
        field(54; Month4; Decimal)
        {
            Caption = 'Month 4';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(55; Month5; Decimal)
        {
            Caption = 'Month 5';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(56; Month6; Decimal)
        {
            Caption = 'Month 6';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(57; Month7; Decimal)
        {
            Caption = 'Month 7';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(58; Month8; Decimal)
        {
            Caption = 'Month 8';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(59; Month9; Decimal)
        {
            Caption = 'Month 9';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(60; Month10; Decimal)
        {
            Caption = 'Month 10';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(61; Month11; Decimal)
        {
            Caption = 'Month 11';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(62; Month12; Decimal)
        {
            Caption = 'Month 12';
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
                CheckMandatoryDimensions();
            end;
        }
        field(64; "Dimension Value Name 1"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(1),
                                                               Code = FIELD("Global Dimension Code 1")));
            // Caption = 'Cost Center Name';
            CaptionClass = '1,1,1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Dimension Value Name 2"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(2),
                                                               Code = FIELD("Global Dimension Code 2")));
            CaptionClass = '1,1,2';
            Editable = false;
            FieldClass = FlowField;
        }

        field(67; "Dimension Value Name 3"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(3),
                                                               Code = FIELD("WorkPlan Dimension 1 Code")));
            CaptionClass = '1,2,3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(68; "Dimension Value Name 4"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(4),
                                                               Code = FIELD("WorkPlan Dimension 2 Code")));
            CaptionClass = '1,2,4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "Dimension Value Name 5"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(5),
                                                               Code = FIELD("WorkPlan Dimension 3 Code")));
            CaptionClass = '1,2,5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "New Dimension Value Name 1"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(1),
                                                               Code = FIELD("New Global Dimension Code 1")));
            // Caption = 'Cost Center Name';
            CaptionClass = '1,1,1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "New Dimension Value Name 2"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(2),
                                                               Code = FIELD("New Global Dimension Code 2")));
            CaptionClass = '1,1,2';
            Editable = false;
            FieldClass = FlowField;
        }

        field(72; "New Dimension Value Name 3"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(3),
                                                               Code = FIELD("New WorkPlan Dimension 1 Code")));
            CaptionClass = '1,2,3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "New Dimension Value Name 4"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(4),
                                                               Code = FIELD("New WorkPlan Dimension 2 Code")));
            CaptionClass = '1,2,4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "New Dimension Value Name 5"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(5),
                                                               Code = FIELD("New Dimension Value Name 3")));
            CaptionClass = '1,2,5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Budget Revision Type"; Enum "Budget Revision Type")
        {
            Caption = 'Budget Revision Type';
        }
        field(50000; "System Id"; Guid) { }


    }

    keys
    {
        key(Key1; "Document Type", "Document No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        WorkPlan: Record "WorkPlan Header";
        BudgetReallocHeader: Record "Budget Realloc. Header";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRetrieved: Boolean;
        Text001: Label '1,5,,WorkPlan Dimension 1 Code';
        Text002: Label '1,5,,WorkPlan Dimension 2 Code';
        Text003: Label '1,5,,WorkPlan Dimension 3 Code';
        Text004: Label '1,5,,WorkPlan Dimension 4 Code';
        Text005: Label '1,5,,WorkPlan Dimension 5 Code';
        Text006: Label '1,5,,WorkPlan Dimension 6 Code';

    trigger OnInsert()
    begin
        Rec."System Id" := System.CreateGuid();

        BudgetReallocHeader.Reset();
        BudgetReallocHeader.SetRange("Document Type", Rec."Document Type");
        BudgetReallocHeader.SetRange("No.", Rec."Document No");
        if BudgetReallocHeader.findFirst() then
            Rec."Budget Revision Type" := BudgetReallocHeader."Budget Revision Type";
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

    procedure ClearFields()
    begin
        Clear("Budget Code");
        Clear("Global Dimension Code 1");
        Clear("Global Dimension Code 2");
        Clear("WorkPlan Dimension 1 Code");
        Clear("WorkPlan Dimension 2 Code");
        Clear("WorkPlan Dimension 3 Code");
        Clear("WorkPlan Dimension 4 Code");
        Clear("Dimension Set ID");
        Clear("Account No");
        Clear("Workplan Entry No.");
        Clear("Activity Description");
        Clear(Amount);
        Clear("New Global Dimension Code 1");
        Clear("New Global Dimension Code 2");
        Clear("New WorkPlan Dimension 1 Code");
        Clear("New WorkPlan Dimension 2 Code");
        Clear("New WorkPlan Dimension 3 Code");
        Clear("New WorkPlan Dimension 4 Code");
        Clear("New G/L Account");
        Clear("Quarter 1 Amount");
        Clear("Quarter 2 Amount");
        Clear("Quarter 3 Amount");
        Clear("Quarter 4 Amount");
        Clear(Month1);
        Clear(Month2);
        Clear(Month3);
        Clear(Month4);
        Clear(Month5);
        Clear(Month6);
        Clear(Month7);
        Clear(Month8);
        Clear(Month9);
        Clear(Month10);
        Clear(Month11);
        Clear(Month12);
        Clear("New Activity Description");
        Clear("Available Amount");
        Clear("New Dimension Set ID");
    end;

    local procedure OnLookupDimCode(DimOption: Option "Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; DefaultValue: Code[20]): Code[20]
    var
        DimValue: Record "Dimension Value";
        DimValueList: Page "Dimension Value List";
    begin
        if DimOption in [DimOption::"Global Dimension 1", DimOption::"Global Dimension 2"] then
            GetGLSetup()
        else
            if WorkPlan."No." <> "Workplan No." then
                WorkPlan.Get("Workplan No.");
        case DimOption of
            DimOption::"Global Dimension 1":
                DimValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
            DimOption::"Global Dimension 2":
                DimValue."Dimension Code" := GLSetup."Global Dimension 2 Code";
            DimOption::"Budget Dimension 1":
                DimValue."Dimension Code" := WorkPlan."WorkPlan Dimension 1 Code";
            DimOption::"Budget Dimension 2":
                DimValue."Dimension Code" := WorkPlan."WorkPlan Dimension 2 Code";
            DimOption::"Budget Dimension 3":
                DimValue."Dimension Code" := WorkPlan."WorkPlan Dimension 3 Code";
            DimOption::"Budget Dimension 4":
                DimValue."Dimension Code" := WorkPlan."WorkPlan Dimension 4 Code";
        end;
        DimValue.SetRange("Dimension Code", DimValue."Dimension Code");
        if DimValue.Get(DimValue."Dimension Code", DefaultValue) then;
        DimValueList.SetTableView(DimValue);
        DimValueList.SetRecord(DimValue);
        DimValueList.LookupMode := true;
        if DimValueList.RunModal() = ACTION::LookupOK then begin
            DimValueList.GetRecord(DimValue);
            exit(DimValue.Code);
        end;
        exit(DefaultValue);
    end;

    local procedure ValidateDimValue(DimCode: Code[20]; DimValueCode: Code[20])
    begin
        if not DimMgt.CheckDimValue(DimCode, DimValueCode) then
            Error(DimMgt.GetDimErr());
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRetrieved then begin
            GLSetup.Get();
            GLSetupRetrieved := true;
        end;
    end;

    procedure UpdateDimSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20])
    begin
        if DimCode = '' then
            exit;
        if TempDimSetEntry.Get("New Dimension Set ID", DimCode) then
            TempDimSetEntry.Delete();
        if DimValueCode = '' then
            DimVal.Init()
        else
            DimVal.Get(DimCode, DimValueCode);
        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Set ID" := "New Dimension Set ID";
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry."Dimension Value Code" := DimValueCode;
        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
        TempDimSetEntry.Insert();
    end;

    local procedure UpdateDimensionSetId(DimCode: Code[20]; DimValueCode: Code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, "New Dimension Set ID");
        UpdateDimSet(TempDimSetEntry, DimCode, DimValueCode);
        //OnAfterUpdateDimensionSetId(TempDimSetEntry, Rec, xRec);
        "New Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    procedure GetCaptionClass(BudgetDimType: Integer; WorkplanNo: Code[20]): Text[250]
    begin
        if WorkplanNo <> '' then begin
            WorkPlan.SetFilter("No.", WorkplanNo);
            if not WorkPlan.findFirst() then
                Clear(WorkPlan);
        end;
        case BudgetDimType of
            1:
                begin
                    if WorkPlan."WorkPlan Dimension 1 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 1 Code");

                    exit(Text001);
                end;
            2:
                begin
                    if WorkPlan."WorkPlan Dimension 2 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 2 Code");

                    exit(Text002);
                end;
            3:
                begin
                    if WorkPlan."WorkPlan Dimension 3 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 3 Code");

                    exit(Text003);
                end;
            4:
                begin
                    if WorkPlan."WorkPlan Dimension 4 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 4 Code");

                    exit(Text004);
                end;
            5:
                begin
                    if WorkPlan."WorkPlan Dimension 5 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 5 Code");

                    exit(Text005);
                end;
            6:
                begin
                    if WorkPlan."WorkPlan Dimension 6 Code" <> '' then
                        exit('1,5,' + WorkPlan."WorkPlan Dimension 6 Code");

                    exit(Text006);
                end;
        end;
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Entry No"));
    end;

    procedure CheckMandatoryDimensions()
    begin
        if Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Reallocation" then begin
            TestField("New Workplan No.");
            TestField("New G/L Account");
            TestField("New Global Dimension Code 1");
            TestField("New Global Dimension Code 2");
            TestField("New WorkPlan Dimension 1 Code");
            TestField("New WorkPlan Dimension 2 Code");
        end;
        // TestField("New WorkPlan Dimension 1 Code");
        // TestField("New WorkPlan Dimension 4 Code");
        // TestField("New WorkPlan Dimension 5 Code");
        // TestField("New WorkPlan Dimension 6 Code");
        //TestField("New WorkPlan Dimension 7 Code");
        //TestField("New WorkPlan Dimension 8 Code");
        validate(Amount);
    end;

    procedure TestBudgetReallocHeaderStatusOpen()
    var
        lvBudgetReallocHeader: Record "Budget Realloc. Header";
    begin
        lvBudgetReallocHeader.SetRange("Document Type", Rec."Document Type");
        lvBudgetReallocHeader.SetRange("No.", Rec."Document No");
        if lvBudgetReallocHeader.FindFirst() then
            lvBudgetReallocHeader.TestField(Status, lvBudgetReallocHeader.Status::Open);

    end;

}