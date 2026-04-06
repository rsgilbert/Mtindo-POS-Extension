pageextension 50040 "Purch Order Subform ExtV1" extends "Purchase Order Subform"
{
    layout
    {



        modify("Line Amount")
        {
            trigger OnAfterValidate()
            var
                BudgetContSetup: Record "Budget Control Setup";
                LinePendingAmountLCY: Decimal;
                PurchLine: Record "Purchase Line";
            begin
                if Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] then begin
                    BudgetContSetup.Get();
                    //Budget Check ======================================
                    PurchLine.SetRange("Document No.", Rec."Document No.");
                    PurchLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    PurchLine.SetRange("Work Plan Entry No.", Rec."Work Plan Entry No.");
                    if PurchLine.FindSet() then
                        repeat
                            LinePendingAmountLCY += PurchLine."Line Amount";
                        until PurchLine.Next() = 0;
                    if Rec."Original Requisition Amount" = 0 then
                        BudgetContSetup.CheckBudget(Rec."Work Plan", Rec."Work Plan Entry No.", Rec."Budget Name", Rec."Line Amount", LinePendingAmountLCY);
                    Rec."Original Requisition Amount" := Rec."Line Amount";
                    //===================================================
                end;
            end;
        }

        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = false;
        }
        modify(ShortcutDimCode3)
        {
            Editable = false;
        }
        modify(ShortcutDimCode4)
        {
            Editable = false;
        }
        modify(ShortcutDimCode5)
        {
            Editable = false;
        }
        modify(ShortcutDimCode6)
        {
            Editable = false;
        }
        modify(ShortcutDimCode7)
        {
            Editable = false;
        }
        modify(ShortcutDimCode8)
        {
            Visible = false;
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }


        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        moveafter(Quantity; "VAT Prod. Posting Group")

        addafter("No.")
        {
            field("Work Plan"; Rec."Work Plan")
            {
                ApplicationArea = All;
            }
            field("Work Plan Entry No"; Rec."Work Plan Entry No.")
            {
                ApplicationArea = All;
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter("Quantity Invoiced")
        {
            field("Exclude FA Specs Check"; Rec."Exclude FA Specs Check")
            {
                ApplicationArea = All;
            }
        }

        modify(Control19)
        {
            Visible = (not ShowTotals);
        }



    }


    actions
    {
        // Add changes to page actions here
        modify(OrderTracking)
        {
            Visible = false;
        }
        modify("E&xplode BOM")
        {
            Visible = false;
        }
        modify("Insert Ext. Texts")
        {
            Visible = false;
        }
        modify(Reserve)
        {
            Visible = false;
        }

    }
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        lvGLAccount: Record "G/L Account";
    begin

    end;

    var
        myInt: Integer;
        ShowFASpecPage: Boolean;
        DocumentTotals: Codeunit "Document Totals";
        PurchaseHeader: Record "Purchase Header";
        ShowTotals: Boolean;
}