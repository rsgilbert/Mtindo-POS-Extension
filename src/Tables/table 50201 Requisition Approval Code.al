table 50201 "Requisition Approval Code"
{
    Caption = 'Requisition Approval Code';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Linked To Table Name"; Text[50])
        {
            Caption = 'Linked To Table Name';
        }
        field(4; "Linked To Table No."; Integer)
        {
            Caption = 'Linked To Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = filter(Table));
            trigger OnValidate()
            var
                AllObj: Record AllObj;
            begin
                AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                AllObj.SetRange("Object ID", "Linked To Table No.");
                IF AllObj.FindFirst() then
                    "Linked To Table Name" := AllObj."Object Name"
                else
                    "Linked To Table Name" := '';
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Objects: Record AllObj;
}

