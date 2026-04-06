page 50303 "POS Terminals"
{
    PageType = List;
    SourceTable = "POS Terminal";
    Caption = 'POS Terminals';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "POS Terminal Card";

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
