page 50080 "Archived Accountabilities"
{
    PageType = List;
    CardPageId = "Payment Requisition Archive";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Req. Header Archive";
    SourceTableView = where("Document Type" = filter(Accountability));
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                }
                field("Archive Date"; Rec."Archive Date")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(FactBoxes)
        {

        }
    }


}