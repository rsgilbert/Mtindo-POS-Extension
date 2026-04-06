page 50008 "Approved WorkPlans"
{
    PageType = List;
    CardPageId = "Approved WorkPlan";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WorkPlan Header";
    SourceTableView = where(Status = const(Approved));
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
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
                field("Transferred To Budget"; Rec."Transferred To Budget")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                }
                field("Approval Request Date"; Rec."Approval Request Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        UserSetup: Record "User Setup";
    begin
        GenReqSetup.Get();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            if not UserSetup."View All Requisitions" then
                if GenReqSetup.getDefaultCostCenter() <> '' then begin
                    Rec.FilterGroup(10);
                    //Rec.SetFilter("Cost Center", GenReqSetup.getDefaultCostCenter());
                    REC.SetFilter("Created By", USERID);
                    Rec.FilterGroup(0);
                end
    end;
}