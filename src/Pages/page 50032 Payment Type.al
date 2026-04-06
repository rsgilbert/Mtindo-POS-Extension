page 50032 "Payment Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Type";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Payee Type"; Rec."Payee Type")
                {
                    ApplicationArea = All;
                }
                field(Loan; Rec.Loan)
                {
                    ApplicationArea = All;
                }
                field("Petty Cash"; Rec."Petty Cash")
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
            action("Payment Subcategory")
            {
                ApplicationArea = All;
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Payment Subcategory";
                RunPageLink = "Payment Type" = field(Code);
            }
        }
    }

    var
        myInt: Integer;
}