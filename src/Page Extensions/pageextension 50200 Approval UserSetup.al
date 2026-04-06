pageextension 50200 "Approval UserSetup" extends "Approval User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Approval Administrator")
        {
            field(Requestor; Rec.Requestor)
            {
                ApplicationArea = All;
            }
            field("Finance Admin Payment Reqs View"; Rec."Finance Admin Payment Reqs View")
            {
                ApplicationArea = All;
            }
            field(Signature; Rec.Signature)
            {
                ApplicationArea = All;
            }
            field("POS Cashier"; Rec."POS Cashier")
            {
                ApplicationArea = All;
            }
            field("POS Supervisor"; Rec."POS Supervisor")
            {
                ApplicationArea = All;
            }
            field(POSPinConfigured; POSPinConfigured)
            {
                Caption = 'POS PIN Configured';
                ApplicationArea = All;
                Editable = false;
            }
            field("POS PIN Last Changed"; Rec."POS PIN Last Changed")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addbefore("&Approval User Setup Test")
        {
            action("Departmental Approvers")
            {
                Caption = 'Approvers';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Departmental User Setup";
                RunPageLink = "User ID" = FIELD("User ID");
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Set POS PIN")
            {
                Caption = 'Set POS PIN';
                ApplicationArea = All;
                Image = Change;

                trigger OnAction()
                var
                    POSSecurity: Codeunit "POS Security";
                    POSPINSetupDialog: Page "POS PIN Setup Dialog";
                begin
                    if POSPINSetupDialog.RunModal() <> Action::OK then
                        exit;

                    POSSecurity.SetUserPin(Rec, POSPINSetupDialog.GetNewPin(), POSPINSetupDialog.GetConfirmPin());
                    UpdatePOSPinConfigured();
                    CurrPage.Update(false);
                end;
            }
            action("Clear POS PIN")
            {
                Caption = 'Clear POS PIN';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                var
                    POSSecurity: Codeunit "POS Security";
                begin
                    if not Confirm('Clear the POS PIN for user %1?', false, Rec."User ID") then
                        exit;

                    POSSecurity.ClearUserPin(Rec);
                    UpdatePOSPinConfigured();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdatePOSPinConfigured();
    end;

    var
        myInt: Integer;
        POSPinConfigured: Boolean;

    local procedure UpdatePOSPinConfigured()
    begin
        POSPinConfigured := Rec."POS PIN Configured";
    end;
}
