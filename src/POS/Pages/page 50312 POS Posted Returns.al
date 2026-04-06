page 50312 "POS Posted Returns"
{
    PageType = List;
    SourceTable = "POS Transaction Header";
    SourceTableView = where("Transaction Type" = const(Return), Status = const(Posted));
    Caption = 'POS Posted Returns';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "POS Transaction Card";
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Original Receipt No."; Rec."Original Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("POS Store Code"; Rec."POS Store Code")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Sales Cr. Memo No."; Rec."Posted Sales Cr. Memo No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        POSManagement: Codeunit "POS Management";
    begin
        POSManagement.ApplyTransactionVisibilityFilter(Rec);
    end;
}
