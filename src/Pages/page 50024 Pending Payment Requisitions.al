page 50024 "Pending Payment Requisitions"
{
    PageType = List;
    CardPageId = "Payment Requisition";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Requisition Header";
    SourceTableView = where(Status = filter("Pending Approval"), "Bank Transfer" = filter(false), "Document Type" = filter("Payment Requisition"));
    Editable = false;
    MultipleNewLines = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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

            }
        }
        area(FactBoxes)
        {

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

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
    begin
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            if not UserSetup."View All Payment Reqs." then begin
                Rec.FilterGroup(10);
                Rec.MarkedOnly(false);
                if Rec.FindSet() then
                    repeat
                        Rec.Mark(false);
                    until Rec.Next() = 0;

                Rec.SetRange("Created By", UserId);
                if Rec.FindSet() then
                    repeat
                        Rec.Mark(true);
                    until Rec.Next() = 0;
                Rec.SetRange("Created By");

                ApprovalEntry.SetRange("Table ID", Database::"Payment Requisition Header");
                ApprovalEntry.SetRange("Approver ID", UserId);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                ApprovalEntry.SetRange("Related to Change", false);
                ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Payment Requisition");
                if ApprovalEntry.FindSet() then
                    repeat
                        Rec.SetRange("No.", ApprovalEntry."Document No.");
                        if Rec.FindFirst() then
                            Rec.Mark(true);
                        Rec.SetRange("No.");
                    until ApprovalEntry.Next() = 0;

                Rec.MarkedOnly(true);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}
