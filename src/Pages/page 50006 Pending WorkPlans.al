page 50006 "Pending WorkPlans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WorkPlan Header";
    CardPageId = "WorkPlan Header";
    SourceTableView = where(Status = const("Pending Approval"));
    MultipleNewLines = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    InsertAllowed = false;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; Rec."Date Created")
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
            group(Documents)
            {
                action("Dimensions")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                    end;
                }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        UserSetup: Record "User Setup";
    begin
        GenReqSetup.Get();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            if not UserSetup."View All Requisitions" then begin
                if GenReqSetup.getDefaultCostCenter() <> '' then begin
                    Rec.FilterGroup(10);
                    //Rec.SetFilter("Cost Center", GenReqSetup.getDefaultCostCenter());
                    REC.SetFilter("Created By", USERID);
                    Rec.FilterGroup(0);
                end
            end;
        end;


    end;
}