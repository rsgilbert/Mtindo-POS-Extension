pageextension 50063 "G/L Entry Ext." extends "General Ledger Entries"
{
    layout
    {
        addbefore(Amount)
        {


            field("Fiscal Document No."; Rec."Fiscal Document No.")
            {
                ApplicationArea = All;
                // FieldPropertyName = FieldPropertyValue;
            }
            field("Work Plan"; Rec."Work Plan")
            {
                ApplicationArea = All;
            }
            field("Work Plan Entry No."; Rec."Work Plan Entry No.")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        addafter(Dimensions)
        {
            action("Update work plan details")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateDescription;
                Visible = false;
                trigger OnAction()
                var
                    // UpdateWorkplanforPayroll: Report "Update Workplan for Payroll";
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.SetRange("Document No.", Rec."Document No.");
                    GLEntry.SetRange("Posting Date", Rec."Posting Date");
                    GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
                    GLEntry.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
                    GLEntry.SetRange("Global Dimension 2 Code", Rec."Global Dimension 2 Code");
                    // UpdateWorkplanforPayroll.SetTableView(GLEntry);
                    // UpdateWorkplanforPayroll.RunModal();
                end;
            }
        }

    }

    var
        myInt: Integer;
}