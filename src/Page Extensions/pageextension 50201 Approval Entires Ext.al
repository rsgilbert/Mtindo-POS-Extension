pageextension 50201 "Approval Entires Ext." extends "Approval Entries"
{
    layout
    {
        modify(Overdue)
        {
            Visible = false;
        }
        modify("Limit Type")
        {
            Visible = false;
        }
        modify("Approval Type")
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify(RecordIDText)
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = true;
        }
        modify("Document Type")
        {
            Visible = true;
        }
        addafter("Document No.")
        {
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
            }
        }

        addafter("Sender ID")
        {
            field("Requested By"; Rec."Requested By")
            {
                ApplicationArea = All;
            }
            field("Employee ID"; Rec."Employee ID")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Delegate")
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;
}