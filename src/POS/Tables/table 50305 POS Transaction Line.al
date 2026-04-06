table 50305 "POS Transaction Line"
{
    Caption = 'POS Transaction Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "POS Transaction Header"."No.";
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "POS Session No."; Code[20])
        {
            Caption = 'POS Session No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No." where("POS Allowed" = const(true), Blocked = const(false));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ItemRec: Record Item;
                POSHeader: Record "POS Transaction Header";
                POSStore: Record "POS Store";
            begin
                if "Item No." = '' then begin
                    Clear(Description);
                    Clear("Barcode No.");
                    Clear("Unit of Measure Code");
                    Clear("Unit Price");
                    Clear("Original Unit Price");
                    Clear("Original Line Discount %");
                    Clear("Location Code");
                    ClearOverrideApproval();
                    UpdateAmounts();
                    exit;
                end;

                ItemRec.Get("Item No.");
                ItemRec.TestField("POS Allowed", true);

                Description := ItemRec.Description;
                "Barcode No." := ItemRec."POS Barcode";
                "Unit of Measure Code" := ItemRec."Base Unit of Measure";
                "Unit Price" := ItemRec."Unit Price";
                "Original Unit Price" := "Unit Price";
                "Original Line Discount %" := "Line Discount %";
                ClearOverrideApproval();

                if POSHeader.Get("Document No.") then
                    if POSStore.Get(POSHeader."POS Store Code") then
                        "Location Code" := POSStore."Location Code";

                if Quantity = 0 then
                    Quantity := 1;

                UpdateAmounts();
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; "Barcode No."; Code[50])
        {
            Caption = 'Barcode No.';
            DataClassification = ToBeClassified;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Quantity must be greater than zero.');

                CheckAvailableInventory();
                UpdateAmounts();
            end;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = ToBeClassified;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Unit Price" < 0 then
                    Error('Unit Price cannot be negative.');

                ResetOverrideApprovalIfNeeded();
                UpdateAmounts();
            end;
        }
        field(10; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Line Discount %" < 0) or ("Line Discount %" > 100) then
                    Error('Line Discount %% must be between 0 and 100.');

                ResetOverrideApprovalIfNeeded();
                UpdateAmounts();
            end;
        }
        field(11; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            Editable = false;
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(12; "Line Total"; Decimal)
        {
            Caption = 'Line Total';
            Editable = false;
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(13; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(14; "Price Override Approved By"; Code[50])
        {
            Caption = 'Price Override Approved By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(15; "Override Approved At"; DateTime)
        {
            Caption = 'Override Approved At';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(16; "Override Reason"; Text[100])
        {
            Caption = 'Override Reason';
            DataClassification = ToBeClassified;
        }
        field(17; "Original Receipt Line No."; Integer)
        {
            Caption = 'Original Receipt Line No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(18; "Original Unit Price"; Decimal)
        {
            Caption = 'Original Unit Price';
            Editable = false;
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
        }
        field(19; "Original Line Discount %"; Decimal)
        {
            Caption = 'Original Line Discount %';
            Editable = false;
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;
        }
        field(20; "Override Approved"; Boolean)
        {
            Caption = 'Override Approved';
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
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        POSHeader: Record "POS Transaction Header";
    begin
        POSHeader.Get("Document No.");
        "POS Session No." := POSHeader."POS Session No.";
        RefreshHeader();
    end;

    trigger OnModify()
    begin
        RefreshHeader();
    end;

    trigger OnDelete()
    begin
        RefreshHeader();
    end;

    local procedure UpdateAmounts()
    begin
        "Line Discount Amount" := Round((Quantity * "Unit Price") * "Line Discount %" / 100, 0.01, '=');
        "Line Total" := Round((Quantity * "Unit Price") - "Line Discount Amount", 0.01, '=');
        RefreshHeader();
    end;

    procedure SetOriginalPricingBaseline()
    begin
        "Original Unit Price" := "Unit Price";
        "Original Line Discount %" := "Line Discount %";
        ClearOverrideApproval();
    end;

    procedure HasPriceOverride(): Boolean
    begin
        exit("Unit Price" <> "Original Unit Price");
    end;

    procedure HasDiscountOverride(): Boolean
    begin
        exit("Line Discount %" <> "Original Line Discount %");
    end;

    procedure RequiresOverrideApproval(): Boolean
    begin
        exit(HasPriceOverride() or HasDiscountOverride());
    end;

    procedure ApproveOverride(SupervisorUserId: Code[50]; ApprovalReason: Text)
    begin
        if not RequiresOverrideApproval() then
            Error('There is no price or discount override to approve on line %1.', "Line No.");

        if SupervisorUserId = '' then
            Error('Supervisor User ID is required.');

        if ApprovalReason = '' then
            Error('Reason is required for price or discount override approval.');

        "Override Approved" := true;
        "Price Override Approved By" := SupervisorUserId;
        "Override Approved At" := CurrentDateTime;
        "Override Reason" := CopyStr(ApprovalReason, 1, MaxStrLen("Override Reason"));
        Modify(true);
    end;

    local procedure RefreshHeader()
    var
        POSHeader: Record "POS Transaction Header";
    begin
        if POSHeader.Get("Document No.") then
            POSHeader.UpdateCalculatedAmounts();
    end;

    local procedure CheckAvailableInventory()
    var
        POSHeader: Record "POS Transaction Header";
        ItemRec: Record Item;
    begin
        if "Item No." = '' then
            exit;

        if not POSHeader.Get("Document No.") then
            exit;

        if POSHeader."Transaction Type" = POSHeader."Transaction Type"::Return then
            exit;

        if "Location Code" = '' then
            exit;

        ItemRec.Get("Item No.");
        ItemRec.SetRange("Location Filter", "Location Code");
        ItemRec.CalcFields(Inventory);
        if ItemRec.Inventory < Quantity then
            Error('Available inventory for item %1 at location %2 is %3. Requested quantity is %4.', "Item No.", "Location Code", ItemRec.Inventory, Quantity);
    end;

    local procedure ResetOverrideApprovalIfNeeded()
    begin
        if not RequiresOverrideApproval() then begin
            ClearOverrideApproval();
            exit;
        end;

        ClearOverrideApproval();
    end;

    local procedure ClearOverrideApproval()
    begin
        "Override Approved" := false;
        Clear("Price Override Approved By");
        Clear("Override Approved At");
        Clear("Override Reason");
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
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
        if OldDimSetID <> "Dimension Set ID" then begin
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            Modify();
        end;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
}
