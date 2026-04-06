table 50307 "POS Tender Setup"
{
    Caption = 'POS Tender Setup';
    DataClassification = ToBeClassified;
    LookupPageId = "POS Tender Setup";
    DrillDownPageId = "POS Tender Setup";

    fields
    {
        field(1; "Payment Method"; Option)
        {
            Caption = 'Payment Method';
            OptionMembers = Cash,Card,Mobile;
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionMembers = "G/L Account","Bank Account";
            DataClassification = ToBeClassified;
        }
        field(4; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"."No." where(Blocked = const(false), "Direct Posting" = const(true))
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account"."No." where(Blocked = const(false));
            DataClassification = ToBeClassified;
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Payment Method")
        {
            Clustered = true;
        }
    }
}
