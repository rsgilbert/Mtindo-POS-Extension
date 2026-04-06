tableextension 50019 "Company information Ext" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "TIN"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Watermark"; Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
    }

    var
        myInt: Integer;
}