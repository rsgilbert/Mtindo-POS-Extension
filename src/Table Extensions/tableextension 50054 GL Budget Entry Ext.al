tableextension 50054 "GL Budget Entry Ext" extends "G/L Budget Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50054; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "G/L Budget Name";
        }
        field(50055; "Work Plan Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "G/L Budget Name";
        }
        field(50056; "Activity Description Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeDelete()
    var
        myInt: Integer;
    begin
        if (Rec."Work Plan" <> '') or (Rec."Work Plan Entry No." <> 0) then begin
            Error('You can not delete this budget entry because it was already approved');
        end;
    end;

    trigger OnBeforeModify()
    var
        myInt: Integer;
    begin
        if (Rec."Work Plan" <> '') or (Rec."Work Plan Entry No." <> 0) then begin
            Error('You can not modify this budget entry because it was already approved');
        end;
    end;
}