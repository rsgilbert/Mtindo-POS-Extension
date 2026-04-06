pageextension 50043 "G/L Account Card Ext" extends "G/L Account Card"
{
    layout
    {
        addafter("Direct Posting")
        {
            field("Travel Expense Type"; Rec."Travel Expense Type")
            {
                ApplicationArea = All;
                // Visible = Rec."Account Category" = Rec."Account Category"::Expense;
            }
            field("Add to Work Plan"; Rec."Add to Work Plan")
            {
                ApplicationArea = All;
                // Enabled = Rec."Account Type" = Rec."Account Type"::Posting;
            }
            // Add changes to page layout here
        }
        // Add changes to page layout here
        addafter("Omit Default Descr. in Jnl.")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }



    }

    actions
    {

    }

    trigger OnAfterGetCurrRecord()
    begin

    end;


    var
        generalLedgerSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        SubscriberCU: Codeunit Subscriber;
        GLApprovalsEnabled: Boolean;
        PageEditability: Boolean;

}