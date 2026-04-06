tableextension 50200 "Approval Entry Ext." extends "Approval Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50185; Purpose; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50186; "Requested By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50187; "Payee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50188; "Journal Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50189; "Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Gen. Journal Batch".Name;
        }
        field(50190; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }

        field(50191; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50192; "Journal Line No."; Integer)
        {
        }
        field(50193; "Approver's Email"; Text[80])
        {
        }

        field(50194; "Employee ID"; Text[80])
        {

        }
        field(50195; "Rejection Comment"; Text[250])
        {

        }


    }

}