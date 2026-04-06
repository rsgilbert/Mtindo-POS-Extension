table 50037 "Posted Accountability Line"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Pstd. Accountability Subform";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "WorkPlan Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","G/L Account",Vendor,"Bank Account",Customer;
        }
        field(8; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            else
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";
            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
                GLAccRec: Record "G/L Account";
                BankRec: Record "Bank Account";
                EmployeeLedger: Record "Employee Ledger Entry";
            begin
                if (xRec."Account No" <> '') AND (Rec."Account No" <> xRec."Account No") then begin
                    Clear("Account Name");
                    Clear(Description);
                    Clear(Quantity);
                    Clear(Rate);
                    Clear("Dimension Set ID");
                    Clear("Shortcut Dimension 1 Code");
                    Clear("Shortcut Dimension 2 Code");
                    Clear("WorkPlan Entry No");
                    Clear(Amount);
                    Clear("Amount (LCY)");
                    Clear("Amount To Pay");
                    Clear("VAT Amount");
                end;

                If CustRec.GET("Account No") then
                    "Account Name" := CustRec.Name;

                IF VendorRec.GET("Account No") then
                    "Account Name" := VendorRec.Name;

                IF GLAccRec.GET("Account No") then
                    "Account Name" := GLAccRec.Name;

                IF BankRec.GET("Account No") then
                    "Account Name" := BankRec.Name;
            end;
        }
        field(9; "Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

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

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }

        field(20; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
        }
        field(21; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Applies To DocType"; Option)
        {
            OptionMembers = " ",Payment,"Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
            DataClassification = ToBeClassified;
        }
        field(23; "Applies-To-DocNo"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Applies-To-ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Available To Spend"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Amount To Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            // Editable = false;
        }
        field(34; "WHT on VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "WHT Transferred"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Rate (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44; "Amount To Pay (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Related PR No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Related PR Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Generated From PR"; Boolean)
        {

        }
        field(58; "Outstanding Amount (LCY)"; Decimal)
        {
            MinValue = 0;
        }
        field(59; "Amount Paid (LCY)"; Decimal)
        {
        }
        field(60; "Payee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Vendor,Customer,Bank,Statutory,Imprest,Employee;
        }
        field(61; "Frequency"; Decimal)
        {
            MinValue = 1;
        }
        field(62; "Travel Expense Type"; Option)
        {
            OptionMembers = " ","Accomodation","Incidental/Other Expenses","Perdiem/Meal Allowance";
            OptionCaption = ' ,Accomodation,Incidentl/Other Expenses,Perdiem/Meal Allowance';
        }
        field(80; Accounted; Boolean)
        {
        }
        field(81; Reversed; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No", "WorkPlan No", "Budget Code", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Account No", "WorkPlan No", "WorkPlan Entry No", "Budget Code", "Document Type")
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
    }

    var
        DimVal: Record "Dimension Value";
        AccHeader: Record "Accountability Header";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        DimMgt: Codeunit DimensionManagement;
        PurchLine: Record "Purchase Line";

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No", "Line No"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";
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


}