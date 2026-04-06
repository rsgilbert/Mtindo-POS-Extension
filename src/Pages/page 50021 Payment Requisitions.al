page 50021 "Payment Requisitions"
{
    PageType = List;
    CardPageId = "Payment Requisition";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Requisition Header";
    SourceTableView = where(Status = filter(Open | Rejected), "Document Type" = filter("Payment Requisition"));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
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

        }
    }

    var
        GenReqSetup1: Record "Gen. Requisition Setup";

    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        lvUserSetup: Record "User Setup";
    begin
        GenReqSetup.Get();


        lvUserSetup.Reset();
        lvUserSetup.SetRange("User ID", UserId);
        lvUserSetup.FindFirst();
        if not lvUserSetup."View All Payment Reqs." then begin
            Rec.FilterGroup(10);
            REC.SetFilter("Created By", USERID);
            Rec.FilterGroup(0);
        end

    end;
}