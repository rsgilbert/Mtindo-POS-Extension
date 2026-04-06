table 50020 "Budget Realloc. Header"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";


        }
        field(2; "No."; Code[20])
        {
        }
        field(3; "Created By"; Code[20])
        {
            TableRelation = Employee where(Status = filter(Active));

            trigger OnValidate()
            var
                myInt: Integer;
                lvEmployee: Record Employee;
            begin
                lvEmployee.Reset();
                if lvEmployee.Get("Created By") then begin
                    "Created By Name" := lvEmployee.FullName();
                    "Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
                end;
            end;
        }
        field(4; "Created By Name"; Text[250])
        {

        }
        field(5; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            OptionCaption = 'Open,Pending Approval, Approved, Rejected';
        }
        field(6; Purpose; Text[100])
        {
        }
        field(7; "Reason for Reallocation"; Text[100])
        {
        }
        field(8; "Document Date"; Date)
        {
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Budget Realloc. Lines".Amount where("Document No" = field("No.")));
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            //Editable = false;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
        }
        field(14; "Budget Addition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Budget Revision Type"; enum "Budget Revision Type")
        {
            Caption = 'Budget Revision Type';

            trigger OnValidate()
            var
                lvBudgetReallocLine: Record "Budget Realloc. Lines";
            begin
                if BudgetReallocLinesExist(Rec) then begin
                    if Rec."Budget Revision Type" <> xRec."Budget Revision Type" then
                        if not Confirm('Are you sure you would like to change the Budget Revision Type?') then
                            exit;

                    lvBudgetReallocLine.Reset();
                    lvBudgetReallocLine.SetRange("Document Type", rec."Document Type");
                    lvBudgetReallocLine.SetRange("Document No", Rec."No.");
                    if lvBudgetReallocLine.FindSet() then
                        repeat
                            lvBudgetReallocLine.ClearFields();
                            lvBudgetReallocLine."Budget Revision Type" := rec."Budget Revision Type";
                            lvBudgetReallocLine.Modify();
                        until lvBudgetReallocLine.Next() = 0;
                end;
            end;
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        GenReqSetup: Record "Gen. Requisition Setup";
        lvEmployee: Record Employee;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        Rec."System Id" := System.CreateGuid();
        GenReqSetup.Get();
        if "No." = '' then begin
            GenReqSetup.TestField("Budget Reallocation No.");
            NoSeriesMgt.InitSeries(GenReqSetup."Budget Reallocation No.", xRec."No. Series", Today, "No.", "No. Series");
        end;

        lvEmployee.Reset();
        lvEmployee.SetRange("User ID", UserId);
        if lvEmployee.FindFirst() then
            Validate("Created By", lvEmployee."No.");
        "Document Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        lvBudReallocLine: Record "Budget Realloc. Lines";
    begin
        lvBudReallocLine.Reset();
        lvBudReallocLine.SetRange("Document No", "No.");
        if lvBudReallocLine.FindSet() then
            lvBudReallocLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure BudgetReallocLinesExist(lvBudgetReallocHeader: Record "Budget Realloc. Header"): Boolean
    var
        lvBudgetReallocLines: Record "Budget Realloc. Lines";
    begin
        lvBudgetReallocLines.Reset();
        lvBudgetReallocLines.SetRange("Document Type", lvBudgetReallocHeader."Document Type");
        lvBudgetReallocLines.SetRange("Document No", lvBudgetReallocHeader."No.");
        if not lvBudgetReallocLines.IsEmpty then
            exit(true)
        else
            exit(false);
    end;

    procedure Reallocate()
    var
        lvBudgetReallocLine: Record "Budget Realloc. Lines";
        lvBudgetReallocLine2: Record "Budget Realloc. Lines";
        TemplvBudgetReallocLine: Record "Budget Realloc. Lines" temporary;
        lvMonth1Amount: Decimal;
        lvMonth2Amount: Decimal;
        lvMonth3Amount: Decimal;
        lvMonth4Amount: Decimal;
        lvMonth5Amount: Decimal;
        lvMonth6Amount: Decimal;
        lvMonth7Amount: Decimal;
        lvMonth8Amount: Decimal;
        lvMonth9Amount: Decimal;
        lvMonth10Amount: Decimal;
        lvMonth11Amount: Decimal;
        lvMonth12Amount: Decimal;
    begin
        lvBudgetReallocLine.Reset();
        lvBudgetReallocLine.SetRange("Document No", "No.");
        lvBudgetReallocLine.SetFilter(Amount, '>%1', 0);
        lvBudgetReallocLine.SetFilter("Fully Reallocated", '=%1', false);
        if lvBudgetReallocLine.FindSet() then
            repeat
                if lvBudgetReallocLine.Reallocate = false then begin
                    Clear(lvMonth1Amount);
                    Clear(lvMonth2Amount);
                    Clear(lvMonth3Amount);
                    Clear(lvMonth4Amount);
                    Clear(lvMonth5Amount);
                    Clear(lvMonth6Amount);
                    Clear(lvMonth7Amount);
                    Clear(lvMonth8Amount);
                    Clear(lvMonth9Amount);
                    Clear(lvMonth10Amount);
                    Clear(lvMonth11Amount);
                    Clear(lvMonth12Amount);

                    lvBudgetReallocLine2.Reset();
                    lvBudgetReallocLine2.SetRange("New Workplan No.", lvBudgetReallocLine."New Workplan No.");
                    lvBudgetReallocLine2.SetRange("New G/L Account", lvBudgetReallocLine."New G/L Account");
                    lvBudgetReallocLine2.SetRange("New Global Dimension Code 2", lvBudgetReallocLine."New Global Dimension Code 2");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 1 Code", lvBudgetReallocLine."New WorkPlan Dimension 1 Code");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 2 Code", lvBudgetReallocLine."New WorkPlan Dimension 2 Code");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 3 Code", lvBudgetReallocLine."New WorkPlan Dimension 3 Code");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 4 Code", lvBudgetReallocLine."New WorkPlan Dimension 4 Code");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 5 Code", lvBudgetReallocLine."New WorkPlan Dimension 5 Code");
                    lvBudgetReallocLine2.SetRange("New WorkPlan Dimension 6 Code", lvBudgetReallocLine."New WorkPlan Dimension 6 Code");
                    lvBudgetReallocLine2.SetRange("New Activity Description", lvBudgetReallocLine."New Activity Description");
                    lvBudgetReallocLine2.MarkedOnly(false);
                    if lvBudgetReallocLine2.FindSet() then
                        repeat
                            lvMonth1Amount += lvBudgetReallocLine2.Month1;
                            lvMonth2Amount += lvBudgetReallocLine2.Month2;
                            lvMonth3Amount += lvBudgetReallocLine2.Month3;
                            lvMonth4Amount += lvBudgetReallocLine2.Month4;
                            lvMonth5Amount += lvBudgetReallocLine2.Month5;
                            lvMonth6Amount += lvBudgetReallocLine2.Month6;
                            lvMonth7Amount += lvBudgetReallocLine2.Month7;
                            lvMonth8Amount += lvBudgetReallocLine2.Month8;
                            lvMonth9Amount += lvBudgetReallocLine2.Month9;
                            lvMonth10Amount += lvBudgetReallocLine2.Month10;
                            lvMonth11Amount += lvBudgetReallocLine2.Month11;
                            lvMonth12Amount += lvBudgetReallocLine2.Month12;
                            lvBudgetReallocLine2.Reallocate := true;
                            lvBudgetReallocLine2.Modify();
                        until lvBudgetReallocLine2.Next() = 0;

                    TemplvBudgetReallocLine.TransferFields(lvBudgetReallocLine);
                    TemplvBudgetReallocLine.Insert();
                    TemplvBudgetReallocLine.Month1 := lvMonth1Amount;
                    TemplvBudgetReallocLine.Month2 := lvMonth2Amount;
                    TemplvBudgetReallocLine.Month3 := lvMonth3Amount;
                    TemplvBudgetReallocLine.Month4 := lvMonth4Amount;
                    TemplvBudgetReallocLine.Month5 := lvMonth5Amount;
                    TemplvBudgetReallocLine.Month6 := lvMonth6Amount;
                    TemplvBudgetReallocLine.Month7 := lvMonth7Amount;
                    TemplvBudgetReallocLine.Month8 := lvMonth8Amount;
                    TemplvBudgetReallocLine.Month9 := lvMonth9Amount;
                    TemplvBudgetReallocLine.Month10 := lvMonth10Amount;
                    TemplvBudgetReallocLine.Month11 := lvMonth11Amount;
                    TemplvBudgetReallocLine.Month12 := lvMonth12Amount;
                    TemplvBudgetReallocLine.Modify();
                end;
            Until lvBudgetReallocLine.Next() = 0;

        InsertIntoWorkplan(TemplvBudgetReallocLine);

        Clear(TemplvBudgetReallocLine);

        lvBudgetReallocLine.Reset();
        lvBudgetReallocLine.SetRange("Document No", "No.");
        lvBudgetReallocLine.SetFilter("Fully Reallocated", '=%1', false);
        if lvBudgetReallocLine.FindFirst() then
            Error('All lines must be fully reallocated before Archiving the document')
        else
            ArchiveDocument();

    end;

    local procedure InsertIntoWorkplan(var lvBudgetReallocLineTemp: Record "Budget Realloc. Lines" temporary): Boolean
    var
        myInt: Integer;
        lvWorkplanline: Record "WorkPlan Line";
        lvWorkplanline_Reversal: Record "WorkPlan Line" temporary;
        WorkplanLineLastEntryNo: Integer;
        lvBudgetReallocLine: Record "Budget Realloc. Lines";

    begin
        lvBudgetReallocLineTemp.Reset();
        lvBudgetReallocLineTemp.SetRange("Document No", "No.");
        if lvBudgetReallocLineTemp.FindSet() then
            repeat
                //Inserting New entry =============================
                lvWorkplanLine.Reset();
                lvWorkplanLine.SetRange("WorkPlan No", lvBudgetReallocLineTemp."New Workplan No.");
                if lvWorkplanLine.FindLast() then
                    WorkplanLineLastEntryNo := lvWorkplanLine."Entry No";

                lvWorkplanLine.Reset();
                lvWorkplanLine."Entry No" := WorkplanLineLastEntryNo + 10000;
                lvWorkplanLine.Validate("WorkPlan No", lvBudgetReallocLineTemp."New Workplan No.");
                lvWorkplanLine.Validate("Budget Code", lvBudgetReallocLineTemp."New Budget Code");
                lvWorkplanLine.Validate("Account No", lvBudgetReallocLineTemp."New G/L Account");
                lvWorkplanLine.Description := lvBudgetReallocLineTemp."New Activity Description";
                lvWorkplanline.Validate("Global Dimension 2 Code", lvBudgetReallocLineTemp."New Global Dimension Code 2");
                lvWorkplanLine.validate("WorkPlan Dimension 1 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 1 Code");
                lvWorkplanLine.Validate("WorkPlan Dimension 2 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 2 Code");
                lvWorkplanLine.Validate("WorkPlan Dimension 3 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 3 Code");
                lvWorkplanLine.Validate("WorkPlan Dimension 4 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 4 Code");
                lvWorkplanLine.Validate("WorkPlan Dimension 5 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 5 Code");
                lvWorkplanLine.Validate("WorkPlan Dimension 6 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 6 Code");
                lvWorkplanline.Validate("Dimension Set ID", lvBudgetReallocLineTemp."New Dimension Set ID");
                lvWorkplanLine.Validate(Month1, lvBudgetReallocLineTemp.Month1);
                lvWorkplanLine.Validate(Month2, lvBudgetReallocLineTemp.Month2);
                lvWorkplanLine.Validate(Month3, lvBudgetReallocLineTemp.Month3);
                lvWorkplanLine.Validate(Month4, lvBudgetReallocLineTemp.Month4);
                lvWorkplanLine.Validate(Month5, lvBudgetReallocLineTemp.Month5);
                lvWorkplanLine.Validate(Month6, lvBudgetReallocLineTemp.Month6);
                lvWorkplanLine.Validate(Month7, lvBudgetReallocLineTemp.Month7);
                lvWorkplanLine.Validate(Month8, lvBudgetReallocLineTemp.Month8);
                lvWorkplanLine.Validate(Month9, lvBudgetReallocLineTemp.Month9);
                lvWorkplanLine.Validate(Month10, lvBudgetReallocLineTemp.Month10);
                lvWorkplanLine.Validate(Month11, lvBudgetReallocLineTemp.Month11);
                lvWorkplanLine.Validate(Month12, lvBudgetReallocLineTemp.Month12);
                lvWorkplanLine.Reallocated := true;
                if lvWorkplanLine.Insert() then begin
                    lvBudgetReallocLineTemp."Fully Reallocated" := true;
                    lvBudgetReallocLineTemp.Modify();
                    lvBudgetReallocLine.Reset();
                    lvBudgetReallocLine.SetRange("New Workplan No.", lvBudgetReallocLineTemp."New Workplan No.");
                    lvBudgetReallocLine.SetRange("New G/L Account", lvBudgetReallocLineTemp."New G/L Account");
                    lvBudgetReallocLine.SetRange("New Dimension Set ID", lvBudgetReallocLineTemp."New Dimension Set ID");
                    lvBudgetReallocLine.SetRange("New Activity Description", lvBudgetReallocLineTemp."New Activity Description");
                    if lvBudgetReallocLine.FindSet() then
                        repeat
                            lvBudgetReallocLine."Fully Reallocated" := true;
                            lvBudgetReallocLine.Modify();
                        until lvBudgetReallocLine.Next() = 0;

                    TransferToBudget(lvWorkplanline);

                end;
                //lvWorkplanLine.Validate("WorkPlan Dimension 2 Code", lvBudgetReallocLineTemp."New WorkPlan Dimension 2 Code");
                lvWorkplanline.Modify();
                //End ================================================

                //Inserting Reallocation entry =============================
                Clear(WorkplanLineLastEntryNo);
                lvWorkplanline_Reversal.Reset();
                lvWorkplanline_Reversal.SetRange("WorkPlan No", lvBudgetReallocLineTemp."Workplan No.");
                if lvWorkplanline_Reversal.FindLast() then
                    WorkplanLineLastEntryNo := lvWorkplanline_Reversal."Entry No";

                lvWorkplanline_Reversal.Reset();
                lvWorkplanline_Reversal."Entry No" := WorkplanLineLastEntryNo + 10000;
                lvWorkplanline_Reversal.Validate("WorkPlan No", lvBudgetReallocLineTemp."Workplan No.");
                lvWorkplanline_Reversal.Validate("Budget Code", lvBudgetReallocLineTemp."Budget Code");
                lvWorkplanline_Reversal.Validate("Account No", lvBudgetReallocLineTemp."Account No");
                lvWorkplanline_Reversal.Description := lvBudgetReallocLineTemp."Activity Description";
                lvWorkplanline_Reversal.Validate("Global Dimension 1 Code", lvBudgetReallocLineTemp."Global Dimension Code 1");
                lvWorkplanline_Reversal.Validate("Global Dimension 2 Code", lvBudgetReallocLineTemp."Global Dimension Code 2");
                lvWorkplanline_Reversal.validate("WorkPlan Dimension 1 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 1 Code");
                lvWorkplanline_Reversal.Validate("WorkPlan Dimension 2 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 2 Code");
                lvWorkplanline_Reversal.Validate("WorkPlan Dimension 3 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 3 Code");
                lvWorkplanline_Reversal.Validate("WorkPlan Dimension 4 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 4 Code");
                lvWorkplanline_Reversal.Validate("WorkPlan Dimension 5 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 5 Code");
                lvWorkplanline_Reversal.Validate("WorkPlan Dimension 6 Code", lvBudgetReallocLineTemp."WorkPlan Dimension 6 Code");
                lvWorkplanline_Reversal.Validate(Month1, -1 * lvBudgetReallocLineTemp.Month1);
                lvWorkplanline_Reversal.Validate(Month2, -1 * lvBudgetReallocLineTemp.Month2);
                lvWorkplanline_Reversal.Validate(Month3, -1 * lvBudgetReallocLineTemp.Month3);
                lvWorkplanline_Reversal.Validate(Month4, -1 * lvBudgetReallocLineTemp.Month4);
                lvWorkplanline_Reversal.Validate(Month5, -1 * lvBudgetReallocLineTemp.Month5);
                lvWorkplanline_Reversal.Validate(Month6, -1 * lvBudgetReallocLineTemp.Month6);
                lvWorkplanline_Reversal.Validate(Month7, -1 * lvBudgetReallocLineTemp.Month7);
                lvWorkplanline_Reversal.Validate(Month8, -1 * lvBudgetReallocLineTemp.Month8);
                lvWorkplanline_Reversal.Validate(Month9, -1 * lvBudgetReallocLineTemp.Month9);
                lvWorkplanline_Reversal.Validate(Month10, -1 * lvBudgetReallocLineTemp.Month10);
                lvWorkplanline_Reversal.Validate(Month11, -1 * lvBudgetReallocLineTemp.Month11);
                lvWorkplanline_Reversal.Validate(Month12, -1 * lvBudgetReallocLineTemp.Month12);
                lvWorkplanline_Reversal.Reallocated := true;
                if lvWorkplanline_Reversal.Insert() then begin
                    lvBudgetReallocLineTemp."Fully Reallocated" := true;
                    lvBudgetReallocLineTemp.Modify();
                    lvBudgetReallocLine.Reset();
                    lvBudgetReallocLine.SetRange("Workplan No.", lvBudgetReallocLineTemp."Workplan No.");
                    lvBudgetReallocLine.SetRange("Account No", lvBudgetReallocLineTemp."Account No");
                    lvBudgetReallocLine.SetRange("Dimension Set ID", lvBudgetReallocLineTemp."Dimension Set ID");
                    lvBudgetReallocLine.SetRange("Activity Description", lvBudgetReallocLineTemp."Activity Description");
                    if lvBudgetReallocLine.FindSet() then
                        repeat
                            lvBudgetReallocLine."Fully Reallocated" := true;
                            lvBudgetReallocLine.Modify();
                        until lvBudgetReallocLine.Next() = 0;

                    TransferToBudget(lvWorkplanline_Reversal);

                end;

            //End =============================================

            until lvBudgetReallocLineTemp.Next() = 0;
    end;

    procedure ArchiveDocument()
    var
        lvBudgetReallocLine: Record "Budget Realloc. Lines";
        lvBudReallocHeaderArch: Record "Budget Realloc Header Archive";
        lvBudReallocLinesArch: Record "Budget Realloc. Lines Archive";
    begin
        lvBudReallocHeaderArch.Init();
        lvBudReallocHeaderArch.TransferFields(Rec);
        lvBudReallocHeaderArch.InitInsert(lvBudReallocHeaderArch);
        lvBudReallocHeaderArch.Insert(true);
        lvBudgetReallocLine.SetRange("Document No", "No.");
        if lvBudgetReallocLine.FindSet() then
            repeat
                lvBudReallocLinesArch.Init();
                lvBudReallocLinesArch.TransferFields(lvBudgetReallocLine);
                lvBudReallocLinesArch."Archive No." := lvBudReallocHeaderArch."Archive No.";
                lvBudReallocLinesArch.Insert(true);
            until lvBudgetReallocLine.Next() = 0;
        if Rec.Delete(true) then
            message('The budget Reallocation Document has been successfully archived');
    end;

    procedure TransferToBudget(var lvWorkplanline: Record "WorkPlan Line")
    var
        Txt001: Label 'Budget to reallocate to is missing';
        lvGLBudget: Record "G/L Budget Name";
        lvBudgetEntry: Record "G/L Budget Entry";
        lvBudgetEntry2: Record "G/L Budget Entry";
        //lvWorkPlanLine: Record "WorkPlan Line";
        lvNxtentryNo: Integer;
    begin
        if not lvGLBudget.Get(lvWorkplanline."Budget Code") then
            Error(Txt001);
        //repeat
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

            lvBudgetEntry."Entry No." := lvNxtentryNo; //lvWorkPlanLine."Entry No" + 2;
            lvBudgetEntry.Validate(Date, CALCDATE('10M', lvGLBudget."Budget Start Date"));
            lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month11);
            lvBudgetEntry.Insert(true);
        end;
        if lvWorkPlanLine.Month12 <> 0 then begin
            if lvBudgetEntry2.FindLast() then
                lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
            else
                lvNxtentryNo := 1;

            lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 3;
            lvBudgetEntry.Validate(Date, CALCDATE('11M', lvGLBudget."Budget Start Date"));
            lvBudgetEntry.Validate(Amount, lvWorkPlanLine.Month12);
            lvBudgetEntry.Insert(true);
        end;
        //until lvWorkPlanLine.Next() = 0;
        Message('Work Plan has been successfully transferred to the budget');
    end;

    procedure TransferBudgetcutToBudget(var lvBudgetReallocHeader: Record "Budget Realloc. Header")
    var
        lvGLBudget: Record "G/L Budget Name";
        lvBudgetEntry: Record "G/L Budget Entry";
        lvBudgetEntry2: Record "G/L Budget Entry";
        lvBudgetReallocline: Record "Budget Realloc. Lines";
        lvBudgetReallocline2: Record "Budget Realloc. Lines";
        lvNxtentryNo: Integer;
        Txt001Err: Label 'Budget to reallocate to is missing';
    begin
        if lvBudgetReallocHeader."Budget Revision Type" = lvBudgetReallocHeader."Budget Revision Type"::"Budget Cut" then begin
            lvBudgetReallocline.Reset();
            lvBudgetReallocline.SetRange("Document Type", lvBudgetReallocHeader."Document Type");
            lvBudgetReallocline.SetRange("Document No", lvBudgetReallocHeader."No.");
            lvBudgetReallocline.SetRange("Fully Reallocated", false);
            if lvBudgetReallocline.FindSet() then
                repeat
                    if not lvGLBudget.Get(lvBudgetReallocline."Budget Code") then
                        Error(Txt001Err);
                    //repeat
                    if lvBudgetEntry2.FindLast() then
                        lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                    else
                        lvNxtentryNo := 1;

                    lvBudgetEntry.Init();
                    lvBudgetEntry."Budget Name" := lvBudgetReallocline."Budget Code";
                    lvBudgetEntry."G/L Account No." := lvBudgetReallocline."Account No";
                    lvBudgetEntry.Description := lvBudgetReallocline."Activity Description";
                    lvBudgetEntry.Validate("Global Dimension 1 Code", lvBudgetReallocline."Global Dimension Code 1");
                    lvBudgetEntry.Validate("Global Dimension 2 Code", lvBudgetReallocline."Global Dimension Code 2");
                    lvBudgetEntry.Validate("Budget Dimension 1 Code", lvBudgetReallocline."WorkPlan Dimension 1 Code");
                    lvBudgetEntry.Validate("Budget Dimension 2 Code", lvBudgetReallocline."WorkPlan Dimension 2 Code");
                    lvBudgetEntry.Validate("Budget Dimension 3 Code", lvBudgetReallocline."WorkPlan Dimension 3 Code");
                    //lvBudgetEntry.Validate("Budget Dimension 4 Code", lvWorkPlanLine."WorkPlan Dimension 4 Code");
                    lvBudgetEntry.Validate("Dimension Set ID", lvBudgetReallocline."Dimension Set ID");
                    lvBudgetEntry."Work Plan" := lvBudgetReallocline."WorkPlan No.";
                    lvBudgetEntry."Work Plan Entry No." := lvBudgetReallocline."Workplan Entry No.";

                    if lvBudgetReallocline.Month1 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 1;
                        lvBudgetEntry.Validate(Date, lvGLBudget."Budget Start Date");
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month1 * -1);
                        lvBudgetEntry.Insert(true);
                    end;

                    if lvBudgetReallocline.Month2 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo; //lvWorkPlanLine."Entry No" + 2;
                        lvBudgetEntry.Validate(Date, CALCDATE('1M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month2 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month3 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 3;
                        lvBudgetEntry.Validate(Date, CALCDATE('2M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month3 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month4 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('3M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month4 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month5 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('4M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month5 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month6 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('5M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month6 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month7 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('6M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month7 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month8 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('7M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month8 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month9 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('8M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month9 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month10 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;


                        lvBudgetEntry."Entry No." := lvNxtentryNo; // lvWorkPlanLine."Entry No" + 4;
                        lvBudgetEntry.Validate(Date, CALCDATE('9M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month10 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month11 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo; //lvWorkPlanLine."Entry No" + 2;
                        lvBudgetEntry.Validate(Date, CALCDATE('10M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month11 * -1);
                        lvBudgetEntry.Insert(true);
                    end;
                    if lvBudgetReallocline.Month12 <> 0 then begin
                        if lvBudgetEntry2.FindLast() then
                            lvNxtentryNo := lvBudgetEntry2."Entry No." + 1
                        else
                            lvNxtentryNo := 1;

                        lvBudgetEntry."Entry No." := lvNxtentryNo;// lvWorkPlanLine."Entry No" + 3;
                        lvBudgetEntry.Validate(Date, CALCDATE('11M', lvGLBudget."Budget Start Date"));
                        lvBudgetEntry.Validate(Amount, lvBudgetReallocline.Month12 * -1);
                        lvBudgetEntry.Insert(true);
                    end;

                    lvBudgetReallocline."Fully Reallocated" := true;
                    lvBudgetReallocline.Modify();
                until lvBudgetReallocLine.Next() = 0;

            lvBudgetReallocline2.Reset();
            lvBudgetReallocline2.SetRange("Document No", "No.");
            lvBudgetReallocline2.SetFilter("Fully Reallocated", '=%1', false);
            if not lvBudgetReallocline2.IsEmpty then
                Error('All lines must be fully reallocated before Archiving the document')
            else
                ArchiveDocument();
        end;
    end;

    procedure ExportReallocation(var BudgetRealloc: Record "Budget Realloc. Header")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        BudgetReallocaLines: Record "Budget Realloc. Lines";
        WorkPlanLbl: Label 'Budget Reallocation Lines';
        ExcelFileName: Label 'Reallocation_Lines_%1_%2';
    begin
        BudgetReallocaLines.SetRange("Document No", BudgetRealloc."No.");
        if BudgetReallocaLines.FindSet() then begin
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Workplan No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Account No"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Workplan Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Activity Description"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Workplan No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New G/L Account"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Workplan Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Global Dimension Code 1"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Global Dimension Code 2"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 4 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 5 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 6 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 7 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Activity Description"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month1), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month2), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month3), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month4), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month5), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month6), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month7), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month8), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month9), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month10), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month11), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month12), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Budget Category"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(BudgetReallocaLines."Workplan No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."Account No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."Workplan Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."Activity Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Workplan No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New G/L Account", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                //TempExcelBuffer.AddColumn(BudgetReallocaLines."New Workplan Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Global Dimension Code 1", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Global Dimension Code 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 4 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 5 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 6 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                //TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 7 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Activity Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month4, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month5, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month6, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month7, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month8, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month9, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month10, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month11, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month12, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines."Budget Category", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until BudgetReallocaLines.Next() = 0;
            TempExcelBuffer.CreateNewBook(WorkPlanLbl);
            TempExcelBuffer.WriteSheet(WorkPlanLbl, CompanyName, UserId);
            TempExcelBuffer.CloseBook();
            TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
            TempExcelBuffer.OpenExcel();
        end;
    end;

    procedure ExportAddition(var BudgetRealloc: Record "Budget Realloc. Header")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        BudgetReallocaLines: Record "Budget Realloc. Lines";
        WorkPlanLbl: Label 'Budget Reallocation Lines';
        ExcelFileName: Label 'Reallocation_Lines_%1_%2';
    begin
        BudgetReallocaLines.SetRange("Document No", BudgetRealloc."No.");
        if BudgetReallocaLines.FindSet() then begin
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Workplan No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New G/L Account"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Global Dimension Code 1"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Global Dimension Code 2"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 4 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 5 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 6 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New WorkPlan Dimension 7 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("New Activity Description"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month1), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month2), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month3), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month4), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month5), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month6), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month7), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month8), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month9), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month10), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month11), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption(Month12), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines.FieldCaption("Budget Category"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Workplan No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New G/L Account", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Global Dimension Code 1", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Global Dimension Code 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 4 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 5 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 6 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                //TempExcelBuffer.AddColumn(BudgetReallocaLines."New WorkPlan Dimension 7 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines."New Activity Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month4, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month5, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month6, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month7, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month8, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month9, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month10, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month11, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BudgetReallocaLines.Month12, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            //TempExcelBuffer.AddColumn(BudgetReallocaLines."Budget Category", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until BudgetReallocaLines.Next() = 0;
            TempExcelBuffer.CreateNewBook(WorkPlanLbl);
            TempExcelBuffer.WriteSheet(WorkPlanLbl, CompanyName, UserId);
            TempExcelBuffer.CloseBook();
            TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
            TempExcelBuffer.OpenExcel();
        end;
    end;


    procedure ClearBudgetReallocationLines()
    var
        ReallocLine: Record "Budget Realloc. Lines";
    begin
        ReallocLine.SetRange("Document No", Rec."No.");
        if ReallocLine.FindFirst() then
            ReallocLine.DeleteAll();
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendBudgetReallocApprovalRequest(var BudgetReallocHeader: Record "Budget Realloc. Header"; senderUserID: Code[50])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelBudgetReallocApprovalRequest(var BudgetReallocHeader: Record "Budget Realloc. Header")
    begin

    end;

}