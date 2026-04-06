page 50062 "Accountability List"
{
    PageType = List;
    CardPageId = "Accountability Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Accountability Header";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    //SourceTableView = where(Status = filter(Open | Rejected), "Bank Transfer" = filter(false));

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
                field(Status; Rec.Status)
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
        GenReqSetup: Record "Gen. Requisition Setup";
        lvUserSetup: Record "User Setup";
    begin
        lvUserSetup.Reset();
        lvUserSetup.SetRange("User ID", UserId);
        if lvUserSetup.FindFirst() then
            if not lvUserSetup."View All Accountabilities" then begin
                GenReqSetup.Get();
                if GenReqSetup.getDefaultCostCenter() <> '' then begin
                    Rec.FilterGroup(10);
                    Rec.SetFilter("Global Dimension 1 Code", GenReqSetup.getDefaultCostCenter());
                    Rec.FilterGroup(0);
                end
                else begin
                    Rec.FilterGroup(10);
                    REC.SetFilter("Created By", USERID);
                    Rec.FilterGroup(0);
                end;
            end;
    end;
}