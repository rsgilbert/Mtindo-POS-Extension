tableextension 50018 "Purch Invoice Line" extends "Purch. Inv. Line"
{
    fields
    {
        // Add changes to table fields here
        field(50300; "PR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50301; "PR Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50302; "PR Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50303; "PR Line Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50100; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50101; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Work Plan Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50104; "Budget Set ID"; Integer)
        {
            Caption = 'Budget Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
        field(50105; "Budget Control A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50106; "Original Requisition Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50114; "Exclude FA Specs Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group".Code where(Blocked = const(false));
        }
        field(50116; "Initiated From Requisition"; Boolean)
        {
            Caption = 'Initiated From Requisition';
        }
        field(50306; "PR Commitment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50307; "Commitment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50309; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(50310; "Amount Inc. VAT (LCY)"; Decimal)
        {
            Caption = 'Amount Inc. VAT (LCY)';
        }
    }
    keys
    {
        key(Key_Budget; "Budget Control A/C", "Work Plan", "Work Plan Entry No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    var
        myInt: Integer;
}