tableextension 50064 "Employee ExtV1" extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(50060; Department; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50061; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Txt0001: Label 'User %1 has already been mapped to another staff';
                EmployeeRec: Record Employee;
            // UserSelection: Codeunit "User Selection";
            begin
                /* UserSelection.ValidateUserName("User ID");*/
                if "User ID" <> '' then begin
                    EmployeeRec.Reset();
                    EmployeeRec.SetRange("User ID", "User ID");
                    if EmployeeRec.FindFirst() then
                        Error(Txt0001, "User ID");
                end;
            end;
        }
        field(50062; Signature; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;

        }
        field(50063; "Mobile Money No."; Text[30])
        {
            Caption = 'Mobile Money No.';

        }

        field(50064; Signature2; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;

        }
    }

    var
        myInt: Integer;
        usersetup: Record "User Setup";
}