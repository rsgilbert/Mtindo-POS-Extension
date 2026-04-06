tableextension 50060 "Item ExtV1" extends Item
{
    fields
    {
        // Add changes to table fields here
        modify("Gen. Prod. Posting Group")
        {
            trigger OnAfterValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
            begin
                //GenPostingSetup.SetRange("Gen. Bus. Posting Group", '');
                GenPostingSetup.SetRange("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                GenPostingSetup.SetFilter("Purch. Account", '<>%1', '');
                if GenPostingSetup.FindFirst() then begin
                    GenPostingSetup.TestField("Purch. Account");
                    "Purchase Account" := GenPostingSetup."Purch. Account";
                end;
            end;
        }
        field(50060; "Purchase Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50300; "POS Allowed"; Boolean)
        {
            Caption = 'POS Allowed';
            DataClassification = ToBeClassified;
        }
        field(50301; "POS Barcode"; Code[50])
        {
            Caption = 'POS Barcode';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
