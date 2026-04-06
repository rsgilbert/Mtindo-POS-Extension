tableextension 50059 "Customer Ext" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";
            Caption = 'Employee No';
            DataClassification = ToBeClassified;
        }
        field(50011; Staff; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}