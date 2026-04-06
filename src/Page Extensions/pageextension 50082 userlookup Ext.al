pageextension 50082 "userlookup Ext" extends "User Lookup"
{
    layout
    {
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