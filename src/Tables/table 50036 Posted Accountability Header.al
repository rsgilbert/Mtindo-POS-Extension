table 50036 "Posted Accountability Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // Validate("Currency Code");
            end;
        }
        field(5; "Payee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Vendor,Customer,Bank,Statutory,Imprest,Employee;
        }
        field(6; "Payee No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Payee Type" = filter(Customer)) Customer where(Staff = const(false))
            ELSE
            IF ("Payee Type" = filter(Imprest)) Customer where(Staff = const(true))
            ELSE
            IF ("Payee Type" = CONST(Vendor)) Vendor
            else
            IF ("Payee Type" = CONST(Bank)) "Bank Account"
            else
            if ("Payee Type" = const(Employee)) Employee;

            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
                GLAccRec: Record "G/L Account";
                BankRec: Record "Bank Account";
                EmployeeRec: Record Employee;
            begin
                If CustRec.GET("Payee No") then
                    "Payee Name" := CustRec.Name;

                IF VendorRec.GET("Payee No") then begin
                    VendorRec.TestField("WHT Posting Group");
                    "Payee Name" := VendorRec.Name;
                    Validate("Currency Code", VendorRec."Currency Code");
                end;

                IF GLAccRec.GET("Payee No") then
                    "Payee Name" := GLAccRec.Name;

                IF BankRec.GET("Payee No") then begin
                    "Payee Name" := BankRec.Name;
                    Validate("Currency Code", BankRec."Currency Code");
                end;

                IF EmployeeRec.Get("Payee No") then
                    "Payee Name" := EmployeeRec.FullName();
            end;
        }
        field(7; "Payee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            //OptionMembers = "Purchase Requisition","Purchase Order","Purchase Invoice","Prepayment Invoice","Payment Requisition";
        }
        field(9; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
            Editable = false;
        }
        field(11; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            Editable = false;
        }
        field(12; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Requisitioned By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

        }
        field(16; "Requestor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; Purpose; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestField(Status, Rec.Status::Open);
            end;
        }
        field(15; "Total Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Posted Accountability Line".Amount WHERE("Document No" = FIELD("No.")));
            Caption = 'Accountable Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            //Editable = false;
        }

        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            //Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }


        field(19; "Activity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Activity Completion Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Accountability Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(23; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(24; "Ext Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Commmited; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27; "Pending At Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "Bank Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
            trigger OnValidate()
            var
                BankRec: Record "Bank Account";
            begin
                if BankRec.Get("Bank Account No") then
                    "Bank Account Name" := BankRec.Name;
            end;
        }
        field(29; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(30; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Amount To Pay"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Posted Accountability Line"."Amount To Pay" WHERE("Document No" = FIELD("No.")));
            Caption = 'Amount To Account';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Paid Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Posted Accountability Line"."Amount Paid" WHERE("Document No" = FIELD("No.")));
            Caption = 'Accounted Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; Processed; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(40; "PV No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; "Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; Accountability; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80; "Accountability Posting No."; Code[20])
        {
            Editable = false;
        }
        field(86; "Acc. Posted On"; Date)
        {
            Editable = false;
        }
        field(88; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(90; "Reversed On"; DateTime)
        {
            Caption = 'Reversed On';
            Editable = false;
        }
        field(92; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var

        DimMgt: Codeunit DimensionManagement;

    trigger OnInsert()
    begin

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

    procedure InitInsert()
    begin

    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then;

        if OldDimSetID <> "Dimension Set ID" then;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."));

        if OldDimSetID <> "Dimension Set ID" then
            Modify();
    end;

    procedure CheckIfAccountabilityIsApplied(var AccountabilityHeader: Record "Posted Accountability Header")
    var
        lvCustomerLedgerEntry: Record "Cust. Ledger Entry";
        IsApplied: Boolean;
    begin
        lvCustomerLedgerEntry.SetCurrentKey("Document No.");
        lvCustomerLedgerEntry.SetRange("Document No.", AccountabilityHeader."No.");
        lvCustomerLedgerEntry.SetRange(Reversed, false);
        if lvCustomerLedgerEntry.FindSet() then
            repeat
                lvCustomerLedgerEntry.CalcFields(Amount, "Remaining Amount");
                if lvCustomerLedgerEntry.Amount <> lvCustomerLedgerEntry."Remaining Amount" then
                    IsApplied := true;
            until lvCustomerLedgerEntry.Next() = 0;

        if IsApplied then
            Error('One or more lines related to this accountability are applied to a respective voucher line. Please remove the application to proceed the reversal.');
    end;

    procedure ReverseAccountability(var PstAccountabilityHeader: Record "Posted Accountability Header")
    var
        lvCustomerLedgerEntry: Record "Cust. Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        PstdAccountabilityLine: Record "Posted Accountability Line";
    begin
        Clear(ReversalEntry);
        lvCustomerLedgerEntry.SetCurrentKey("Document No.");
        lvCustomerLedgerEntry.SetRange("Document No.", PstAccountabilityHeader."No.");
        lvCustomerLedgerEntry.SetRange(Reversed, false);
        if lvCustomerLedgerEntry.FindSet() then
            repeat
                if lvCustomerLedgerEntry."Transaction No." <> 0 then
                    ReversalEntry.ReverseTransaction(lvCustomerLedgerEntry."Transaction No.");
            until lvCustomerLedgerEntry.Next() = 0;

        lvCustomerLedgerEntry.Reset();
        lvCustomerLedgerEntry.SetRange("Document No.", PstAccountabilityHeader."No.");
        lvCustomerLedgerEntry.SetRange(Reversed, true);
        if lvCustomerLedgerEntry.FindSet() then
            repeat
                PstdAccountabilityLine.Reset();
                PstdAccountabilityLine.SetCurrentKey("Related PR No", "Related PR Line No");
                PstdAccountabilityLine.SetRange("Related PR No", lvCustomerLedgerEntry."Payment Requisition No.");
                PstdAccountabilityLine.SetRange("Related PR Line No", lvCustomerLedgerEntry."Payment Req. Line No.");
                if PstdAccountabilityLine.FindFirst() then
                    PstdAccountabilityLine.ModifyAll(Reversed, true);
            until lvCustomerLedgerEntry.Next() = 0;
    end;

    procedure ResetAccountability(var PstAccountabilityHeader: Record "Posted Accountability Header")
    var
        lvPaymentReqHeaderArchive: Record "Payment Req. Header Archive";
        lvPaymentReqLineArchive: Record "Payment Req Line Archive";
        lvAccountabilityLine: Record "Posted Accountability Line";
        PstdAccountabilityLine: Record "Posted Accountability Line";
    begin
        lvAccountabilityLine.Reset();
        lvAccountabilityLine.SetRange("Document Type", PstAccountabilityHeader."Document Type");
        lvAccountabilityLine.SetRange("Document No", PstAccountabilityHeader."No.");
        lvAccountabilityLine.SetRange(Reversed, true);
        if lvAccountabilityLine.FindSet() then
            repeat
                lvPaymentReqLineArchive.Reset();
                lvPaymentReqLineArchive.SetRange("Document Type", lvPaymentReqLineArchive."Document Type"::"Payment Requisition");
                lvPaymentReqLineArchive.SetRange("Document No", PstAccountabilityHeader."Requisition No.");
                lvPaymentReqLineArchive.SetRange("Line No", lvAccountabilityLine."Related PR Line No");
                if lvPaymentReqLineArchive.FindFirst() then begin
                    lvPaymentReqLineArchive.Validate("Amount Accounted", (lvPaymentReqLineArchive."Amount Accounted" - lvAccountabilityLine.Amount));
                    lvPaymentReqLineArchive.Validate("Amount to Account", (lvPaymentReqLineArchive."Amount to Account" + lvAccountabilityLine.Amount));
                    if lvPaymentReqLineArchive.Accounted then
                        lvPaymentReqLineArchive.Accounted := false;
                    lvPaymentReqLineArchive.Modify();
                end;
            until lvAccountabilityLine.Next() = 0;

        lvPaymentReqHeaderArchive.Reset();
        lvPaymentReqHeaderArchive.SetRange("Document Type", lvPaymentReqHeaderArchive."Document Type"::"Payment Requisition");
        lvPaymentReqHeaderArchive.SetRange("No.", PstAccountabilityHeader."Requisition No.");
        if lvPaymentReqHeaderArchive.FindFirst() then
            if lvPaymentReqHeaderArchive.Accounted then begin
                lvPaymentReqHeaderArchive.Accounted := false;
                lvPaymentReqHeaderArchive.Modify();
            end;

        PstdAccountabilityLine.Reset();
        PstdAccountabilityLine.SetRange("Document Type", PstAccountabilityHeader."Document Type");
        PstdAccountabilityLine.SetRange("Document No", PstAccountabilityHeader."No.");
        PstdAccountabilityLine.SetRange(Reversed, false);
        if PstdAccountabilityLine.IsEmpty then begin
            PstAccountabilityHeader.Reversed := true;
            PstAccountabilityHeader."Reversed By" := UserId;
            PstAccountabilityHeader."Reversed On" := CurrentDateTime;
            PstAccountabilityHeader.Modify();
        end;
    end;
}