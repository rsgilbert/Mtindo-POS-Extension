table 50301 "POS Store"
{
    Caption = 'POS Store';
    DataClassification = ToBeClassified;
    LookupPageId = "POS Stores";
    DrillDownPageId = "POS Stores";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(4; "Walk-In Customer No."; Code[20])
        {
            Caption = 'Walk-In Customer No.';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Walk-In Customer No." = '' then
                    AssignDefaultWalkInCustomer();
            end;
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        POSSetup: Record "POS Setup";
    begin
        if Code = '' then begin
            POSSetup.Reset();
            POSSetup.Get('POS');
            POSSetup.TestField("POS Store Nos.");
            NoSeriesMgt.InitSeries(POSSetup."POS Store Nos.", xRec."No. Series", Today, Code, "No. Series");
        end;

        if "Walk-In Customer No." = '' then
            AssignDefaultWalkInCustomer();
    end;

    local procedure AssignDefaultWalkInCustomer()
    var
        POSSetup: Record "POS Setup";
    begin
        POSSetup.Reset();
        if POSSetup.Get('POS') then
            if POSSetup."Default Walk-In Customer No." <> '' then
                "Walk-In Customer No." := POSSetup."Default Walk-In Customer No.";
    end;
}
