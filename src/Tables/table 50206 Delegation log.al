table 50206 "Delegation log"
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
            TableRelation = "User Setup"."User ID";

        }
        field(3; "Delegatee ID"; Code[50])
        {
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

}