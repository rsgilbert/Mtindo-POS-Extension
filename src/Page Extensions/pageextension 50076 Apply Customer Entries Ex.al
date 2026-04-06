pageextension 50076 "Apply Customer Entries Ex" extends "Apply Customer Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Set Applies-to ID")
        {
            action("My Action")
            {


                ApplicationArea = Basic, Suite;
                Caption = 'Apply Entries customer';
                Image = Apply;
                ToolTip = 'Apply Entries customer';

                trigger OnAction()
                begin
                    // ApplyCustomerLedgerEntries();
                    // ApplyCustomerLedgerEntries(Rec."Document No.");

                end;
            }
        }
    }
}
    