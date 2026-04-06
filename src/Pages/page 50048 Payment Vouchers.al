page 50048 "Payment Vouchers"
{
    PageType = List;
    CardPageId = "Payment Voucher Card"; // "Payment Reqtn Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Requisition Header";
    SourceTableView = where(Status = filter(Approved), Processed = const(true), "Bank Transfer" = filter(false));
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
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Visible = false;
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
        GenReqSetup: Record "Gen. Requisition Setup";
    begin
        GenReqSetup.Get();
        if GenReqSetup.getDefaultCostCenter() <> '' then begin
            Rec.FilterGroup(10);
            Rec.SetFilter("Global Dimension 1 Code", GenReqSetup.getDefaultCostCenter());
            REC.SetFilter("Created By", USERID);
            Rec.FilterGroup(0);
        end
        else begin
            Rec.FilterGroup(10);
            REC.SetFilter("Created By", USERID);
            Rec.FilterGroup(0);
        end;

    end;
}