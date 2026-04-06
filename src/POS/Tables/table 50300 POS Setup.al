table 50300 "POS Setup"
{
    Caption = 'POS Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "POS Store Nos."; Code[20])
        {
            Caption = 'POS Store Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(3; "POS Terminal Nos."; Code[20])
        {
            Caption = 'POS Terminal Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(4; "POS Session Nos."; Code[20])
        {
            Caption = 'POS Session Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(5; "POS Receipt Nos."; Code[20])
        {
            Caption = 'POS Receipt Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(6; "POS Return Nos."; Code[20])
        {
            Caption = 'POS Return Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(7; "Default Walk-In Customer No."; Code[20])
        {
            Caption = 'Default Walk-In Customer No.';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;
        }
        field(8; "Session Variance Threshold"; Decimal)
        {
            Caption = 'Session Variance Threshold';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(9; "Allow Receipt Reprint"; Boolean)
        {
            Caption = 'Allow Receipt Reprint';
            DataClassification = ToBeClassified;
        }
        field(10; "Require Return Approval"; Boolean)
        {
            Caption = 'Require Return Approval';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(11; "Require Price Override"; Boolean)
        {
            Caption = 'Require Price Override';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(12; "Require Discount Approval"; Boolean)
        {
            Caption = 'Require Discount Approval';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(13; "Settlement Jnl. Template"; Code[10])
        {
            Caption = 'Settlement Jnl. Template';
            TableRelation = "Gen. Journal Template";
            DataClassification = ToBeClassified;
        }
        field(14; "Settlement Jnl. Batch"; Code[10])
        {
            Caption = 'Settlement Jnl. Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Settlement Jnl. Template"));
            DataClassification = ToBeClassified;
        }
        field(15; "Auto Post Settlement"; Boolean)
        {
            Caption = 'Auto Post Settlement';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
