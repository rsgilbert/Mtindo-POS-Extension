table 50023 "Budget Realloc. Lines Archive"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Budget Realloc. Arch. Subform";

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";

        }
        field(2; "Document No"; Code[20])
        {

        }
        field(3; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Workplan No."; Code[20])
        {
            TableRelation = "WorkPlan Header" where(Blocked = filter(false), "Transferred To Budget" = filter(true));

            trigger Onvalidate()
            var
                lvWorkplanHeader: Record "WorkPlan Header";
            begin
                lvWorkplanHeader.Reset();
                lvWorkplanHeader.SetRange("No.", "Workplan No.");
                if lvWorkplanHeader.FindFirst() then begin
                    "Budget Code" := lvWorkplanHeader."Budget Code";
                    "Global Dimension Code 1" := lvWorkplanHeader."Shortcut Dimension 1 Code";
                    "Global Dimension Code 2" := lvWorkplanHeader."Shortcut Dimension 2 Code";
                end;
            end;
        }

        field(5; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "G/L Account" where("Account Type" = CONST(Posting), Blocked = CONST(false), "Add to Work Plan" = const(true));

        }
        field(6; "Workplan Entry No."; Integer)
        {
            trigger OnValidate()
            var
                myInt: Integer;
                lvWorkplanLine: Record "WorkPlan Line";
                BudgetControlSetup: Record "Budget Control Setup";
            begin
                lvWorkplanLine.Reset();
                lvWorkplanLine.SetRange("WorkPlan No", "Workplan No.");
                lvWorkplanLine.SetRange("Budget Code", "Budget Code");
                lvWorkplanLine.SetRange("Account No", "Account No");
                lvWorkplanLine.SetRange("Entry No", "Workplan Entry No.");
                if lvWorkplanLine.FindFirst() then begin
                    "Available Amount" := BudgetControlSetup.CheckBudget(lvWorkplanLine."WorkPlan No", lvWorkplanLine."Entry No", lvWorkplanLine."Budget Code", 0, 0);
                    "Activity Description" := lvWorkplanLine.Description;
                    "WorkPlan Dimension 1 Code" := lvWorkplanLine."WorkPlan Dimension 1 Code";
                    "WorkPlan Dimension 2 Code" := lvWorkplanLine."WorkPlan Dimension 2 Code";
                    "WorkPlan Dimension 3 Code" := lvWorkplanLine."WorkPlan Dimension 3 Code";
                    "WorkPlan Dimension 4 Code" := lvWorkplanLine."WorkPlan Dimension 4 Code";
                    "WorkPlan Dimension 5 Code" := lvWorkplanLine."WorkPlan Dimension 5 Code";
                    "WorkPlan Dimension 6 Code" := lvWorkplanLine."WorkPlan Dimension 6 Code";
                    "Dimension Set ID" := lvWorkplanLine."Dimension Set ID";
                end;

            end;

            trigger Onlookup()
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
                    WorkPlanEntry.lookupMode(true);
                    if WorkPlanEntry.RunModal() = Action::lookupOK then begin
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
            CaptionClass = GetCaptionClass(1);
        }
        field(10; "Global Dimension Code 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1));
        }
        field(11; "Global Dimension Code 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));
        }
        field(12; "WorkPlan Dimension 2 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(2);
        }

        field(13; "WorkPlan Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(3);
        }
        field(14; "WorkPlan Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(4);
            Caption = 'WorkPlan Dimension 4 Code';
        }
        field(15; "WorkPlan Dimension 5 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(5);
            Caption = 'WorkPlan Dimension 5 Code';
        }
        field(16; "WorkPlan Dimension 6 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = GetCaptionClass(6);
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

            trigger OnValidate()
            var
                myInt: Integer;
                lvWorkplanHeader: Record "WorkPlan Header";
            begin
                lvWorkplanHeader.Reset();
                lvWorkplanHeader.SetRange("No.", "New Workplan No.");
                if lvWorkplanHeader.FindFirst() then begin
                    Validate("New Global Dimension Code 1", lvWorkplanHeader."Shortcut Dimension 1 Code");
                    Validate("New Global Dimension Code 2", lvWorkplanHeader."Shortcut Dimension 2 Code");
                end;
            end;
        }
        field(19; "New G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "G/L Account" where("Account Type" = CONST(Posting), Blocked = CONST(false), "Add to Work Plan" = const(true));
        }
        field(20; Amount; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Amount > "Available Amount" then
                    Error('You cannot reallocate more than the available amount');
            end;
        }
        field(21; "New Global Dimension Code 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                if "New Global Dimension Code 1" = xRec."New Global Dimension Code 1" then
                    exit;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
            end;

            trigger Onlookup()
            begin
                "New Global Dimension Code 1" := OnlookupDimCode(0, "New Global Dimension Code 1");
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "New Global Dimension Code 1");
            end;
        }
        field(22; "New Global Dimension Code 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                if "New Global Dimension Code 2" = xRec."New Global Dimension Code 2" then
                    exit;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
            end;

            trigger Onlookup()
            begin
                "New Global Dimension Code 2" := OnlookupDimCode(1, "New Global Dimension Code 2");
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "New Global Dimension Code 2");
            end;
        }
        field(23; "New WorkPlan Dimension 1 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = GetCaptionClass(1);

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 1 Code" := OnlookupDimCode(2, "New WorkPlan Dimension 1 Code");
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
            CaptionClass = GetCaptionClass(2);
            Caption = 'WorkPlan Dimension 4 Code';

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 2 Code" := OnlookupDimCode(3, "New WorkPlan Dimension 2 Code");
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
            CaptionClass = GetCaptionClass(3);

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 3 Code" := OnlookupDimCode(4, "New WorkPlan Dimension 3 Code");
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
            CaptionClass = GetCaptionClass(4);
            Caption = 'WorkPlan Dimension 4 Code';

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 4 Code" := OnlookupDimCode(5, "New WorkPlan Dimension 4 Code");
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
            CaptionClass = GetCaptionClass(5);
            Caption = 'WorkPlan Dimension 5 Code';

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 5 Code" := OnlookupDimCode(6, "New WorkPlan Dimension 5 Code");
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
            CaptionClass = GetCaptionClass(6);
            Caption = 'WorkPlan Dimension 6 Code';

            trigger Onlookup()
            begin
                "New WorkPlan Dimension 6 Code" := OnlookupDimCode(7, "New WorkPlan Dimension 6 Code");
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
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                validate(Amount, Amount + "Quarter 1 Amount");
            end;
        }
        field(40; "Quarter 2 Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                validate(Amount, Amount + "Quarter 2 Amount");
            end;
        }
        field(42; "Quarter 3 Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                validate(Amount, Amount + "Quarter 3 Amount");
            end;
        }
        field(44; "Quarter 4 Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                validate(Amount, Amount + "Quarter 4 Amount");
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
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(52; Month2; Decimal)
        {
            Caption = 'Month 2';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(53; Month3; Decimal)
        {
            Caption = 'Month 3';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(54; Month4; Decimal)
        {
            Caption = 'Month 4';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(55; Month5; Decimal)
        {
            Caption = 'Month 5';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(56; Month6; Decimal)
        {
            Caption = 'Month 6';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(57; Month7; Decimal)
        {
            Caption = 'Month 7';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(58; Month8; Decimal)
        {
            Caption = 'Month 8';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(59; Month9; Decimal)
        {
            Caption = 'Month 9';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(60; Month10; Decimal)
        {
            Caption = 'Month 10';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(61; Month11; Decimal)
        {
            Caption = 'Month 11';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(62; Month12; Decimal)
        {
            Caption = 'Month 12';
            trigger OnValidate()
            begin
                Validate(Amount, (Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12));
            end;
        }
        field(64; "Dimension Value Name 1"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(1),
                                                               Code = field("Global Dimension Code 1")));
            // Caption = 'Cost Center Name';
            CaptionClass = '1,1,1';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(66; "Dimension Value Name 2"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(2),
                                                               Code = field("Global Dimension Code 2")));
            CaptionClass = '1,1,2';
            Editable = false;
            fieldClass = Flowfield;
        }

        field(67; "Dimension Value Name 3"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(3),
                                                               Code = field("WorkPlan Dimension 1 Code")));
            CaptionClass = '1,2,3';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(68; "Dimension Value Name 4"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(4),
                                                               Code = field("WorkPlan Dimension 2 Code")));
            CaptionClass = '1,2,4';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(69; "Dimension Value Name 5"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(5),
                                                               Code = field("WorkPlan Dimension 3 Code")));
            CaptionClass = '1,2,5';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(70; "New Dimension Value Name 1"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(1),
                                                               Code = field("New Global Dimension Code 1")));
            // Caption = 'Cost Center Name';
            CaptionClass = '1,1,1';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(71; "New Dimension Value Name 2"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(2),
                                                               Code = field("New Global Dimension Code 2")));
            CaptionClass = '1,1,2';
            Editable = false;
            fieldClass = Flowfield;
        }

        field(72; "New Dimension Value Name 3"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(3),
                                                               Code = field("New WorkPlan Dimension 1 Code")));
            CaptionClass = '1,2,3';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(73; "New Dimension Value Name 4"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(4),
                                                               Code = field("New WorkPlan Dimension 2 Code")));
            CaptionClass = '1,2,4';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(74; "New Dimension Value Name 5"; Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where("Global Dimension No." = const(5),
                                                               Code = field("New Dimension Value Name 3")));
            CaptionClass = '1,2,5';
            Editable = false;
            fieldClass = Flowfield;
        }
        field(75; "Budget Revision Type"; Enum "Budget Revision Type")
        {
            Caption = 'Budget Revision Type';
        }

        field(80; "Archive No."; Code[20])
        {
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "Document No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        Text001: Label '1,5,,WorkPlan Dimension 1 Code';
        Text002: Label '1,5,,WorkPlan Dimension 2 Code';
        Text003: Label '1,5,,WorkPlan Dimension 3 Code';
        Text004: Label '1,5,,WorkPlan Dimension 4 Code';
        Text005: Label '1,5,,WorkPlan Dimension 5 Code';
        Text006: Label '1,5,,WorkPlan Dimension 6 Code';
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRetrieved: Boolean;
        WorkPlan: Record "WorkPlan Header";
        lv: Record "Purchase Line";
        bg: Record "G/L Budget Entry";

    trigger OnInsert()
    begin
        Rec."System Id" := System.CreateGuid();


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

    local procedure OnlookupDimCode(DimOption: Option "Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; DefaultValue: Code[20]): Code[20]
    var
        DimValue: Record "Dimension Value";
        DimValueList: Page "Dimension Value List";
    begin
        if DimOption in [DimOption::"Global Dimension 1", DimOption::"Global Dimension 2"] then
            GetGLSetup
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
        DimValueList.lookupMode := true;
        if DimValueList.RunModal = ACTION::lookupOK then begin
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
            DimVal.Init
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

    procedure GetCaptionClass(BudgetDimType: Integer): Text[250]
    begin
        if GetFilter("Workplan No.") <> '' then begin
            WorkPlan.SetFilter("No.", GetFilter("Workplan No."));
            if not WorkPlan.FindFirst then
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

}