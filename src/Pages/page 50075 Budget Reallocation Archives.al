page 50075 "Budget Reallocation Archives"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Budget Reallocation Archive";
    SourceTable = "Budget Realloc Header Archive";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Budget Revision Type"; Rec."Budget Revision Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budget revision type relating to the Budget revision type. The options are Budget Reallocation and Budget cut.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created By Name"; Rec."Created By Name")
                {
                    ApplicationArea = All;
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
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Reallocate)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
            action(Archive)
            {
                ApplicationArea = All;
            }
        }
    }
}