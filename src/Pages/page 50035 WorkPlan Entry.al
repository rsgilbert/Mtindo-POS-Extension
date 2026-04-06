page 50035 "WorkPlan Entry"
{
    PageType = ListPart;
    SourceTable = "WorkPlan Line";
    AutoSplitKey = false;
    DelayedInsert = false;
    MultipleNewLines = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                }
                field(Input; Rec.Input)
                {
                    ApplicationArea = All;
                    Caption = 'Output Description';
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
                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan Dimension 3 Code"; Rec."WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan Dimension 4 Code"; Rec."WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan Dimension 5 Code"; Rec."WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan Dimension 6 Code"; Rec."WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                }

                field("Annual Amount"; Rec."Annual Amount")
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

    actions
    {
        area(Processing)
        {


        }
    }

    var

}