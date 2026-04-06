table 50014 "WorkPlan Line"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Budget Entries";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No.";
            Editable = false;
        }
        field(3; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Item,"Fixed Asset";
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), "Dimension Value Type" = filter(Standard));

            trigger OnValidate()
            begin
                GetGLSetup();
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code");
            end;
        }
        field(6; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), "Dimension Value Type" = filter(Standard));

            trigger OnValidate()
            begin
                GetGLSetup();
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code");
            end;
        }
        field(7; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Add to Work Plan" = const(true))
            ELSE
            IF ("Account Type" = CONST(Item)) Item
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            trigger OnValidate()
            var
                lvGLAccount: Record "G/L Account";
            begin
                if lvGLAccount.Get("Account No") then
                    "Account Name" := lvGLAccount.Name;
            end;

        }
        field(8; "Charge Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "WorkPlan Dimension 1 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = '1,2,3';
            trigger OnLookup()
            begin
                "WorkPlan Dimension 1 Code" := OnLookupDimCode(2, "WorkPlan Dimension 1 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 1 Code", "WorkPlan Dimension 1 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 1 Code", "WorkPlan Dimension 1 Code");
            end;

            trigger OnValidate()
            begin
                if "WorkPlan Dimension 1 Code" = xRec."WorkPlan Dimension 1 Code" then
                    exit;
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 1 Code", "WorkPlan Dimension 1 Code");
                UpdateDimensionSetId(workPlan."WorkPlan Dimension 1 Code", "WorkPlan Dimension 1 Code");
            end;
        }
        field(10; "WorkPlan Dimension 2 Code"; Code[20])
        {
            AccessByPermission = TableData Dimension = R;
            CaptionClass = '1,2,4';
            trigger OnLookup()
            begin
                "WorkPlan Dimension 2 Code" := OnLookupDimCode(3, "WorkPlan Dimension 2 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 2 Code", "WorkPlan Dimension 2 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 2 Code", "WorkPlan Dimension 2 Code");
            end;

            trigger OnValidate()
            begin
                if "WorkPlan Dimension 2 Code" = xRec."WorkPlan Dimension 2 Code" then
                    exit;
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 2 Code", "WorkPlan Dimension 2 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 2 Code", "WorkPlan Dimension 2 Code");
            end;
        }

        field(11; "WorkPlan Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = '1,2,5';
            trigger OnLookup()
            begin
                "WorkPlan Dimension 3 Code" := OnLookupDimCode(4, "WorkPlan Dimension 3 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 3 Code", "WorkPlan Dimension 3 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 3 Code", "WorkPlan Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 3 Code", "WorkPlan Dimension 3 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 3 Code", "WorkPlan Dimension 3 Code");
            end;
        }
        field(12; "WorkPlan Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = '1,2,6';

            trigger OnLookup()
            begin
                "WorkPlan Dimension 4 Code" := OnLookupDimCode(5, "WorkPlan Dimension 4 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 4 Code", "WorkPlan Dimension 4 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 4 Code", "WorkPlan Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 4 Code", "WorkPlan Dimension 4 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 4 Code", "WorkPlan Dimension 4 Code");
            end;
        }
        field(30; "WorkPlan Dimension 5 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = '1,2,7';

            trigger OnLookup()
            begin
                "WorkPlan Dimension 5 Code" := OnLookupDimCode(6, "WorkPlan Dimension 5 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 5 Code", "WorkPlan Dimension 5 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 5 Code", "WorkPlan Dimension 5 Code");
            end;

            trigger OnValidate()
            begin
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 5 Code", "WorkPlan Dimension 5 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 5 Code", "WorkPlan Dimension 5 Code");
            end;
        }
        field(31; "WorkPlan Dimension 6 Code"; Code[20])
        {
            AccessByPermission = TableData "Dimension Combination" = R;
            CaptionClass = '1,2,8';
            trigger OnLookup()
            begin
                "WorkPlan Dimension 6 Code" := OnLookupDimCode(7, "WorkPlan Dimension 6 Code");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 6 Code", "WorkPlan Dimension 6 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 6 Code", "WorkPlan Dimension 6 Code");
            end;

            trigger OnValidate()
            begin
                if WorkPlan."No." <> "WorkPlan No" then
                    WorkPlan.Get("WorkPlan No");
                ValidateDimValue(WorkPlan."WorkPlan Dimension 6 Code", "WorkPlan Dimension 6 Code");
                UpdateDimensionSetId(WorkPlan."WorkPlan Dimension 6 Code", "WorkPlan Dimension 6 Code");
            end;
        }
        field(13; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Output; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Indicator; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Targets; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Input; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Budget Activity Type"; Enum "Budget Activity Type")
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Quarter 1 Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount", "Quarter 1 Amount" + "Quarter 2 Amount" + "Quarter 3 Amount" + "Quarter 4 Amount");
            end;
        }

        field(20; "Quarter 2 Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount", "Quarter 1 Amount" + "Quarter 2 Amount" + "Quarter 3 Amount" + "Quarter 4 Amount");
            end;
        }
        field(21; "Quarter 3 Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            trigger OnValidate()
            var
            begin
                Validate("Annual Amount", "Quarter 1 Amount" + "Quarter 2 Amount" + "Quarter 3 Amount" + "Quarter 4 Amount");
            end;
        }
        field(22; "Quarter 4 Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            trigger OnValidate()
            var
            begin
                Validate("Annual Amount", "Quarter 1 Amount" + "Quarter 2 Amount" + "Quarter 3 Amount" + "Quarter 4 Amount");
            end;
        }
        field(23; "Annual Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Activity Frequency"; Option)
        {
            OptionMembers = " ",Recurrent,"Non Recurrent";
        }
        field(25; Actuals; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Account No"), "Work Plan" = field("WorkPlan No"), "Budget Name" = field("Budget Code"), "Work Plan Entry No." = field("Entry No"), "Document Type" = filter(" " | Payment | Refund), "System-Created Entry" = filter(true)));
            Caption = 'Actual Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(26; Variance; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(27; "Procurement Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Micro,Macro;
        }
        field(28; "Method of Procurement"; Enum "Procurement Method")
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Planned Proc. Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Planned Procurement Date';
        }
        field(32; "Procurement Expense Type"; Option)
        {
            OptionMembers = " ",CAPEX,OPEX;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                    Error(DimMgt.GetDimCombErr);
            end;
        }
        field(40; "Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Remarks"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Comment';
        }

        field(42; "Dimension Value Name 1"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            // Caption = 'Cost Center Name';
            CaptionClass = '1,1,1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Dimension Value Name 2"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(2),
                                                               Code = FIELD("Global Dimension 2 Code")));
            CaptionClass = '1,1,2';
            Editable = false;
            FieldClass = FlowField;
        }

        field(44; "Dimension Value Name 3"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(3),
                                                               Code = FIELD("WorkPlan Dimension 1 Code")));
            CaptionClass = '1,2,3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "Dimension Value Name 4"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(4),
                                                               Code = FIELD("WorkPlan Dimension 2 Code")));
            CaptionClass = '1,2,4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; "Dimension Value Name 5"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = const(5),
                                                               Code = FIELD("WorkPlan Dimension 3 Code")));
            CaptionClass = '1,2,5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; "Reallocated Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Budget Realloc. Lines Archive".Amount where("Workplan Entry No." = field("Entry No"), "Workplan No." = field("WorkPlan No"), "Fully Reallocated" = const(true)));
            Editable = false;
        }
        field(52; "Reallocated"; Boolean)
        {
            Editable = false;
        }

        field(54; "Actual Invoices"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purch. Inv. Line"."Amount Inc. VAT (LCY)" WHERE("Budget Control A/C" = FIELD("Account No"), "Work Plan" = field("WorkPlan No"), "Budget Name" = field("Budget Code"), "Work Plan Entry No." = field("Entry No"), "Posting Date" = field("Date Filter")));
            Caption = 'Actual Invoice Expenditure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstand. Amt. Not Invd.(LCY)" WHERE("Document Type" = filter(Order | Invoice), "Budget Control A/C" = FIELD("Account No"),
                                                    "Work Plan" = field("WorkPlan No"),
                                                    "Work Plan Entry No." = field("Entry No"),
                                                    "Budget Name" = field("Budget Code"),
                                                    Status = filter(Released | "Pending Approval")));
            Caption = 'Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Unconfirmed Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstand. Amt. Not Invd.(LCY)" WHERE("Document Type" = filter(Order | Invoice), "Budget Control A/C" = FIELD("Account No"),
                                                    "Work Plan" = field("WorkPlan No"),
                                                    "Work Plan Entry No." = field("Entry No"),
                                                    "Budget Name" = field("Budget Code"),
                                                    Status = filter(Open)));
            Caption = 'Unconfirmed Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(62; "Pre-Encumbrances"; Decimal)
        // {
        //     AutoFormatType = 1;
        // CalcFormula = Sum("Purchase Requisition Line"."Outstanding Amount (LCY)" WHERE("Document Type" = filter("Purchase Requisition"), "Charge Account" = FIELD("Account No"),
        //                                             "WorkPlan No" = field("WorkPlan No"),
        //                                             "WorkPlan Entry No" = field("Entry No"),
        //                                             "Budget Code" = field("Budget Code"),
        //                                             Status = filter(Approved | "Pending Approval")));
        //     Caption = 'Purchase Requisitions';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(64; "Unconfirmed Pre-Encumbrances"; Decimal)
        // {
        //     AutoFormatType = 1;
        //     Caption = 'Unconfirmed Pre-Encumbrances';
        //     Editable = false;
        //     FieldClass = FlowField;
        // CalcFormula = Sum("Purchase Requisition Line"."Outstanding Amount (LCY)" WHERE("Document Type" = filter("Purchase Requisition"), "Charge Account" = FIELD("Account No"),
        //                                             "WorkPlan No" = field("WorkPlan No"),
        //                                             "WorkPlan Entry No" = field("Entry No"),
        //                                             "Budget Code" = field("Budget Code"),
        //                                             Status = filter(Open)));
        //}
        field(66; "Payment Req. Pre-Encumbrances"; Decimal)
        {
            CalcFormula = Sum("Payment Requisition Line"."Outstanding Amount (LCY)" WHERE("Account No" = FIELD("Account No"),
                                                        "WorkPlan No" = field("WorkPlan No"),
                                                        "WorkPlan Entry No" = field("Entry No"),
                                                        "Budget Code" = field("Budget Code"),
                                                        Status = filter(Approved | "Pending Approval")));
            Caption = 'Payment Requisitions';
            Editable = false;
            FieldClass = FlowField;
        }

        field(67; Advances; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Payment Req Line Archive"."Acc. Remaining Amount (LCY)" where("Document Type" = filter("Payment Requisition"), "Account No" = FIELD("Account No"),
                                                        "WorkPlan No" = field("WorkPlan No"),
                                                        "WorkPlan Entry No" = field("Entry No"),
                                                        "Budget Code" = field("Budget Code"),
                                                        "Payee Type" = filter(Imprest), Accounted = const(false)));
            Caption = 'Advances Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(68; "Credit Memos"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purch. Cr. Memo Line"."Amount Inc. VAT (LCY)" where("Budget Control A/C" = FIELD("Account No"),
                                                        "Work Plan" = field("WorkPlan No"),
                                                        "Work Plan Entry No." = field("Entry No"),
                                                        "Budget Name" = field("Budget Code"), "Posting Date" = field("Date Filter")));
            Caption = 'Posted Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; Accountabilities; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Accountability Line"."Outstanding Amount (LCY)" where("Document Type" = filter(Accountability), "Account No" = FIELD("Account No"),
                                                        "WorkPlan No" = field("WorkPlan No"),
                                                        "WorkPlan Entry No" = field("Entry No"),
                                                        "Budget Code" = field("Budget Code"),
                                                        "Payee Type" = filter(Imprest)));
            //CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = const('2341'), "Work Plan" = field("WorkPlan No"), "Budget Name" = field("Budget Code"), "Work Plan Entry No." = field("Entry No")));
            Caption = 'Accountabilities Pending Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Journal Actuals"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Account No"), "Work Plan" = field("WorkPlan No"), "Budget Name" = field("Budget Code"), "Work Plan Entry No." = field("Entry No"), "System-Created Entry" = filter(false), "Posting Date" = field("Date Filter")));
        }
        field(72; "General Journals"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Gen. Journal Line"."Amount (LCY)" where("Budget Control A/C" = field("Account No"), "Work Plan" = field("WorkPlan No"), "Work Plan Entry No." = field("Entry No"), "Budget Name" = field("Budget Code"), "Posting Date" = field("Date Filter")));
        }
        field(74; "Planned Proc. Amount"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate("Planned Proc. Amt (LCY)", UpdateAmtLCY(Rec));
            end;
        }
        field(75; "Planned Proc. Amt (LCY)"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                if "Planned Proc. Amt (LCY)" > "Annual Amount" then
                    Error('The estimated cost cannot be more than the budgeted amount.');
            end;
        }
        field(76; Quantity; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate("Planned Proc. Amount", (Quantity * "Unit Cost"));
            end;
        }
        field(78; "Unit Cost"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                Validate("Planned Proc. Amount", (Quantity * "Unit Cost"));
            end;
        }
        field(80; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
            trigger OnValidate()
            var
            begin
                if "Currency Code" <> xRec."Currency Code" then
                    UpdateCurrencyFactor()
                else
                    if "Currency Code" <> '' then begin
                        UpdateCurrencyFactor();
                        if "Currency Factor" <> xRec."Currency Factor" then
                            if GuiAllowed then
                                if Confirm('Do you want to update the exchange rate?') then
                                    Validate("Currency Factor")
                                else
                                    Rec.Validate("Currency Factor", xRec."Currency Factor");
                    end;
            end;

        }
        field(82; "Currency Factor"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    Validate("Planned Proc. Amount", (Quantity * "Unit Cost"));
            end;
        }
        field(84; "Procurement Category"; Enum "Procurement Category")
        {
        }
        field(86; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(88; "Proc. Initiation Date"; Date)
        {
        }
        field(90; "Quoter 1"; Boolean)
        {

        }
        field(91; "Quoter 2"; Boolean)
        {

        }
        field(92; "Quoter 3"; Boolean)
        {

        }
        field(93; "Quoter 4"; Boolean)
        {

        }

        field(94; Month1; Decimal)
        {
            Caption = 'Month 1';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY1", UpdateAmountLCY(Month1));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(95; Month2; Decimal)
        {
            Caption = 'Month 2';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY2", UpdateAmountLCY(Month2));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(96; Month3; Decimal)
        {
            Caption = 'Month 3';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY3", UpdateAmountLCY(Month3));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(97; Month4; Decimal)
        {
            Caption = 'Month 4';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY4", UpdateAmountLCY(Month4));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(98; Month5; Decimal)
        {
            Caption = 'Month 5';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY5", UpdateAmountLCY(Month5));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(100; Month6; Decimal)
        {
            Caption = 'Month 6';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY6", UpdateAmountLCY(Month6));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(101; Month7; Decimal)
        {
            Caption = 'Month 7';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY7", UpdateAmountLCY(Month7));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(102; Month8; Decimal)
        {
            Caption = 'Month 8';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY8", UpdateAmountLCY(Month8));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(103; Month9; Decimal)
        {
            Caption = 'Month 9';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY9", UpdateAmountLCY(Month9));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(104; Month10; Decimal)
        {
            Caption = 'Month 10';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY10", UpdateAmountLCY(Month10));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(105; Month11; Decimal)
        {
            Caption = 'Month 11';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY11", UpdateAmountLCY(Month11));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(106; Month12; Decimal)
        {
            Caption = 'Month 12';
            trigger OnValidate()
            var
            begin
                Validate("MonthLCY12", UpdateAmountLCY(Month12));
                Validate("Annual Amount", Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12);
            end;
        }
        field(108; "Activity Description Details"; Text[250])
        {
            Caption = 'Activity Description Details';
        }
        field(109; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(124; MonthLCY1; Decimal)
        {
            Caption = 'MonthLCY 1';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(125; MonthLCY2; Decimal)
        {
            Caption = 'MonthLCY 2';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(126; MonthLCY3; Decimal)
        {
            Caption = 'MonthLCY 3';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(127; MonthLCY4; Decimal)
        {
            Caption = 'MonthLCY 4';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(128; MonthLCY5; Decimal)
        {
            Caption = 'MonthLCY 5';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(129; MonthLCY6; Decimal)
        {
            Caption = 'MonthLCY 6';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(200; MonthLCY7; Decimal)
        {
            Caption = 'MonthLCY 7';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(210; MonthLCY8; Decimal)
        {
            Caption = 'MonthLCY 8';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(211; MonthLCY9; Decimal)
        {
            Caption = 'MonthLCY 9';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(212; MonthLCY10; Decimal)
        {
            Caption = 'MonthLCY 10';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(213; MonthLCY11; Decimal)
        {
            Caption = 'MonthLCY 11';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(214; MonthLCY12; Decimal)
        {
            Caption = 'MonthLCY 12';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate("Annual Amount LCY", MonthLCY1 + MonthLCY2 + MonthLCY3 + MonthLCY4 + MonthLCY5 + MonthLCY6 + MonthLCY7 + MonthLCY8 + MonthLCY9 + MonthLCY10 + MonthLCY11 + MonthLCY12);
            end;
        }
        field(215; "Annual Amount LCY"; Decimal)
        {
            Editable = false;
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "WorkPlan No", "Entry No")
        {
            Clustered = true;
        }
    }

    local procedure OnLookupDimCode(DimOption: Option "Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; DefaultValue: Code[20]): Code[20]
    var
        DimValue: Record "Dimension Value";
        DimValueList: Page "Dimension Value List";
    begin
        if DimOption in [DimOption::"Global Dimension 1", DimOption::"Global Dimension 2"] then
            GetGLSetup
        else
            if WorkPlan."No." <> "WorkPlan No" then
                WorkPlan.Get("WorkPlan No");
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
        DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);//Filtering only to standard Dims
        if DimValue.Get(DimValue."Dimension Code", DefaultValue) then;
        DimValueList.SetTableView(DimValue);
        DimValueList.SetRecord(DimValue);
        DimValueList.LookupMode := true;
        if DimValueList.RunModal = ACTION::LookupOK then begin
            DimValueList.GetRecord(DimValue);
            exit(DimValue.Code);
        end;
        exit(DefaultValue);
    end;

    procedure GetCaptionClass(BudgetDimType: Integer): Text[250]
    begin
        if GetFilter("WorkPlan No") <> '' then begin
            WorkPlan.SetFilter("No.", GetFilter("WorkPlan No"));
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

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    var
        DimSetEntry: Record "Dimension Set Entry";
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2 %3', "WorkPlan No", "Account No", "Entry No"));

        if OldDimSetID = "Dimension Set ID" then
            exit;

        GetGLSetup;
        WorkPlan.Get("WorkPlan No");

        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        "WorkPlan Dimension 1 Code" := '';
        "WorkPlan Dimension 2 Code" := '';
        "WorkPlan Dimension 3 Code" := '';
        "WorkPlan Dimension 4 Code" := '';
        "WorkPlan Dimension 5 Code" := '';
        "WorkPlan Dimension 6 Code" := '';

        if DimSetEntry.Get("Dimension Set ID", GLSetup."Global Dimension 1 Code") then
            "Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", GLSetup."Global Dimension 2 Code") then
            "Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 1 Code") then
            "WorkPlan Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 2 Code") then
            "WorkPlan Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 3 Code") then
            "WorkPlan Dimension 3 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 4 Code") then
            "WorkPlan Dimension 4 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 5 Code") then
            "WorkPlan Dimension 5 Code" := DimSetEntry."Dimension Value Code";
        if DimSetEntry.Get("Dimension Set ID", WorkPlan."WorkPlan Dimension 6 Code") then
            "WorkPlan Dimension 6 Code" := DimSetEntry."Dimension Value Code";

    end;

    procedure ViewDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "WorkPlan No"));
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
        if TempDimSetEntry.Get("Dimension Set ID", DimCode) then
            TempDimSetEntry.Delete();
        if DimValueCode = '' then
            DimVal.Init
        else
            DimVal.Get(DimCode, DimValueCode);
        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry."Dimension Value Code" := DimValueCode;
        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
        TempDimSetEntry.Insert();
    end;

    local procedure UpdateDimensionSetId(DimCode: Code[20]; DimValueCode: Code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
        UpdateDimSet(TempDimSetEntry, DimCode, DimValueCode);
        //OnAfterUpdateDimensionSetId(TempDimSetEntry, Rec, xRec);
        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    procedure CheckBudget(WorkPlan: Code[20]; WorkPlanEntry: Integer; BudgetCode: Code[20]; LineAmount: Decimal; ExistingLineAmt: Decimal)
    var
        Text01: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual & Commitments = %4';
        Text02: Label 'There is no budget that was allocated for this line';
        WorkPlanLine: Record "WorkPlan Line";
        BudgetControlSetup: Record "Budget Control Setup";
        lvTotalDeductions: Decimal;
        lvTotalEntitlement: Decimal;
        lvAvailableBudget: Decimal;
    begin
        BudgetControlSetup.Get();
        if BudgetControlSetup."Activate Budget Control" then begin
            WorkPlanLine.SetRange("WorkPlan No", WorkPlan);
            WorkPlanLine.SetRange("Entry No", WorkPlanEntry);
            if WorkPlanLine.FindFirst() then begin
                WorkPlanLine.CalcFields("Annual Amount", Actuals, "Journal Actuals", "Actual Invoices", "Credit Memos", "Payment Req. Pre-Encumbrances", "Unconfirmed Encumbrances", Advances);

                //Sums to Add ==========================================
                if BudgetControlSetup."Original Budget" then
                    lvTotalEntitlement += WorkPlanLine."Annual Amount";
                //======================================================

                //Sums to Subtract =====================================
                if BudgetControlSetup."Actual Expenditure" then
                    lvTotalDeductions := WorkPlanLine.Actuals + WorkPlanLine."Actual Invoices" + WorkPlanLine."Journal Actuals";
                if BudgetControlSetup.Encumbrances then
                    lvTotalDeductions += WorkPlanLine.Advances + WorkPlanLine."Credit Memos";
                //lvTotalDeductions += WorkPlanLine.Encumbrances + WorkPlanLine.Advances + WorkPlanLine."Credit Memos";
                // if BudgetControlSetup."Unconfirmed Encumbrances" then
                //     lvTotalDeductions += WorkPlanLine."Unconfirmed Encumbrances";
                if BudgetControlSetup."Pre-encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Payment Req. Pre-Encumbrances";
                //lvTotalDeductions += WorkPlanLine."Pre-Encumbrances" + WorkPlanLine."Payment Req. Pre-Encumbrances";
                // if BudgetControlSetup."Unconfirmed Pre-encumbrances" then
                //     lvTotalDeductions += WorkPlanLine."Unconfirmed Pre-Encumbrances";
                //======================================================

                lvAvailableBudget := lvTotalEntitlement - lvTotalDeductions - ExistingLineAmt;
                if LineAmount > lvAvailableBudget then
                    Error(Text01, WorkPlanLine."Account No", LineAmount, lvTotalEntitlement, lvTotalDeductions);

            end
            else
                Error(Text02);
        end;

    end;

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
        gn: Page "General Journal";

    trigger Oninsert()
    var
        WorkPlanHeader: Record "WorkPlan Header";
    begin
        Rec."System Id" := System.CreateGuid();
        if WorkPlanHeader.Get("WorkPlan No") then begin
            "Budget Code" := WorkPlanHeader."Budget Code";
            Validate("Global Dimension 1 Code", WorkPlanHeader."Shortcut Dimension 1 Code");
            Validate("Global Dimension 2 Code", WorkPlanHeader."Shortcut Dimension 2 Code");
        end;
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

    procedure UpdateAmtLCY(var lvWorkplanLine: Record "WorkPlan Line"): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
        lvCurrency: Record Currency;
    begin
        if lvWorkplanLine."Currency Code" <> '' then begin
            lvCurrency.get(lvWorkplanLine."Currency Code");
            exit(Round(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  Today, lvWorkplanLine."Currency Code",
                                  lvWorkplanLine."Planned Proc. Amount", lvWorkplanLine."Currency Factor"),
                                lvCurrency."Amount Rounding Precision"))
        end else
            exit(lvWorkplanLine."Planned Proc. Amount")
    end;

    procedure UpdateAmountLCY(var Amount: Decimal): Decimal
    var
        lvWorkplanHeader: Record "WorkPlan Header";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchaseLine: Record "Purchase Line";
        lvCurrency: Record Currency;
    begin
        lvWorkplanHeader.SetRange("No.", Rec."WorkPlan No");
        if lvWorkplanHeader.FindSet() then begin
            if Rec."Currency Code" <> '' then
                exit(Round(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              lvWorkplanHeader."Date Created", "Currency Code",
                              Amount, Rec."Currency Factor"),
                            lvCurrency."Amount Rounding Precision"))
            else
                exit(Amount)
        end;
    end;

    procedure UpdateCurrencyFactor()
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        //  lvPurchReqLine: Record "Purchase Requisition Line";
        Updated: Boolean;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if "Currency Code" <> '' then begin
            "Currency Factor" := CurrExchRate.ExchangeRate(Today, "Currency Code");
        end else begin
            "Currency Factor" := 0;
        end;
        Validate("Currency Factor");
    end;

}