page 50304 "POS Terminal Card"
{
    PageType = Card;
    SourceTable = "POS Terminal";
    Caption = 'POS Terminal Card';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("POS Store Code"; Rec."POS Store Code")
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
