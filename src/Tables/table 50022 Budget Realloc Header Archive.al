table 50022 "Budget Realloc Header Archive"
{
    fields
    {

        field(1; "Document Type"; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";


        }
        field(2; "No."; Code[20])
        {
        }
        field(3; "Created By"; Code[20])
        {
            TableRelation = Employee where(Status = filter(Active));

            trigger OnValidate()
            var
                myInt: Integer;
                lvEmployee: Record Employee;
            begin
                lvEmployee.Reset();
                if lvEmployee.Get("Created By") then
                    "Created By Name" := lvEmployee.FullName();
            end;
        }
        field(4; "Created By Name"; Text[250])
        {

        }
        field(5; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            OptionCaption = 'Open,Pending Approval, Approved, Rejected';
        }
        field(6; Purpose; Text[100])
        {
        }
        field(7; "Reason for Reallocation"; Text[100])
        {
        }
        field(8; "Document Date"; Date)
        {
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Budget Realloc. Lines Archive".Amount where("Document No" = field("No.")));
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            //Editable = false;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
        }
        field(14; "Budget Addition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Budget Revision Type"; enum "Budget Revision Type")
        {
            Caption = 'Budget Revision Type';
        }
        field(20; "Archive No."; Code[20])
        {
        }
        field(22; "Archived Date"; Date)
        {
            Editable = false;
        }
        field(23; "Archived By"; Code[20])
        {
            Editable = false;
        }
        field(50000; "System Id"; Guid) { }

    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        GenReqSetup: Record "Gen. Requisition Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        Rec."System Id" := System.CreateGuid();
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

    procedure InitInsert(var Header: Record "Budget Realloc Header Archive")
    var
        IsHandled: Boolean;
    begin
        GenReqSetup.Get();
        if "Archive No." = '' then begin
            GenReqSetup.TestField("Budget Realloc. Archive No.");
            NoSeriesMgt.InitSeries(GenReqSetup."Budget Realloc. Archive No.", xRec."No. Series", Today, "Archive No.", "No. Series");
            Header."Archived By" := UserId;
            Header."Archived Date" := Today;
        end;
    end;

}