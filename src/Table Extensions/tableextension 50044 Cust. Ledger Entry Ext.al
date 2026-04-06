tableextension 50044 "Cust. Ledger Entry Ext." extends "Cust. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Payment Requisition No."; Code[20])
        {
            Caption = 'Payment Requisition No.';
        }
        field(50101; "Payment Req. Line No."; Integer)
        {
            Caption = 'Payment Req. Line No.';
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

    var
        myInt: Integer;
}