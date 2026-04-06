page 50009 "WorkPlan Header Archive"
{
    PageType = Document;
    SourceTable = "WorkPlan Header Archive";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Requested By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension one"; Rec."Cost Center")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Transferred To Budget"; Rec."Transferred To Budget")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Lines)
            {
                part("WorkPlan Lines"; "WorkPlan Lines Archive")
                {
                    ApplicationArea = All;
                    SubPageLink = "Archive No" = FIELD("Archive No");
                }
            }
        }
    }
}