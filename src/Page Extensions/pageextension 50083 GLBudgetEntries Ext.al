pageextension 50083 "GLBudgetEntries Ext" extends "G/L Budget Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Work Plan No"; Rec."Work Plan")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
    end;

    var
        myInt: Integer;
}