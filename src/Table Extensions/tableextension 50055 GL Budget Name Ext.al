tableextension 50055 "GL Budget Name Ext" extends "G/L Budget Name"
{
    fields
    {
        // Add changes to table fields here
        field(50055; "Budget Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50056; "closed"; Boolean)
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50057; "Budget End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}