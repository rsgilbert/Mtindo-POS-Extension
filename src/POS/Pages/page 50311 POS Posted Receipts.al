page 50311 "POS Posted Receipts"
{
    PageType = List;
    SourceTable = "POS Transaction Header";
    SourceTableView = where("Transaction Type" = const(Sale), Status = const(Posted));
    Caption = 'POS Posted Receipts';
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
                field("POS Store Code"; Rec."POS Store Code")
                {
                    ApplicationArea = All;
                }
                field("POS Terminal Code"; Rec."POS Terminal Code")
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
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
