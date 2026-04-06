pageextension 50079 PurchaseOrderArchivesListExt extends "Purchase Order Archives"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            // field("Amount"; lvAmount)
            // {
            //     ApplicationArea = All;
            // }
        }
    }


    trigger OnAfterGetRecord()
    var
        lvLineArchive: Record "Purchase Line Archive";
    begin
        Clear(lvAmount);
        lvLineArchive.Reset();
        lvLineArchive.SetRange("Document No.", Rec."No.");
        if lvLineArchive.FindSet() then begin
            repeat
                lvAmount += lvLineArchive."Line Amount";
            until lvLineArchive.Next() = 0;
        end;
        lvAmount := lvAmount;
    end;


    var
        lvAmount: Decimal;

}