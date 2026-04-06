table 50204 "Approval Delegation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Approval Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            DataClassification = ToBeClassified;
        }
        field(2; "User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                User: Record User;
            begin
                if "User ID" <> '' then begin
                    User.SetRange("User Name", "User ID");
                    if User.FindFirst() then
                        "User Name" := User."Full Name";
                end
                else
                    "User Name" := '';
            end;
        }
        field(3; "Delegatee ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                User: Record User;
            begin
                if Rec."Delegatee ID" = Rec."User ID" then
                    Error('User ID and Delegatee ID cannot be the same');
                if "Delegatee ID" <> '' then begin
                    User.SetRange("User Name", "Delegatee ID");
                    if User.FindFirst() then
                        "Delegatee Name" := User."Full Name";
                end
                else
                    "Delegatee Name" := '';
            end;
        }
        field(4; "Reason for Delegation"; Text[100])
        {
        }
        field(5; "Start Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."Start Date" < Today then
                    Error('Start Date cannot be earlier than today.');
            end;
        }
        field(6; "End Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."End Date" <= "Start Date" then
                    Error('End date must not be earlier than start date.');
            end;
        }
        field(7; "Last Date-Time Modified"; DateTime)
        {

        }
        field(8; "Delegated Successfully"; Boolean)
        {
        }
        field(9; "User Name"; Text[100])
        {

        }
        field(10; "Delegatee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Approval Document Type", "User ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        Rec."User ID" := UserId;
    end;

    trigger OnModify()
    begin
        Rec."Last Date-Time Modified" := CurrentDateTime;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}