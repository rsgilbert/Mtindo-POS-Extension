page 50041 "WHT Posting Groups"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "WHT Posting Groups";
    Caption = 'WHT Posting Setup';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("WHT Minimum Invoice Amount"; Rec."WHT Minimum Invoice Amount")
                {
                    ApplicationArea = All;
                }
                field("Payable WHT Account Code"; Rec."Payable WHT Account Code")
                {
                    ApplicationArea = All;
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                }
                field("WHT On VAT Account No."; Rec."WHT On VAT Account No.")
                {
                    ApplicationArea = All;
                }
                field("WHT On VAT %"; Rec."WHT On VAT %")
                {
                    ApplicationArea = All;
                }
                field("WHT Report"; Rec."WHT Report")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}