codeunit 50302 "POS Security"
{
    procedure ValidateSupervisorAuthorization(SupervisorUserId: Code[50]; ApprovalPin: Code[20])
    var
        UserSetup: Record "User Setup";
    begin
        if SupervisorUserId = '' then
            Error('Supervisor User ID is required.');

        if ApprovalPin = '' then
            Error('Approval PIN is required.');

        if not UserSetup.Get(SupervisorUserId) then
            Error('User Setup does not exist for supervisor %1.', SupervisorUserId);

        UserSetup.TestField("POS Supervisor", true);
        UserSetup.TestField("POS PIN Configured", true);
        if not VerifyUserPin(UserSetup, ApprovalPin) then
            Error('The POS approval PIN is invalid for %1.', SupervisorUserId);
    end;

    procedure SetUserPin(var UserSetup: Record "User Setup"; NewPin: Text; ConfirmPin: Text)
    begin
        if NewPin = '' then
            Error('A POS PIN is required.');

        if StrLen(NewPin) < 4 then
            Error('The POS PIN must be at least 4 characters long.');

        if NewPin <> ConfirmPin then
            Error('The POS PIN confirmation does not match.');

        UserSetup."POS Approval PIN" := HashPin(UserSetup."User ID", NewPin);
        UserSetup."POS PIN Configured" := true;
        UserSetup."POS PIN Last Changed" := CurrentDateTime;
        UserSetup.Modify(true);
    end;

    procedure ClearUserPin(var UserSetup: Record "User Setup")
    begin
        Clear(UserSetup."POS Approval PIN");
        UserSetup."POS PIN Configured" := false;
        Clear(UserSetup."POS PIN Last Changed");
        UserSetup.Modify(true);
    end;

    procedure VerifyUserPin(var UserSetup: Record "User Setup"; EnteredPin: Text): Boolean
    begin
        if not UserSetup."POS PIN Configured" then
            exit(false);

        if UserSetup."POS Approval PIN" = '' then
            exit(false);

        if UserSetup."POS Approval PIN" = EnteredPin then begin
            UserSetup."POS Approval PIN" := HashPin(UserSetup."User ID", EnteredPin);
            UserSetup."POS PIN Configured" := true;
            if UserSetup."POS PIN Last Changed" = 0DT then
                UserSetup."POS PIN Last Changed" := CurrentDateTime;
            UserSetup.Modify(true);
            exit(true);
        end;

        exit(UserSetup."POS Approval PIN" = HashPin(UserSetup."User ID", EnteredPin));
    end;

    local procedure HashPin(UserIdValue: Code[50]; PinValue: Text): Text
    var
        
        EncryptionManagement: Codeunit "Encryption Management";
        SourceText: Text;
    begin
        SourceText := UserIdValue + '|' + PinValue;
        exit(EncryptionManagement.GenerateHashAsBase64String(SourceText,2));
    end;
}
