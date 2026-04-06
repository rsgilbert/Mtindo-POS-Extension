table 50012 "Payment Req Line Archive"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Payment Req Lines Archives";

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
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
            trigger OnValidate()
            var
                WorkPlanLne: Record "WorkPlan Line";
            begin
                WorkPlanLne.SetRange("WorkPlan No", "WorkPlan No");
                WorkPlanLne.SetRange("Entry No", "WorkPlan Entry No");
                if WorkPlanLne.FindFirst() then begin
                    Validate("Account No", WorkPlanLne."Account No");
                    Validate(Description, WorkPlanLne.Description);
                    Validate("Shortcut Dimension 1 Code", WorkPlanLne."Global Dimension 1 Code");
                    Validate("Shortcut Dimension 2 Code", WorkPlanLne."Global Dimension 2 Code");
                    Validate("Dimension Set ID", WorkPlanLne."Dimension Set ID");
                end;
            end;

            trigger OnLookup()
            var
                WorkPlanEntry: Page "WorkPlan Entry";
                WorkPlanLne: Record "WorkPlan Line";
            begin
                if "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer] then begin
                    WorkPlanLne.SetRange("WorkPlan No", "WorkPlan No");
                    WorkPlanLne.SetRange("Budget Code", "Budget Code");
                    if WorkPlanLne.FindFirst() then begin
                        WorkPlanEntry.SetTableView(WorkPlanLne);
                        WorkPlanEntry.SetRecord(WorkPlanLne);
                        WorkPlanEntry.LookupMode(true);
                        if WorkPlanEntry.RunModal() = Action::OK then begin
                            WorkPlanEntry.GetRecord(WorkPlanLne);
                            Validate("WorkPlan Entry No", WorkPlanLne."Entry No");
                            "Account Name" := WorkPlanLne."Account Name";
                        end;
                    end
                    else
                        Error('The Cost center specified in the header or the No %1 does not exist on your work plan');
                end
                else
                    if
                   "Account Type" IN ["Account Type"::Vendor, "Account Type"::"Bank Account"] then
                        ERROR('Work plan Entry No. is not applicable for %1 account type', "Account Type");
            end;
        }
        field(6; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","G/L Account",Vendor,"Bank Account",Customer;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."Account Type" <> xRec."Account Type" then begin
                    Clear("Account No");
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
                    Clear("WHT Amount");
                    Clear("WHT Code");
                    Clear("WHT on VAT Amount");
                    Clear("WHT Percentage");
                end;

            end;
        }
        field(8; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
                    Clear("WHT Amount");
                    Clear("WHT Code");
                    Clear("WHT on VAT Amount");
                    Clear("WHT Percentage");
                end;

                If CustRec.GET("Account No") then
                    "Account Name" := CustRec.Name;

                IF VendorRec.GET("Account No") then begin
                    "Account Name" := VendorRec.Name;
                    "WHT Code" := VendorRec."WHT Posting Group";
                end;

                IF GLAccRec.GET("Account No") then
                    "Account Name" := GLAccRec.Name;

                IF BankRec.GET("Account No") then
                    "Account Name" := BankRec.Name;
            end;
        }
        field(9; "Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            OptionMembers = Invoice;
        }
        field(23; "Applies-To-DocNo"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Applies-To-ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Commitment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Available To Spend"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "WHT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "WHT Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "WHT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
            Editable = false;

            trigger OnValidate()
            begin
                Validate("Amount to Account", "Amount Paid");
            end;
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
        field(43; "WHT on VAT Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44; "Amount To Pay (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "WHT Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Archive No"; Code[20])
        {
            DataClassification = ToBeClassified;
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
            trigger OnValidate()
            begin
                Validate(Amount, Quantity * Rate * Frequency);
            end;
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

        field(82; "Amount to Account"; Decimal)
        {
            Caption = 'Amount to Account';
            MinValue = 0;

            trigger OnValidate()
            begin
                if (Rec."Amount to Account" + Rec."Amount Accounted") > Rec."Amount Paid" then
                    Error('Amount to account (%1) plus amount accounted (%2) cannot be greater than amount paid (%3).', Format(Rec."Amount to Account"), Format(rec."Amount Accounted"), Format(Rec."Amount Paid"));

                Validate("Amount to Account (LCY)", CurrencyConversion("Amount to Account"));
            end;
        }
        field(83; "Amount to Account (LCY)"; Decimal)
        {
            Caption = 'Amount to Account (LCY)';
            MinValue = 0;
        }
        field(84; "Amount Accounted"; Decimal)
        {
            Caption = 'Amount Accounted';
            trigger OnValidate()
            begin
                Validate("Acc. Remaining Amount", ("Amount Paid" - "Amount Accounted"));
                Validate("Amount Accounted (LCY)", CurrencyConversion("Amount Accounted"));
            end;
        }
        field(85; "Amount Accounted (LCY)"; Decimal)
        {
            Caption = 'Amount Accounted (LCY)';
        }
        field(86; "Acc. Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            trigger OnValidate()
            begin
                Validate("Acc. Remaining Amount (LCY)", CurrencyConversion("Acc. Remaining Amount"));
            end;
        }
        field(87; "Acc. Remaining Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)';
        }
        field(88; "Amount to Convert"; Decimal)
        {
            Caption = 'Amount to Convert';
            AutoFormatType = 1;
            CalcFormula = sum("Accountability Specifications".Amount where("Document No" = field("Document No"), "Originating Line No" = field("Line No")));
            FieldClass = FlowField;
        }

        field(50000; "System Id"; Guid) { }


    }

    keys
    {
        key(Key1; "Document Type", "Archive No", "WorkPlan No", "Budget Code", "Payee Type", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Account No", "WorkPlan No", "WorkPlan Entry No", "Budget Code", "Document Type")
        {

        }
        key(SIFTAmountByPayee; "Document No", "Document Type")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Amount Paid", "Amount to Account";
        }
    }

    var
        DimVal: Record "Dimension Value";
        PayHeader: Record "Payment Req. Header Archive";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        DimMgt: Codeunit DimensionManagement;

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
        //OnBeforeShowDimensions(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No", "Line No"));
        //VerifyItemLineDim();
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";

    end;

    procedure GetPaymentHeader()
    var
        IsHandled: Boolean;
    begin
        TestField("Document No");
        if ("Document Type" <> PayHeader."Document Type") or ("Document No" <> PayHeader."No.") then begin
            PayHeader.Get("Document No");
            if PayHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                PayHeader.TestField("Currency Factor");
                Currency.Get(PayHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    procedure UpdateRate()
    var
        PayHeader2: Record "Payment Req. Header Archive";
    begin
        PayHeader2.Get("Document No");
        IF PayHeader2."Currency Code" <> '' THEN BEGIN
            PayHeader2.TESTFIELD("Currency Factor");
            "Rate (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                GetDate, PayHeader2."Currency Code",
                Rate, PayHeader2."Currency Factor");
        END ELSE
            "Rate (LCY)" := Rate;
    end;

    procedure GetDate(): Date
    var
        myInt: Integer;
    begin
        if PayHeader."Posting Date" <> 0D then
            exit(PayHeader."Posting Date")
        else
            exit(WorkDate());
    end;

    procedure CurrencyConversion(ParaAmount: Decimal): Decimal
    var
        PayHeader2: Record "Payment Req. Header Archive";
        CurrExchRate: Record "Currency Exchange Rate";
        lvRate: Decimal;
    begin
        PayHeader2.SetRange("Document Type", Rec."Document Type");
        PayHeader2.SetRange("No.", Rec."Document No");
        if PayHeader2.FindFirst() then
            IF PayHeader2."Currency Code" <> '' THEN BEGIN
                PayHeader2.TESTFIELD("Currency Factor");
                lvRate :=
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    Rec.GetDate, PayHeader2."Currency Code",
                    ParaAmount, PayHeader2."Currency Factor");
            END ELSE
                lvRate := ParaAmount;
        exit(lvRate);
    end;


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

}