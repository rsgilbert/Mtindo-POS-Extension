table 50013 "WorkPlan Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Global Dimension 1 Code"; Code[20])
        {

            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }

        field(4; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

        }
        field(5; "WorkPlan Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(6; "WorkPlan Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(7; "WorkPlan Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(8; "WorkPlan Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(24; "WorkPlan Dimension 5 Code"; Code[20])
        {

            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(25; "WorkPlan Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            InitValue = Open;
            Editable = false;
        }
        field(10; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Transferred To Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
        }
        field(15; "Financial Year"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Amount; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("WorkPlan Line"."Annual Amount" WHERE("WorkPlan No" = FIELD("No.")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Approval Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Rejection Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Rejected By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(27; "Shortcut Dimension 1 Code"; Code[20])
        {

            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            var
                workplanLine: Record "WorkPlan Line";
                Txt001: Label 'Are you sure you would like to the change the Dimension?';
            begin
                if (xRec."Shortcut Dimension 1 Code" <> '') AND (xRec."Shortcut Dimension 1 Code" <> Rec."Shortcut Dimension 1 Code") then
                    if not Confirm(Txt001, false) then begin
                        rec."Shortcut Dimension 1 Code" := xRec."Shortcut Dimension 1 Code";
                        exit;
                    end;

                // if "Shortcut Dimension 1 Code" <> '' then begin
                //     lvDimensionValue.Reset();
                //     lvDimensionValue.SetRange("Global Dimension No.", 1);
                //     lvDimensionValue.SetRange(Code, "Shortcut Dimension 1 Code");
                //     if lvDimensionValue.FindFirst() then
                // Validate("Shortcut Dimension 2 Code", lvDimensionValue."Donor Code");
                // end
                // else
                //     Validate("Shortcut Dimension 2 Code", '');
                if CheckForWorkplanLines() then begin
                    workplanLine.SetRange("WorkPlan No", Rec."No.");
                    if workplanLine.FindSet() then
                        repeat
                            workplanLine.Validate("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                            workplanLine.Modify();
                        until workplanLine.Next() = 0;
                    Message('Lines have been updated');
                end;
            end;
        }

        field(28; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            var
                workplanLine: Record "WorkPlan Line";
            begin
                if CheckForWorkplanLines() then begin
                    workplanLine.SetRange("WorkPlan No", Rec."No.");
                    if workplanLine.FindSet() then
                        repeat
                            workplanLine.Validate("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                            workplanLine.Modify();
                        until workplanLine.Next() = 0;
                end;
            end;
        }
        field(30; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
            trigger OnValidate()
            var
                StandardCodesMgt: Codeunit "Standard Codes Mgt.";
            begin
                if not (CurrFieldNo in [0, FieldNo("Date Created")]) or ("Currency Code" <> xRec."Currency Code") then;
                // (Rec);

                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then begin
                    UpdateCurrencyFactor();
                end
                else
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
                                        Rec."Currency Factor" := xRec."Currency Factor";
                        end;
            end;
        }
        field(32; "Currency factor"; Decimal)
        {
            MinValue = 0;
            Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
                lvWorkplanLine: Record "WorkPlan Line";
            begin
                if not WorkPlanLinesExist() then
                    exit;
                if Rec."Currency factor" <> xRec."Currency factor" then begin
                    lvWorkplanLine.SetRange("WorkPlan No", "No.");
                    lvWorkplanLine.SetRange("Budget Code", "Budget Code");
                    if lvWorkplanLine.FindSet() then
                        repeat
                            lvWorkplanLine."Currency Factor" := Rec."Currency factor";
                            lvWorkplanLine.Validate("Month1");
                            lvWorkplanLine.Validate("Month2");
                            lvWorkplanLine.Validate("Month3");
                            lvWorkplanLine.Validate("Month4");
                            lvWorkplanLine.Validate("Month5");
                            lvWorkplanLine.Validate("Month6");
                            lvWorkplanLine.Validate("Month7");
                            lvWorkplanLine.Validate("Month8");
                            lvWorkplanLine.Validate("Month9");
                            lvWorkplanLine.Validate("Month10");
                            lvWorkplanLine.Validate("Month11");
                            lvWorkplanLine.Validate("Month12");
                            lvWorkplanLine.Modify();
                        until lvWorkplanLine.Next() = 0;
                end;
            end;
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        GenReqSetup: Record "Gen. Requisition Setup";
        GenLedSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CurrencyDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        Confirmed: Boolean;
        gvWorkplanLine: Record "WorkPlan Line";
        RecreateWorkplanLinesMsg: Label 'If you change the currency code, the lines will be updated.\\Do you want to continue?', Comment = '%1: FieldCaption';
        RecreateWorkplanLinesCancelErr: Label 'You must delete the existing workplan lines before you can change %1.', Comment = '%1 - Field Name, Sample:You must delete the existing workplan lines before you can change Currency Code.';


    trigger OnInsert()
    begin
        InitInsert();
        Rec."System Id" := System.CreateGuid();
        GenReqSetup.TestField("Work Plan Dimension 1 Code");
        // GenReqSetup.TestField("Work Plan Dimension 2 Code");
        "WorkPlan Dimension 1 Code" := GenReqSetup."Work Plan Dimension 1 Code";
        "WorkPlan Dimension 2 Code" := GenReqSetup."Work Plan Dimension 2 Code";
        "WorkPlan Dimension 3 Code" := GenReqSetup."Work Plan Dimension 3 Code";
        "WorkPlan Dimension 4 Code" := GenReqSetup."Work Plan Dimension 4 Code";
        "WorkPlan Dimension 5 Code" := GenReqSetup."Work Plan Dimension 5 Code";
        "WorkPlan Dimension 6 Code" := GenReqSetup."Work Plan Dimension 6 Code";
        "Created By" := UserId;
        "Date Created" := Today;
    end;

    trigger OnModify()
    var

    begin

    end;

    trigger OnDelete()
    var
        workPlanLine: Record "WorkPlan Line";
    begin
        workPlanLine.SetRange("WorkPlan No", "No.");
        if workPlanLine.FindFirst() then
            workPlanLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure InitInsert()
    var
    begin
        GenLedSetup.Get();
        GenReqSetup.Get();
        if "No." = '' then begin
            GenReqSetup.TestField("Work Plan Nos.");
            Rec."No." := NoSeriesMgt.GetNextNo(GenReqSetup."Work Plan Nos.", Today, true);
        end;
        "Global Dimension 1 Code" := GenLedSetup."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenLedSetup."Shortcut Dimension 2 Code";
    end;

    procedure ArchiveWorkPlan()
    var
        lvworkPlanLine: Record "WorkPlan Line";
        lvWorkPlanHeaderArch: Record "WorkPlan Header Archive";
        lvworkPlanLineArchive: Record "WorkPlan Line Archive";
    begin
        lvWorkPlanHeaderArch.Init();
        lvWorkPlanHeaderArch.TransferFields(Rec);
        lvWorkPlanHeaderArch.InitInsert(lvWorkPlanHeaderArch);
        lvWorkPlanHeaderArch.Insert(true);
        lvworkPlanLine.SetRange("WorkPlan No", "No.");
        if lvworkPlanLine.FindSet() then
            repeat
                lvworkPlanLineArchive.Init();
                lvworkPlanLineArchive.TransferFields(lvworkPlanLine);
                lvworkPlanLineArchive."Archive No" := lvWorkPlanHeaderArch."Archive No";
                lvworkPlanLineArchive.Insert(true);
            until lvworkPlanLine.Next() = 0;
        lvworkPlanLine.Reset();
        lvworkPlanLine.SetRange("WorkPlan No", "No.");
        if lvworkPlanLine.FindFirst() then
            lvworkPlanLine.DeleteAll();
        Rec.Delete();
        message('Work plan has been successfully archived');
    end;

    procedure TransferToBudget()
    var
        lvGLBudget: Record "G/L Budget Name";
        lvBudgetEntry: Record "G/L Budget Entry";
        lvBudgetEntry2: Record "G/L Budget Entry";
        lvWorkPlanLine: Record "WorkPlan Line";
        lvNxtentryNo: Integer;
    begin
        TestField("Transferred To Budget", false);
        if lvGLBudget.Get("Budget Code") then begin

            lvWorkPlanLine.SetRange("WorkPlan No", "No.");
            if lvWorkPlanLine.FindSet() then
                repeat
                    if lvBudgetEntry2.FindLast() then
                        lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                    else
                        lvNxtentryNo := 1;

                    lvBudgetEntry.Init();
                    lvBudgetEntry."Budget Name" := lvWorkPlanLine."Budget Code";
                    lvBudgetEntry."G/L Account No." := lvWorkPlanLine."Account No";
                    lvBudgetEntry.Description := lvWorkPlanLine.Description;
                    lvBudgetEntry.Validate("Global Dimension 1 Code", lvWorkPlanLine."Global Dimension 1 Code");
                    lvBudgetEntry.Validate("Global Dimension 2 Code", lvWorkPlanLine."Global Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 1 Code", lvWorkPlanLine."WorkPlan Dimension 1 Code");
                    lvBudgetEntry.Validate("Budget Dimension 2 Code", lvWorkPlanLine."WorkPlan Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 3 Code", lvWorkPlanLine."WorkPlan Dimension 3 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 4 Code", lvWorkPlanLine."Shortcut Dimension 6 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 5 Code", lvWorkPlanLine."Shortcut Dimension 7 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 6 Code", lvWorkPlanLine."Shortcut Dimension 8 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 7 Code", lvWorkPlanLine."Shortcut Dimension 9 Code");
                    lvBudgetEntry.Validate("Dimension Set ID", lvWorkPlanLine."Dimension Set ID");
                    lvBudgetEntry."Work Plan" := lvWorkPlanLine."WorkPlan No";
                    lvBudgetEntry."Work Plan Entry No." := lvWorkPlanLine."Entry No";
                    //lvBudgetEntry."Budget Category" := lvWorkPlanLine."Budget Category";

                    if lvWorkPlanLine.Month1 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 1;
                        lvBudgetEntry.Validate(Date, lvGLBudget."Budget Start Date");
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month1);
                        lvBudgetEntry.Insert(true);
                    end;

                    if lvWorkPlanLine.Month2 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo; //lvWorkPlanLine."Entry No" + 2;
                        lvBudgetEntry.Validate(Date, CALCDATE('1M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month2);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month3 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 3;
                        lvBudgetEntry.Validate(Date, CALCDATE('2M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month3);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month4 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('3M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month4);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month5 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('4M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month5);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month6 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('5M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month6);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month7 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('6M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month7);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month8 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('7M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month8);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month9 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('8M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month9);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month10 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('9M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month10);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month11 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('10M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month11);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine.Month12 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('11M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month12);
                        lvBudgetEntry.Insert(true);
                    end;
                until lvWorkPlanLine.Next() = 0;
            "Transferred To Budget" := true;
            Modify();
            Message('Work Plan has been successfully transferred to the budget');
        end;
    end;



    procedure TransferToBudget_Copy()
    var
        lvGLBudget: Record "G/L Budget Name";
        lvBudgetEntry: Record "G/L Budget Entry";
        lvBudgetEntry2: Record "G/L Budget Entry";
        lvWorkPlanLine: Record "WorkPlan Line";
        lvNxtentryNo: Integer;
    begin
        TestField("Transferred To Budget", false);
        if lvGLBudget.Get("Budget Code") then begin

            lvWorkPlanLine.SetRange("WorkPlan No", "No.");
            if lvWorkPlanLine.FindSet() then begin
                repeat
                    if lvBudgetEntry2.FindLast() then
                        lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                    else
                        lvNxtentryNo := 1;

                    lvBudgetEntry.Init();
                    lvBudgetEntry."Budget Name" := lvWorkPlanLine."Budget Code";
                    lvBudgetEntry."G/L Account No." := lvWorkPlanLine."Account No";
                    lvBudgetEntry.Description := lvWorkPlanLine.Description;
                    lvBudgetEntry.Validate("Global Dimension 1 Code", lvWorkPlanLine."Global Dimension 1 Code");
                    lvBudgetEntry.Validate("Global Dimension 2 Code", lvWorkPlanLine."Global Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 1 Code", lvWorkPlanLine."WorkPlan Dimension 1 Code");
                    lvBudgetEntry.Validate("Budget Dimension 2 Code", lvWorkPlanLine."WorkPlan Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 3 Code", lvWorkPlanLine."WorkPlan Dimension 3 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 4 Code", lvWorkPlanLine."WorkPlan Dimension 4 Code");
                    lvBudgetEntry.Validate("Dimension Set ID", lvWorkPlanLine."Dimension Set ID");
                    lvBudgetEntry."Work Plan" := lvWorkPlanLine."WorkPlan No";
                    lvBudgetEntry."Work Plan Entry No." := lvWorkPlanLine."Entry No";

                    if lvWorkPlanLine."Quarter 1 Amount" <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 1;
                        lvBudgetEntry.Validate(Date, lvGLBudget."Budget Start Date");
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 1 Amount");
                        lvBudgetEntry.Insert(true);
                    end;

                    if lvWorkPlanLine."Quarter 2 Amount" <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo; //lvWorkPlanLine."Entry No" + 2;
                        lvBudgetEntry.Validate(Date, CALCDATE('1Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 2 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine."Quarter 3 Amount" <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 3;
                        lvBudgetEntry.Validate(Date, CALCDATE('2Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 3 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine."Quarter 4 Amount" <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('3Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 4 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                until lvWorkPlanLine.Next() = 0;
            end;
            "Transferred To Budget" := true;
            Modify();
            Message('Work Plan has been successfully transferred to the budget');
        end;
    end;

    procedure TransferToBudget2()
    var
        lvGLBudget: Record "G/L Budget Name";
        lvBudgetEntry: Record "G/L Budget Entry";
        lvBudgetEntry2: Record "G/L Budget Entry";
        lvWorkPlanLine: Record "WorkPlan Line";
    begin
        TestField("Transferred To Budget", false);
        if lvGLBudget.Get("Budget Code") then begin

            lvWorkPlanLine.SetRange("WorkPlan No", "No.");
            if lvWorkPlanLine.FindSet() then begin
                repeat
                    lvBudgetEntry.Init();
                    lvBudgetEntry."Budget Name" := lvWorkPlanLine."Budget Code";
                    lvBudgetEntry."G/L Account No." := lvWorkPlanLine."Account No";
                    lvBudgetEntry.Description := lvWorkPlanLine.Description;
                    lvBudgetEntry.Validate("Global Dimension 1 Code", lvWorkPlanLine."Global Dimension 1 Code");
                    lvBudgetEntry.Validate("Global Dimension 2 Code", lvWorkPlanLine."Global Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 1 Code", lvWorkPlanLine."WorkPlan Dimension 1 Code");
                    lvBudgetEntry.Validate("Budget Dimension 2 Code", lvWorkPlanLine."WorkPlan Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 3 Code", lvWorkPlanLine."WorkPlan Dimension 3 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 4 Code", lvWorkPlanLine."WorkPlan Dimension 4 Code");
                    lvBudgetEntry.Validate("Dimension Set ID", lvWorkPlanLine."Dimension Set ID");
                    lvBudgetEntry."Work Plan" := lvWorkPlanLine."WorkPlan No";
                    lvBudgetEntry."Work Plan Entry No." := lvWorkPlanLine."Entry No";

                    if lvWorkPlanLine."Quarter 1 Amount" <> 0 then begin
                        lvBudgetEntry."Entry No." := lvWorkPlanLine."Entry No" + 1;
                        lvBudgetEntry.Validate(Date, lvGLBudget."Budget Start Date");
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 1 Amount");
                        lvBudgetEntry.Insert(true);
                    end;

                    if lvWorkPlanLine."Quarter 2 Amount" <> 0 then begin
                        lvBudgetEntry."Entry No." := lvWorkPlanLine."Entry No" + 2;
                        lvBudgetEntry.Validate(Date, CALCDATE('1Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 2 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine."Quarter 3 Amount" <> 0 then begin
                        lvBudgetEntry."Entry No." := lvWorkPlanLine."Entry No" + 3;
                        lvBudgetEntry.Validate(Date, CALCDATE('2Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 3 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvWorkPlanLine."Quarter 4 Amount" <> 0 then begin
                        lvBudgetEntry."Entry No." := lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('3Q', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvWorkPlanLine."Quarter 4 Amount");
                        lvBudgetEntry.Insert(true);
                    end;
                until lvWorkPlanLine.Next() = 0;
            end;
            "Transferred To Budget" := true;
            Modify();
            Message('Work Plan has been successfully transferred to the budget');
        end;
    end;

    procedure CheckForWorkplanLines(): Boolean
    var
        lvWorkplanLines: Record "WorkPlan Line";
    begin
        lvWorkplanLines.Reset();
        lvWorkplanLines.SetRange("WorkPlan No", Rec."No.");
        if lvWorkplanLines.FindSet() then
            exit(true)
        else
            exit(false)
    end;

    procedure WorkPlanLinesExist(): Boolean
    var
        workPlnLine: Record "WorkPlan Line";
    begin
        workPlnLine.RESET;
        workPlnLine.SETRANGE("WorkPlan No", "No.");
        IF workPlnLine.FindFirst() then
            repeat
                workPlnLine.TestField("Global Dimension 1 Code");
                workPlnLine.TestField("Global Dimension 2 Code");
                workPlnLine.TestField("Annual Amount");
                workPlnLine.TestField(Description);
            until workPlnLine.Next() = 0;
        EXIT(workPlnLine.FINDFIRST);
    end;

    procedure UpdateCurrencyFactor()
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        lvWorkplanLine: Record "WorkPlan Line";
        Updated: Boolean;
    begin
        if "Currency Code" <> '' then begin
            if "Date Created" <> 0D then
                CurrencyDate := "Date Created"
            else
                CurrencyDate := WorkDate;

            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then begin
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
                if "Currency Code" <> xRec."Currency Code" then begin
                    lvWorkplanLine.SetRange("WorkPlan No", "No.");
                    if lvWorkplanLine.FindSet() then
                        repeat
                            RecreateWorkplanLines(FieldCaption("Currency Code"));
                        until lvWorkplanLine.Next() = 0;
                end;
            end else
                UpdateCurrencyExchangeRates.ShowMissingExchangeRatesNotification("Currency Code");
        end else begin
            Validate("Currency Factor", 0);
            if "Currency Code" <> xRec."Currency Code" then begin
                RecreateWorkplanLines(FieldCaption("Currency Code"));
            end;
        end;
    end;

    procedure RecreateWorkplanLines(ChangedFieldName: Text[100])
    var
        TempWorkplanLine: Record "WorkPlan Line" temporary;
        ConfirmManagement: Codeunit "Confirm Management";
        ExtendedTextAdded: Boolean;
        ConfirmText: Text;
        IsHandled: Boolean;
    begin
        if not WorkPlanLinesExist() then
            exit;

        IsHandled := false;
        if IsHandled then
            exit;
        ConfirmText := RecreateWorkplanLinesMsg;
        //Confirmed := ConfirmManagement.GetResponseOrDefault(StrSubstNo(ConfirmText, ChangedFieldName), true);
        Confirmed := true;
        //end;

        if Confirmed then begin
            gvWorkplanLine.LockTable();
            Modify();

            gvWorkplanLine.Reset();
            gvWorkplanLine.SetRange("WorkPlan No", "No.");
            if gvWorkplanLine.FindSet() then begin
                repeat
                    TempWorkplanLine := gvWorkplanLine;
                    TempWorkplanLine.Insert();
                until gvWorkplanLine.Next() = 0;


                gvWorkplanLine.DeleteAll(true);

                gvWorkplanLine.Init();
                gvWorkplanLine."Entry No" := 0;
                TempWorkplanLine.FindSet();
                ExtendedTextAdded := false;
                repeat
                    gvWorkplanLine.Init();
                    gvWorkplanLine.Validate("WorkPlan No", TempWorkplanLine."WorkPlan No");
                    gvWorkplanLine.Validate("Budget Code", TempWorkplanLine."Budget Code");
                    gvWorkplanLine."Entry No" := gvWorkplanLine."Entry No" + 10000;
                    gvWorkplanLine.Validate("Account Type", TempWorkplanLine."Account Type");
                    if TempWorkplanLine."Account No" = '' then begin
                        gvWorkplanLine.Description := TempWorkplanLine.Description;
                    end else begin
                        gvWorkplanLine.Validate("Account No", TempWorkplanLine."Account No");
                        gvWorkplanLine.Description := TempWorkplanLine.Description;
                        gvWorkplanLine.Validate("Dimension Set ID", TempWorkplanLine."Dimension Set ID");
                        gvWorkplanLine.Validate(Month1, TempWorkplanLine.Month1);
                        gvWorkplanLine.Validate(Month2, TempWorkplanLine.Month2);
                        gvWorkplanLine.Validate(Month3, TempWorkplanLine.Month3);
                        gvWorkplanLine.Validate(Month4, TempWorkplanLine.Month4);
                        gvWorkplanLine.Validate(Month5, TempWorkplanLine.Month5);
                        gvWorkplanLine.Validate(Month6, TempWorkplanLine.Month6);
                        gvWorkplanLine.Validate(Month7, TempWorkplanLine.Month7);
                        gvWorkplanLine.Validate(Month8, TempWorkplanLine.Month8);
                        gvWorkplanLine.Validate(Month9, TempWorkplanLine.Month9);
                        gvWorkplanLine.Validate(Month10, TempWorkplanLine.Month10);
                        gvWorkplanLine.Validate(Month11, TempWorkplanLine.Month11);
                        gvWorkplanLine.Validate(Month12, TempWorkplanLine.Month12);

                        IsHandled := false;
                    end;
                    gvWorkplanLine.Insert();
                    ExtendedTextAdded := false;
                until TempWorkplanLine.Next() = 0;

                TempWorkplanLine.SetRange("Account Type");
                TempWorkplanLine.DeleteAll();
            end;
        end else
            Error(RecreateWorkplanLinesCancelErr, ChangedFieldName);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkplanApprovalRequest(var WorkplanHeader: Record "WorkPlan Header"; senderUserID: Code[50])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkplanApprovalRequest(var WorkplanHeader: Record "WorkPlan Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnViewWorkplanApprovalComments(var WorkplanHeader: Record "WorkPlan Header")
    begin

    end;


}