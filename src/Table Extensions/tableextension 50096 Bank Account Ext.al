tableextension 50096 "Bank Account Ext." extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50030; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }

        field(50031; "Bank Type"; Option)
        {
            OptionMembers = "","Mobile Money",NCBA,CITI,"Post Bank","Stan Chart",Stanbic,Centenary,Equity,Absa;
        }
        field(50032; "Use For Acc. Refund"; Boolean)
        {
            Caption = 'Use for Accountability Refund';
        }
        field(50033; "Over Draw"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF NOT HasUserOverdrawPermission() THEN BEGIN
                    ERROR('You don''t have the necessary rights to modify the "Bank Overdraw" option. Please contact your system administrator.');
                END;
            end;
        }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        UserSetupRec: Record "User Setup";

    local procedure HasUserOverdrawPermission(): Boolean
    begin
        UserSetupRec.Reset();
        UserSetupRec.SetRange("User ID", UserId());
        // IF UserSetupRec.FindFirst() THEN BEGIN
        //     EXIT(UserSetupRec."Enable/Disable bank over Draw");
        // END ELSE BEGIN
        //     ERROR('Your user is not configured in the User Setup. Please ask your system administrator to add you before modifying the "Bank Overdraw" option.');
        // END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendBankAccountForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelBankAccountApproval(var BankAcount: Record "Bank Account")
    begin
    end;
}