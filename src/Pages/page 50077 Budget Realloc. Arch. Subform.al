page 50077 "Budget Realloc. Arch. Subform"
{
    PageType = ListPart;
    SourceTable = "Budget Realloc. Lines Archive";
    AutoSplitKey = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                FreezeColumn = "Available Amount";
                field("Budget Revision Type"; Rec."Budget Revision Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Budget revision type relating to the Budget revision type. The options are Budget Reallocation and Budget cut.';
                }
                field("Workplan No."; Rec."Workplan No.")
                {
                    ApplicationArea = All;

                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Workplan Entry No."; Rec."Workplan Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Available Amount"; Rec."Available Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension Code 1"; Rec."Global Dimension Code 1")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension Code 2"; Rec."Global Dimension Code 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WorkPlan Dimension 1 Code"; Rec."WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WorkPlan Dimension 3 Code"; Rec."WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 4 Code"; Rec."WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 5 Code"; Rec."WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 6 Code"; Rec."WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("New Workplan No."; Rec."New Workplan No.")
                {
                    ApplicationArea = All;
                }
                field("New G/L Account"; Rec."New G/L Account")
                {
                    ApplicationArea = All;
                }
                field("New Global Dimension Code 1"; Rec."New Global Dimension Code 1")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("New Global Dimension Code 2"; Rec."New Global Dimension Code 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("New WorkPlan Dimension 1 Code"; Rec."New WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("New WorkPlan Dimension 2 Code"; Rec."New WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("New WorkPlan Dimension 3 Code"; Rec."New WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New WorkPlan Dimension 4 Code"; Rec."New WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New WorkPlan Dimension 5 Code"; Rec."New WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New WorkPlan Dimension 6 Code"; Rec."New WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New Dimension Set ID"; Rec."New Dimension Set ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 1 Amount"; Rec."Quarter 1 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 2 Amount"; Rec."Quarter 2 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 3 Amount"; Rec."Quarter 3 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 4 Amount"; Rec."Quarter 4 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount Reallocated';
                }
                field("New Activity Description"; Rec."New Activity Description")
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
}