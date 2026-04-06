page 50007 "WorkPlan Lines Archive"
{
    PageType = ListPart;
    SourceTable = "WorkPlan Line Archive";
    MultipleNewLines = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan Dimension 1 Code"; Rec."WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 3 Code"; Rec."WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 4 Code"; Rec."WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 5 Code"; Rec."WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 6 Code"; Rec."WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                }
                field(Input; Rec.Input)
                {
                    ApplicationArea = All;
                }
                field(Targets; Rec.Targets)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                }
                field(Commitment; Rec.Commitment)
                {
                    ApplicationArea = All;
                }
                field(Actuals; Rec.Actuals)
                {
                    ApplicationArea = All;
                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}