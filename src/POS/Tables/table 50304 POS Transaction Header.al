table 50304 "POS Transaction Header"
{
    Caption = 'POS Transaction';
    DataClassification = ToBeClassified;
    LookupPageId = "POS Transactions";
    DrillDownPageId = "POS Transactions";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(2; "POS Session No."; Code[20])
        {
            Caption = 'POS Session No.';
            TableRelation = "POS Session"."No." where(Status = const(Open));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                POSSession: Record "POS Session";
                POSStore: Record "POS Store";
            begin
                if "POS Session No." = '' then
                    exit;

                POSSession.Get("POS Session No.");
                POSSession.TestField(Status, POSSession.Status::Open);
                "POS Store Code" := POSSession."POS Store Code";
                "POS Terminal Code" := POSSession."POS Terminal Code";
                "Cashier User ID" := POSSession."User ID";

                if POSStore.Get("POS Store Code") then
                    if POSStore."Walk-In Customer No." <> '' then
                        Validate("Customer No.", POSStore."Walk-In Customer No.");
            end;
        }
        field(3; "POS Store Code"; Code[20])
        {
            Caption = 'POS Store Code';
            TableRelation = "POS Store".Code where(Active = const(true));
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(4; "POS Terminal Code"; Code[20])
        {
            Caption = 'POS Terminal Code';
            TableRelation = "POS Terminal".Code where("POS Store Code" = field("POS Store Code"), Active = const(true));
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(5; "Cashier User ID"; Code[50])
        {
            Caption = 'Cashier User ID';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionMembers = Sale,Return;
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Suspended,"Pending Approval",Approved,Posted,Voided;
            DataClassification = ToBeClassified;
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CustomerRec: Record Customer;
                POSStore: Record "POS Store";
            begin
                if "Customer No." = '' then begin
                    Clear("Customer Name");
                    "Walk-In Customer" := false;
                    exit;
                end;

                CustomerRec.Get("Customer No.");
                "Customer Name" := CustomerRec.Name;
                "Walk-In Customer" := false;

                if POSStore.Get("POS Store Code") then
                    "Walk-In Customer" := POSStore."Walk-In Customer No." = "Customer No.";
            end;
        }
        field(10; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(11; "Walk-In Customer"; Boolean)
        {
            Caption = 'Walk-In Customer';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(12; "Original Receipt No."; Code[20])
        {
            Caption = 'Original Receipt No.';
            TableRelation = "POS Transaction Header"."No." where("Transaction Type" = const(Sale), Status = const(Posted));
            DataClassification = ToBeClassified;
        }
        field(13; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(14; "Posted At"; DateTime)
        {
            Caption = 'Posted At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(15; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(16; "Approved At"; DateTime)
        {
            Caption = 'Approved At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(17; "Approval Reason"; Text[100])
        {
            Caption = 'Approval Reason';
            DataClassification = ToBeClassified;
        }
        field(18; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(19; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(20; "Posted Sales Cr. Memo No."; Code[20])
        {
            Caption = 'Posted Sales Credit Memo No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(21; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(22; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            CalcFormula = Sum("POS Transaction Line"."Line Total" where("Document No." = field("No.")));
            FieldClass = FlowField;
            Editable = false;
            AutoFormatType = 1;
        }
        field(23; "Tendered Amount"; Decimal)
        {
            Caption = 'Tendered Amount';
            CalcFormula = Sum("POS Payment Line".Amount where("Document No." = field("No."), "Payment Type" = const(Payment)));
            FieldClass = FlowField;
            Editable = false;
            AutoFormatType = 1;
        }
        field(24; "Refund Amount"; Decimal)
        {
            Caption = 'Refund Amount';
            CalcFormula = Sum("POS Payment Line".Amount where("Document No." = field("No."), "Payment Type" = const(Refund)));
            FieldClass = FlowField;
            Editable = false;
            AutoFormatType = 1;
        }
        field(25; "Change Amount"; Decimal)
        {
            Caption = 'Change Amount';
            Editable = false;
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(26; "Settlement Status"; Option)
        {
            Caption = 'Settlement Status';
            OptionMembers = "Not Settled",Settled,Failed;
            DataClassification = ToBeClassified;
        }
        field(27; "Settled At"; DateTime)
        {
            Caption = 'Settled At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(28; "Settlement Error"; Text[250])
        {
            Caption = 'Settlement Error';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(29; "Receipt Print Count"; Integer)
        {
            Caption = 'Receipt Print Count';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(30; "Last Receipt Printed At"; DateTime)
        {
            Caption = 'Last Receipt Printed At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "POS Session No.", Status)
        {
        }
        key(Key3; "Cashier User ID", Status)
        {
        }
    }

    trigger OnInsert()
    var
        POSSetup: Record "POS Setup";
        POSSession: Record "POS Session";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        POSSession.SetRange("User ID", UserId);
        POSSession.SetRange(Status, POSSession.Status::Open);
        if not POSSession.FindFirst() then
            Error('Open a POS session before creating a POS transaction.');

        "POS Session No." := POSSession."No.";
        Validate("POS Session No.");

        POSSetup.Reset();
        POSSetup.Get('POS');
        if "Transaction Type" = "Transaction Type"::Return then begin
            POSSetup.TestField("POS Return Nos.");
            NoSeriesMgt.InitSeries(POSSetup."POS Return Nos.", xRec."No. Series", Today, "No.", "No. Series");
        end else begin
            "Transaction Type" := "Transaction Type"::Sale;
            POSSetup.TestField("POS Receipt Nos.");
            NoSeriesMgt.InitSeries(POSSetup."POS Receipt Nos.", xRec."No. Series", Today, "No.", "No. Series");
        end;

        "Cashier User ID" := UserId;
        "Posting Date" := Today;
        "Created At" := CurrentDateTime;
        Status := Status::Open;
        "Settlement Status" := "Settlement Status"::"Not Settled";
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
        if OldDimSetID <> "Dimension Set ID" then begin
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            Modify();
        end;
    end;

    procedure UpdateCalculatedAmounts()
    begin
        CalcFields("Total Amount", "Tendered Amount", "Refund Amount");

        if "Transaction Type" = "Transaction Type"::Sale then begin
            "Change Amount" := "Tendered Amount" - "Total Amount";
            if "Change Amount" < 0 then
                "Change Amount" := 0;
        end else
            "Change Amount" := 0;

        if not IsTemporary then
            Modify(false);
    end;

    var
        DimMgt: Codeunit DimensionManagement;
}
