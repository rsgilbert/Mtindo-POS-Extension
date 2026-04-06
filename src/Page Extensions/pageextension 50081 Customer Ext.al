pageextension 50081 "Customer Ext" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Balance Due (LCY)")
        {
            field(Staff; Rec.Staff)
            {
                ApplicationArea = All;
            }
            field("Employee No"; Rec."Employee No")
            {
                ApplicationArea = All;
                //Editable = Rec.Staff;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}