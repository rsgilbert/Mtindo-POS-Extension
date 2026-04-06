table 50016 "WHT Posting Groups"
{
    Caption = 'WHT Posting Setup';
    LookupPageID = "WHT Posting Groups";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "WHT Business Posting Group".Code where(Blocked = const(false));
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "WHT %"; Decimal)
        {
            Caption = 'WHT On Payment %';
        }
        field(4; "Prepaid WHT Account Code"; Code[20])
        {
            Caption = 'Prepaid WHT Account Code';
            TableRelation = "G/L Account";
        }
        field(5; "Payable WHT Account Code"; Code[20])
        {
            Caption = 'Payable WHT Account Code';
            TableRelation = "G/L Account";
        }
        field(6; "WHT Report"; Option)
        {
            Caption = 'WHT Report';
            OptionCaption = ' ,Por Ngor Dor 1,Por Ngor Dor 2,Por Ngor Dor 3,Por Ngor Dor 53,Por Ngor Dor 54';
            OptionMembers = " ","Por Ngor Dor 1","Por Ngor Dor 2","Por Ngor Dor 3","Por Ngor Dor 53","Por Ngor Dor 54";
        }
        field(7; "WHT Report Line No. Series"; Code[20])
        {
            Caption = 'WHT Report Line No. Series';
            TableRelation = "No. Series";
        }
        field(8; "WHT Minimum Invoice Amount"; Decimal)
        {
            Caption = 'WHT Minimum Invoice Amount';
        }
        field(9; "WHT Calculation Rule"; Option)
        {
            Caption = 'WHT Calculation Rule';
            OptionCaption = 'Less than,Less than or equal to,Equal to,Greater than,Greater than or equal to';
            OptionMembers = "Less than","Less than or equal to","Equal to","Greater than","Greater than or equal to";
        }
        field(10; "WHT On VAT Account No."; Code[20])
        {
            Caption = 'WHT On VAT Account No.';
            TableRelation = "G/L Account";
        }
        field(11; "WHT On VAT %"; Decimal)
        {
            Caption = 'WHT On VAT %';
        }
        field(12; "WHT Prod. Posting Group"; Code[20])
        {
            TableRelation = "WHT Product Posting Group".Code where(Blocked = const(false));
            Caption = 'WHT Product Posting Group';
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "Code", "WHT Prod. Posting Group")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnInsert()

    begin
        Rec."System Id" := System.CreateGuid();

    end;
}

