table 50041 "WorkPlan Header Archive"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Global Dimension 1 Code"; Code[20])
        {

            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }

        field(4; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

        }
        field(5; "WorkPlan Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(6; "WorkPlan Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(7; "WorkPlan Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(8; "WorkPlan Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(24; "WorkPlan Dimension 5 Code"; Code[20])
        {

            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(25; "WorkPlan Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            Editable = false;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            Editable = false;
        }
        field(10; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Transferred To Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
        }
        field(15; "Financial Year"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Amount; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("WorkPlan Line Archive"."Annual Amount" WHERE("Archive No" = FIELD("Archive No")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Approval Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Rejection Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Rejected By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Cost Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;
        }
        field(26; "Fund Source"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50; "Archive No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Archived By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Archive Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "Archive No")
        {
            Clustered = true;
        }
    }

    var
        GenReqSetup: Record "Gen. Requisition Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        //InitInsert();
        "System Id" := System.CreateGuid();
        "Archive Date" := Today;
        "Archived By" := UserId;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure InitInsert(var Header: Record "WorkPlan Header Archive")
    var
    begin
        GenReqSetup.Get();
        if "Archive No" = '' then begin
            GenReqSetup.TestField("Work Plan Archive Nos.");
            NoSeriesMgt.InitSeries(GenReqSetup."Work Plan Archive Nos.", xRec."No. Series", Today, Rec."Archive No", Rec."No. Series");
            Header."Archived By" := UserId;
            Header."Archive Date" := Today;
        end;
    end;

}