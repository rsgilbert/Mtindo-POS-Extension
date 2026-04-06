page 50076 "Budget Reallocation Archive"
{
    PageType = Document;
    SourceTable = "Budget Realloc Header Archive";
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Revision Type"; Rec."Budget Revision Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budget revision type relating to the Budget revision type. The options are Budget Reallocation and Budget cut.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created By Name"; Rec."Created By Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Reason for Reallocation"; Rec."Reason for Reallocation")
                {
                    ApplicationArea = All;
                }
            }
            part("Budget Reallocation Subform"; "Budget Realloc. Arch. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No" = field("No.");
            }
        }
    }

}