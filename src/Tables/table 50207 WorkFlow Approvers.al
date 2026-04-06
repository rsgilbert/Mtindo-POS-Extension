table 50207 "WorkFlow Approvers"
{
    DataClassification = ToBeClassified;
    //TableType = Temporary;
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
            trigger OnValidate()
            var
            begin

            end;
        }
        field(3; "Approver ID"; Code[50])
        {
        }
        field(4; "Reason for Delegation"; Text[100])
        {
        }
        field(8; "Approval Dimension Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,1,1';
        }
    }

    keys
    {
        key(Key1; "User ID", "Approver ID", "Approval Document Type", "Approval Dimension Code")
        {
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