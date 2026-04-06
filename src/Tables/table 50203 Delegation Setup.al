table 50203 "Delegation Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            DataClassification = ToBeClassified;
        }
        field(2; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Delegate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Delegate ID';
            NotBlank = true;
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lvDelegationUserSetup: Record "Delegation Setup";
                // UserSelection: Codeunit "User Selection";
                Text001: Label 'User % has already been delegated to by another approver, please select another person';

            begin
                lvDelegationUserSetup.Reset();
                lvDelegationUserSetup.SETRANGE("Delegate ID", "Delegate ID");
                lvDelegationUserSetup.SETRANGE("Document Type", "Document Type");
                IF lvDelegationUserSetup.FIND('-') THEN
                    ERROR(Text001);

                //Checking Cost Centers
                // EmployeeDelegatee.SetRange("User ID", "Delegate ID");
                // EmployeeDelegatee.FindFirst();
                // EmployeeApprover.SetRange("User ID", USERID);
                // EmployeeApprover.FindFirst();
                // if EmployeeApprover."Global Dimension 1 Code" <> EmployeeDelegatee."Global Dimension 1 Code" then
                //     ERROR('Delegatee %1 does not belong to the same Cost center as approver %1', "Delegate ID", "User ID");
                //End

                // UserSelection.ValidateUserName("Delegate ID");
            end;
        }
        field(4; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Allow Posting From"; Date)
        {
            Caption = 'Allow Posting From';

            trigger OnValidate()
            var
                Usersetup: Record "User Setup";
            begin
                if Usersetup.Get("User ID") then
                    Usersetup.CheckAllowedPostingDates(0);
            end;
        }
        field(7; "Allow Posting To"; Date)
        {
            Caption = 'Allow Posting To';

            trigger OnValidate()
            var
                Usersetup: Record "User Setup";
            begin
                if Usersetup.Get("User ID") then
                    Usersetup.CheckAllowedPostingDates(0);
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "User ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure SetDelegatee()
    var
        Txt001: Label 'Atleast one Delegatee must be setup for user %1 before using this functionality';
        Txt002: Label 'Delegation Completed Successfully';
        DelegationUserSetup: Record "Delegation Setup";
        NFLDepartmentalUserSetup1: Record "Departmental User Setup";
        UserSetup: Record "User Setup";
    begin
        DelegationUserSetup.SETRANGE("User ID", Rec."User ID");
        IF DelegationUserSetup.FINDSET THEN BEGIN
            REPEAT
                NFLDepartmentalUserSetup1.SETRANGE("Approver ID", DelegationUserSetup."User ID");
                NFLDepartmentalUserSetup1.SETRANGE("Document Type", DelegationUserSetup."Document Type");
                IF NFLDepartmentalUserSetup1.FINDSET THEN
                    REPEAT
                        NFLDepartmentalUserSetup1.RENAME(NFLDepartmentalUserSetup1."User ID", DelegationUserSetup."Delegate ID", NFLDepartmentalUserSetup1."Document Type", NFLDepartmentalUserSetup1."Approval Dimension Code", NFLDepartmentalUserSetup1."Sequence No.");
                        IF UserSetup.GET(DelegationUserSetup."Delegate ID") THEN BEGIN
                            //UserSetup.Delegatee := TRUE;
                            UserSetup.MODIFY;
                        END;
                    UNTIL NFLDepartmentalUserSetup1.NEXT = 0;
            UNTIL DelegationUserSetup.NEXT = 0;
            MESSAGE(Txt002);
        END
        ELSE
            ERROR(Txt001, USERID);

    end;

    procedure ReassignBackToApprover()
    var
        Txt001: Label 'An approver you are trying to re-assign back is missing';
        Txt002: Label 'Completed successfully';
        lvDelegationUserSetup: Record "Delegation Setup";
        lvNFLDepUserSetup: Record "Departmental User Setup";
        lvUserSetup: Record "User Setup";
    begin

        lvDelegationUserSetup.SETRANGE("Delegate ID", USERID);
        IF lvDelegationUserSetup.FINDSET THEN BEGIN
            REPEAT
                lvNFLDepUserSetup.SETRANGE("Approver ID", lvDelegationUserSetup."Delegate ID");
                lvNFLDepUserSetup.SETRANGE("Document Type", lvDelegationUserSetup."Document Type");
                IF lvNFLDepUserSetup.FINDSET THEN
                    REPEAT
                        lvNFLDepUserSetup.RENAME(lvNFLDepUserSetup."User ID", lvDelegationUserSetup."User ID", lvNFLDepUserSetup."Document Type", lvNFLDepUserSetup."Approval Dimension Code", lvNFLDepUserSetup."Sequence No.");
                        IF lvUserSetup.GET(lvDelegationUserSetup."Delegate ID") THEN BEGIN
                            //lvUserSetup.Delegatee := FALSE;
                            lvUserSetup.MODIFY;
                        END;
                    UNTIL lvNFLDepUserSetup.NEXT = 0;
            UNTIL lvDelegationUserSetup.NEXT = 0;
            MESSAGE(Txt002);
        END
        ELSE
            ERROR(Txt001, USERID);

    end;

}