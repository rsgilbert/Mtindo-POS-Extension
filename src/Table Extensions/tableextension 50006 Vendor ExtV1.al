tableextension 50006 "Vendor ExtV1" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50100; "WHT Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WHT Business Posting Group".Code;
        }
        field(50102; "Vendor TIN"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}