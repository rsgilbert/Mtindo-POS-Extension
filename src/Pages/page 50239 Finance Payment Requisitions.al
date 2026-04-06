page 50239 "Finance Payment Requisitions"
{
    PageType = List;
    CardPageId = "Payment Requisition";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Requisition Header";
    SourceTableView = where(Status = filter("Pending Approval" | Approved), "Bank Transfer" = const(false), "Document Type" = const("Payment Requisition"));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then
            Error('User Setup does not exist for user %1.', UserId);

        if not UserSetup."Finance Admin Payment Reqs View" then
            Error('You are not authorized to access Finance Payment Requisitions.');
    end;
}
