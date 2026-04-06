tableextension 50053 "G/L Entry ExtV1" extends "G/L Entry"
{
    fields
    {
        field(50001; "Foreign Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Foreign Amount';
        }
        field(50002; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(50003; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
        }
        // Add changes to table fields here
        // Add changes to table fields here
        field(50004; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50010; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "G/L Budget Name";
        }
        field(50006; "Work Plan Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50007; "Budget Set ID"; Integer)
        {
            Caption = 'Budget Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                if not DimMgt.CheckDimIDComb("Budget Set ID") then
                    Error(DimMgt.GetDimCombErr());
            end;
        }
        field(50008; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Reversal Description"; Text[100])
        {
            Editable = false;

        }
        field(50013; "Accountability"; Boolean) { }
        field(50014; "Method of Disposal"; Text[250]) { }
        field(50015; "Disposal Reserve Price"; Decimal) { }
        field(50016; "Disposal Date of Award"; Date) { }

        field(50017; "Initiator"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
            Caption = 'Initiator';
        }
        field(50018; "Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
            Caption = 'Approver';
        }
        field(50053; "Contract No."; Code[20])
        {
        }
        field(50054; "Contract Line No."; Integer)
        {
        }
        field(50055; "Fiscal Document No."; Code[20])
        {
            Caption = 'Fiscal Document No.';
        }
        field(50056; "Budget Control A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(Key90; "Work Plan", "Work Plan Entry No.", "Budget Name", "Budget Control A/C")
        {

        }
    }

    var
        DimMgt: Codeunit DimensionManagement;

}