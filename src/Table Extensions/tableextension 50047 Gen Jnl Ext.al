tableextension 50047 "Gen Jnl Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50101; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No." where("Transferred To Budget" = const(true), Blocked = const(false), Status = const(Approved));
            trigger OnValidate()
            var
                lvWorkplanHeader: Record "WorkPlan Header";
            begin
                if "Work Plan" <> '' then begin
                    if Rec."Work Plan" <> xRec."Work Plan" then
                        Validate("Work Plan Entry No.", 0);
                    if lvWorkplanHeader.Get("Work Plan") then
                        "Budget Name" := lvWorkplanHeader."Budget Code";
                end
                else begin
                    Validate("Work Plan Entry No.", 0);
                    Clear("Budget Name");
                end;
            end;
        }
        field(50102; "Work Plan Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            TableRelation = "WorkPlan Line"."Entry No" where("WorkPlan No" = field("Work Plan"), "Budget Code" = field("Budget Name"), "Account No" = field("Account No."));
            trigger OnValidate()
            var
                WorkPlanLne: Record "WorkPlan Line";
                BudControlSetup: Record "Budget Control Setup";
            begin
                BudControlSetup.Get();
                if "Work Plan Entry No." <> 0 then begin
                    WorkPlanLne.SetRange("WorkPlan No", "Work Plan");
                    WorkPlanLne.SetRange("Entry No", "Work Plan Entry No.");
                    if WorkPlanLne.FindFirst() then begin
                        Validate("Shortcut Dimension 1 Code", WorkPlanLne."Global Dimension 1 Code");
                        Validate("Shortcut Dimension 2 Code", WorkPlanLne."Global Dimension 2 Code");
                        Validate("Dimension Set ID", WorkPlanLne."Dimension Set ID");
                        Validate("Budget Set ID", WorkPlanLne."Dimension Set ID");
                        "Budget Control A/C" := WorkPlanLne."Account No";
                        if "Amount (LCY)" <> 0 then
                            BudgetCheck(Rec);
                    end
                end
                else begin
                    Validate("Dimension Set ID", 0);
                    Validate("Budget Set ID", 0);
                    clear("Budget Control A/C");
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
        field(50106; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Reversal Description"; Text[100])
        {
            Editable = false;
        }
        field(50109; "Payment Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }

        field(50110; "Created From Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50112; "Payment Req. Line No."; Integer)
        {
            Caption = 'Payment Req. Line No.';
        }
        // field(50113; Payee; Text[2048])
        // {
        //     Caption = 'Payee';
        //     DataClassification = ToBeClassified;
        // }
        modify("Account No.")
        {
            trigger OnBeforeValidate()
            begin
                ClearWorkplanEntryNo();
            end;
        }


    }

    keys
    {
        key(Budgeting; "Work Plan", "Work Plan Entry No.", "Budget Control A/C") { }
    }


    var
        BudgetContSetup: Record "Budget Control Setup";
        GenLedgerSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;

    procedure BudgetCheck(var GenJournalLine: Record "Gen. Journal Line")
    var
        lvGenJnlLine: Record "Gen. Journal Line";
        LinePendingAmountLCY: Decimal;
    begin
        GenLedgerSetup.Get();
        BudgetContSetup.get();
        clear(LinePendingAmountLCY);
        if GenLedgerSetup."Enable Gen. Jnl. Budget checks" then begin
            lvGenJnlLine.Reset();
            lvGenJnlLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            lvGenJnlLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            lvGenJnlLine.SetFilter("Line No.", '<>%1', GenJournalLine."Line No.");
            lvGenJnlLine.SetRange("Work Plan", GenJournalLine."Work Plan");
            lvGenJnlLine.SetRange("Work Plan Entry No.", GenJournalLine."Work Plan Entry No.");
            if lvGenJnlLine.FindSet() then
                repeat
                    LinePendingAmountLCY += lvGenJnlLine."Amount (LCY)";
                until lvGenJnlLine.Next() = 0;
            BudgetContSetup.CheckBudget(GenJournalLine."Work Plan", GenJournalLine."Work Plan Entry No.", GenJournalLine."Budget Name", GenJournalLine."Amount (LCY)", LinePendingAmountLCY);
        end;
    end;

    procedure ClearWorkplanEntryNo()
    begin
        GenLedgerSetup.Get();
        if GenLedgerSetup."Enable Gen. Jnl. Budget checks" then
            if (Rec."Account Type" = Rec."Account Type"::"G/L Account") or (Rec."Account Type" = Rec."Account Type"::Customer) then
                if Rec."Account No." <> xRec."Account No." then begin
                    Validate("Work Plan Entry No.", 0);
                    Validate(Amount, 0);
                end;
    end;
}