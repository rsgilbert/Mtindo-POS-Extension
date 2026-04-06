tableextension 50046 "Purch Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
            begin
                if Rec.Type = Rec.Type::"G/L Account" then
                    "Budget Control A/C" := "No."
                else
                    if
                 Rec.Type = Rec.Type::Item then begin
                        GenPostingSetup.SetRange("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                        GenPostingSetup.SetRange("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                        if GenPostingSetup.FindFirst() then begin
                            GenPostingSetup.TestField("Purch. Account");
                            "Budget Control A/C" := GenPostingSetup."Purch. Account";
                        end;
                    end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                LineAmountLCY: Decimal;
            begin
                LineAmountLCY := Quantity * "Unit Cost (LCY)";
                if Quantity <> 0 then begin
                    //To be reviewed
                    if "Document Type" IN ["Document Type"::Invoice] then
                        BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
                    //LPO Budget check if the LineAmountLCY changes.
                    if LineAmountLCY > "Original Requisition Amount" then
                        if (LineAmountLCY <> (xRec.Quantity * "Unit Cost (LCY)")) and ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) then
                            BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
                end;
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            var
                LineAmountLCY: Decimal;
            begin
                LineAmountLCY := Quantity * "Unit Cost (LCY)";
                if LineAmountLCY <> 0 then begin
                    //To be reviewed
                    if "Document Type" = "Document Type"::Invoice then
                        BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
                    //LPO Budget check if the LineAmountLCY changes.
                    if LineAmountLCY > "Original Requisition Amount" then
                        if (LineAmountLCY <> (xRec.Quantity * "Unit Cost (LCY)")) and ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) then
                            BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
                end;
            end;
        }
        field(50100; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50101; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No." where("Transferred To Budget" = filter(true), Blocked = filter(false));
            trigger OnValidate()
            var
                lvWorkplanHeader: Record "WorkPlan Header";
            begin
                if lvWorkplanHeader.Get("Work Plan") then
                    "Budget Name" := lvWorkplanHeader."Budget Code";
            end;
        }
        field(50102; "Work Plan Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lvWorkplanLine: Record "WorkPlan Line";
            begin
                TestOpen(Rec);
                lvWorkplanLine.SetRange("WorkPlan No", "Work Plan");
                lvWorkplanLine.SetRange("Budget Code", "Budget Name");
                lvWorkplanLine.SetRange("Entry No", "Work Plan Entry No.");
                lvWorkplanLine.SetRange("Account No", "Budget Control A/C");
                if lvWorkplanLine.FindFirst() then begin
                    Validate("Budget Set ID", lvWorkplanLine."Dimension Set ID");
                    Validate("Dimension Set ID", lvWorkplanLine."Dimension Set ID");
                end
                else
                    Error('Workplan Entry Number %1 is not associated with budget line account No. %2.', "Work Plan Entry No.", "Budget Control A/C");
                if (Rec.Quantity <> 0) and (Rec."Direct Unit Cost" <> 0) then
                    LineBudgetCheck();
            end;

            trigger OnLookup()
            var
                WorkPlanEntry: Page "Budget Entries";
                WorkPlanLne: Record "WorkPlan Line";
            begin
                if "Type" IN ["Type"::"G/L Account", "Type"::Item, Type::"G/L Account"] then begin
                    WorkPlanLne.SetRange("WorkPlan No", "Work Plan");
                    WorkPlanLne.SetRange("Budget Code", "Budget Name");
                    WorkPlanLne.SetRange("Account No", "Budget Control A/C");
                    if WorkPlanLne.FindFirst() then begin
                        WorkPlanEntry.SetTableView(WorkPlanLne);
                        WorkPlanEntry.SetRecord(WorkPlanLne);
                        WorkPlanEntry.LookupMode(true);
                        if WorkPlanEntry.RunModal() = Action::LookupOK then begin
                            WorkPlanEntry.GetRecord(WorkPlanLne);
                            Validate("Work Plan Entry No.", WorkPlanLne."Entry No");
                            Description := WorkPlanLne."Account Name";
                        end;
                    end
                end;
            end;
        }
        field(50104; "Budget Set ID"; Integer)
        {
            Caption = 'Budget Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                if not DimMgt.CheckDimIDComb("Budget Set ID") then
                    Error(DimMgt.GetDimCombErr());
            end;
        }
        field(50105; "Budget Control A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50106; "Original Requisition Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50107; Status; Option)
        {
            OptionMembers = Open,"Pending Approval","Pending Prepayment",Released;
            Editable = false;
        }
        field(50110; "Outstand. Amt. Not Invd."; Decimal)
        {

        }
        field(50112; "Outstand. Amt. Not Invd.(LCY)"; Decimal)
        {

        }
        field(50113; "FA Posting Group"; Code[20])
        {
            TableRelation = "FA Posting Group";
        }
        field(50114; "Exclude FA Specs Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group".Code where(Blocked = const(false));
        }
        field(50116; "Initiated From Requisition"; Boolean)
        {
            Caption = 'Initiated From Requisition';
        }
    }
    keys
    {
        key(Key_Budget; "Budget Control A/C", "Work Plan", "Work Plan Entry No.", Status)
        {
            SumIndexFields = "Outstand. Amt. Not Invd.", "Outstand. Amt. Not Invd.(LCY)";
        }
    }

    trigger OnAfterInsert()
    var
        PurchHeader: Record "Purchase Header";
    begin
        IF PurchHeader.Get("Document Type", "Document No.") then begin
            validate("Work Plan", PurchHeader."Work Plan");
            "Budget Name" := PurchHeader."Budget Code";
            Modify();
        end;
    end;

    procedure TestOpen(var PurchLine: Record "Purchase Line")
    var
        lvPurchHeader: Record "Purchase Header";
    begin
        lvPurchHeader.SetRange("Document Type", PurchLine."Document Type");
        lvPurchHeader.SetRange("No.", PurchLine."Document No.");
        if lvPurchHeader.FindFirst() then
            lvPurchHeader.TestStatusOpen();
    end;

    procedure LineBudgetCheck()
    var
        LineAmountLCY: Decimal;
    begin
        LineAmountLCY := Quantity * "Unit Cost (LCY)";
        if LineAmountLCY <> 0 then begin
            if "Document Type" IN ["Document Type"::Invoice] then
                BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
            //LPO Budget check if the LineAmountLCY changes.
            if LineAmountLCY > "Original Requisition Amount" then
                if (LineAmountLCY <> (xRec.Quantity * "Unit Cost (LCY)")) and ("Document Type" = "Document Type"::Order) then
                    BudgetCheckAtInvoice(LineAmountLCY, "Line No.");
        end;
    end;

    procedure BudgetCheckAtInvoice(LineAmount: Decimal; LineNo: Integer)
    var
        PurchLine: Record "Purchase Line";
        BudgetControl: Record "Budget Control Setup";
        PendingLineAmount: Decimal;
    begin
        BudgetControl.Get();
        //Calculating Pending Amount Per Work Plan Entry
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Status, PurchLine.Status::Open);
        PurchLine.SetFilter("Line No.", '<>%1', LineNo);
        PurchLine.SetRange("Work Plan Entry No.", Rec."Work Plan Entry No.");
        IF PurchLine.FindSet() then
            repeat
                PendingLineAmount += PurchLine."Line Amount";
            until PurchLine.Next() = 0;
        BudgetControl.CheckBudget("Work Plan", "Work Plan Entry No.", "Budget Name", LineAmount, PendingLineAmount);
    end;

    // procedure ShowDimensions()
    // var
    // begin
    //     DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Line No."));
    // end;

    procedure BudgetCheck(LineAmount: Decimal; LineNo: Integer)
    var
        lvBudgetControlSetup: Record "Budget Control Setup";
        PurchLine: Record "Purchase Line";
        PendingLineAmount: Decimal;
    begin
        lvBudgetControlSetup.Get();
        //Calculating Pending Amount Per Work Plan Entry
        PurchLine.SetRange("Document Type", "Document Type");
        PurchLine.SetRange("Document No.", "Document No.");
        PurchLine.SetRange("Work Plan Entry No.", "Work Plan Entry No.");
        PurchLine.SetFilter("Line No.", '<>%1', LineNo);
        IF PurchLine.FindSet() then
            repeat
                PendingLineAmount += PurchLine."Outstand. Amt. Not Invd.(LCY)";
            until PurchLine.Next() = 0;

        //Line Budget check based on the workplan number and workplan entry number.
        lvBudgetControlSetup.CheckBudget("Work Plan", "Work Plan Entry No.", "Budget Name", LineAmount, PendingLineAmount);

    end;


    var
        DimMgt: Codeunit DimensionManagement;

}