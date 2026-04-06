page 50010 WorkPlans
{
    PageType = List;
    CardPageId = "WorkPlan Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WorkPlan Header";
    SourceTableView = where(Status = filter(Open | Rejected));

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
                // field("Global Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;
                // }
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
            }
        }
    }



}