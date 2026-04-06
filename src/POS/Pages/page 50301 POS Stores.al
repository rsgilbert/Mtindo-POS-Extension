page 50301 "POS Stores"
{
    PageType = List;
    SourceTable = "POS Store";
    Caption = 'POS Stores';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "POS Store Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Walk-In Customer No."; Rec."Walk-In Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
