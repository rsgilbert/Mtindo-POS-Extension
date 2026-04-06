tableextension 50043 "Source Code Setup Ext." extends "Source Code Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Payment Requisition"; Code[10])
        {
            TableRelation = "Source Code".Code;
        }
        field(50102; "Accountability"; code[10])
        {
            TableRelation = "Source Code".Code;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

}