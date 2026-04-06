table 50303 "POS Session"
{
    Caption = 'POS Session';
    DataClassification = ToBeClassified;
    LookupPageId = "POS Sessions";
    DrillDownPageId = "POS Sessions";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(2; "POS Store Code"; Code[20])
        {
            Caption = 'POS Store Code';
            TableRelation = "POS Store".Code where(Active = const(true));
            DataClassification = ToBeClassified;
        }
        field(3; "POS Terminal Code"; Code[20])
        {
            Caption = 'POS Terminal Code';
            TableRelation = "POS Terminal".Code where("POS Store Code" = field("POS Store Code"), Active = const(true));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                POSTerminal: Record "POS Terminal";
            begin
                if "POS Terminal Code" = '' then
                    exit;

                POSTerminal.Get("POS Terminal Code");
                Validate("POS Store Code", POSTerminal."POS Store Code");
                EnsureUniqueOpenSession();
            end;
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Closed;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(6; "Opened At"; DateTime)
        {
            Caption = 'Opened At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(7; "Closed At"; DateTime)
        {
            Caption = 'Closed At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(8; "Opening Float"; Decimal)
        {
            Caption = 'Opening Float';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(9; "Expected Cash"; Decimal)
        {
            Caption = 'Expected Cash';
            AutoFormatType = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(10; "Counted Cash"; Decimal)
        {
            Caption = 'Counted Cash';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(11; "Cash Variance"; Decimal)
        {
            Caption = 'Cash Variance';
            AutoFormatType = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(12; "Variance Reason"; Text[100])
        {
            Caption = 'Variance Reason';
            DataClassification = ToBeClassified;
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(14; "Closed By Supervisor"; Code[50])
        {
            Caption = 'Closed By Supervisor';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "User ID", Status)
        {
        }
        key(Key3; "POS Terminal Code", Status)
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        POSSetup: Record "POS Setup";
    begin
        POSSetup.Reset();
        POSSetup.Get('POS');
        POSSetup.TestField("POS Session Nos.");
        NoSeriesMgt.InitSeries(POSSetup."POS Session Nos.", xRec."No. Series", Today, "No.", "No. Series");

        if "User ID" = '' then
            "User ID" := UserId;

        Status := Status::Open;
        "Opened At" := CurrentDateTime;

        EnsureUniqueOpenSession();
    end;

    procedure EnsureUniqueOpenSession()
    var
        ExistingSession: Record "POS Session";
    begin
        if Status <> Status::Open then
            exit;

        ExistingSession.SetRange(Status, ExistingSession.Status::Open);
        ExistingSession.SetFilter("No.", '<>%1', "No.");
        ExistingSession.SetRange("User ID", "User ID");
        if ExistingSession.FindFirst() then
            Error('User %1 already has an open POS session (%2).', "User ID", ExistingSession."No.");

        if "POS Terminal Code" = '' then
            exit;

        ExistingSession.Reset();
        ExistingSession.SetRange(Status, ExistingSession.Status::Open);
        ExistingSession.SetFilter("No.", '<>%1', "No.");
        ExistingSession.SetRange("POS Terminal Code", "POS Terminal Code");
        if ExistingSession.FindFirst() then
            Error('Terminal %1 already has an open POS session (%2).', "POS Terminal Code", ExistingSession."No.");
    end;
}
