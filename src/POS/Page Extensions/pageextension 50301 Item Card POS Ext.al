pageextension 50301 "Item Card POS Ext" extends "Item Card"
{
    layout
    {
        addafter(Inventory)
        {
            group("Point Of Sale")
            {
                field("POS Allowed"; Rec."POS Allowed")
                {
                    ApplicationArea = All;
                }
                field("POS Barcode"; Rec."POS Barcode")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
