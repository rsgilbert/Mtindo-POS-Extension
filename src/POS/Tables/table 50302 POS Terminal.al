table 50302 "POS Terminal"
{
    Caption = 'POS Terminal';
    DataClassification = ToBeClassified;
    LookupPageId = "POS Terminals";
    DrillDownPageId = "POS Terminals";

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
        field(3; "POS Store Code"; Code[20])
        {
            Caption = 'POS Store Code';
            TableRelation = "POS Store".Code where(Active = const(true));
            DataClassification = ToBeClassified;
        }
        field(4; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(5; "No. Series"; Code[20])
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
            POSSetup.TestField("POS Terminal Nos.");
            NoSeriesMgt.InitSeries(POSSetup."POS Terminal Nos.", xRec."No. Series", Today, Code, "No. Series");
        end;
    end;
}
