page 50011 "Archived WorkPlans"
{
    Caption = 'Work Plan Archive List';
    PageType = List;
    CardPageId = "WorkPlan Header Archive";
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "WorkPlan Header Archive";
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
                field("Archived No."; Rec."Archive No")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension one"; Rec."Cost Center")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension two"; Rec."Fund Source")
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
    }

}