table 50039 "Payment Subcategory"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Payment Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Type".Code;
        }
        field(4; Block; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Payee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Vendor,Customer,Bank,Statutory,Imprest,Employee;
        }
        field(6; "Requires WorkPlan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Debit G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; Code, "Payment Type")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."System Id" := System.CreateGuid();
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