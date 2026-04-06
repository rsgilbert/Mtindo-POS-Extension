page 50230 "Approval Codes"
{
    Caption = 'Approval Codes';
    PageType = List;
    SourceTable = "Requisition Approval Code";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Linked To Table No."; Rec."Linked To Table No.")
                {
                    ApplicationArea = All;
                    LookupPageID = "Table Objects";
                }
                field("Linked To Table Name"; Rec."Linked To Table Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

