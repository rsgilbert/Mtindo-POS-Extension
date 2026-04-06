table 50019 "Accountability Line"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Accountability Lines";

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

                    if not Rec."Generated From PR" then
                        if "Account Type" <> "Account Type"::"Bank Account" then
                            Error('The account type can only be Bank Account for the new line.');
                end;

            end;
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
            trigger OnValidate()
            begin
                TestAccountabilityStatus;
            end;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //GetPaymentHeader();
                UpdateRate();
                Validate("Amount To Pay", Amount);
                Validate("Amount (LCY)", 1 * CurrencyConversion(Amount));
                Validate("Amount To Pay (LCY)", 1 * CurrencyConversion("Amount To Pay"));
            end;
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

        field(20; "Currency Code"; Code[10])
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
        field(25; "Commitment Entry No"; Integer)
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
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestAccountabilityStatus();
                if "Generated From PR" then
                    if "Amount To Pay" > (Amount - "Amount Paid") then
                        Error('The amount to pay %1 must not be greater than the difference between the Amount %2 and Amount paid %3.', "Amount To Pay", Amount, "Amount Paid");
                Validate("Amount To Pay (LCY)", 1 * CurrencyConversion("Amount To Pay"));
            end;
        }
        field(33; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            // Editable = false;
            trigger OnValidate()
            var
            begin
                if "Generated From PR" then
                    if "Amount Paid" > "Amount" then
                        Error('Amount Paid cannot be greater than the Amount LCY for line %1, document number %2', "Line No", "Document No");
                "Amount Paid (LCY)" := CurrencyConversion("Amount Paid");
                "Outstanding Amount (LCY)" := "Amount (LCY)";
            end;
        }
        field(36; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                GetAccountabilityHeader();
                UpdateRate();
                Validate(Amount, Quantity * Rate);
            end;
        }
        field(37; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate(Amount, Quantity * Rate);
            end;
        }
        field(40; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                "Outstanding Amount (LCY)" := "Amount (LCY)";
            end;
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
        field(80; Posted; Boolean)
        {
        }
        field(50000; "System Id"; Guid) { }
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

    procedure GetAccountabilityHeader()
    var
        IsHandled: Boolean;
    begin
        TestField("Document No");
        if ("Document Type" <> AccHeader."Document Type") or ("Document No" <> AccHeader."No.") then begin
            AccHeader.Get("Document No");
            if AccHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                AccHeader.TestField("Currency Factor");
                Currency.Get(AccHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
        //OutPayHeader := PayHeader;
        //OutCurrency := Currency;
    end;

    procedure UpdateRate()
    var
        AccHeader2: Record "Accountability Header";
    begin

        AccHeader2.Get("Document No");
        IF AccHeader2."Currency Code" <> '' THEN BEGIN
            AccHeader2.TESTFIELD("Currency Factor");
            "Rate (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                GetDate, AccHeader2."Currency Code",
                Rate, AccHeader2."Currency Factor");
        END ELSE
            "Rate (LCY)" := Rate;

        //"Amount (LCY)" := Quantity * "Rate (LCY)";

    end;

    procedure GetDate(): Date
    var
        myInt: Integer;
    begin
        if AccHeader."Posting Date" <> 0D then
            exit(AccHeader."Posting Date")
        else
            exit(WorkDate());
    end;

    procedure CurrencyConversion(ParaAmount: Decimal): Decimal
    var
        PayHeader2: Record "Accountability Header";
        CurrExchRate: Record "Currency Exchange Rate";
        lvRate: Decimal;
    begin
        PayHeader2.Get(Rec."Document No");
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

    procedure CurrencyConversionAtApplication(Curr: Code[20]; ParaAmount: Decimal): Decimal
    var
        AccHeader2: Record "Accountability Header";
        CurrExchRate: Record "Currency Exchange Rate";
        lvRate: Decimal;
    begin
        AccHeader2.Get(Rec."Document No");
        IF AccHeader2."Currency Code" <> '' THEN BEGIN
            AccHeader2.TESTFIELD("Currency Factor");
            lvRate :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                Rec.GetDate, AccHeader2."Currency Code",
                ParaAmount, AccHeader2."Currency Factor");
        END ELSE
            lvRate := ParaAmount;
        exit(lvRate);
    end;

    procedure ApplyCustEntries()
    var
        Text000: Label 'You must specify %1 or %2.';
        GenJournalLineTemp: Record "Gen. Journal Line" temporary;
        GenPayment: Record "Gen. Requisition Setup";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry_Apply: Record "Cust. Ledger Entry";
        PayHeader: Record "Accountability Header";
        PayHeader2: Record "Accountability Header";
        ApplyCustEntries: Page "Apply Customer Entries";
        CurrExchRate: Record "Currency Exchange Rate";
        totalAppliedAmount: Decimal;
        totalWHT: Decimal;
        totalWHTOnVAT: Decimal;
        lvRate: Decimal;
        totalVAT: Decimal;
        Selected: Boolean;

    begin
        TestAccountabilityStatus();
        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
            PayHeader.Get(Rec."Document No");
            GenJournalLineTemp.Init();
            GenJournalLineTemp."Journal Template Name" := GenPayment."Requisition Journal Template";
            GenJournalLineTemp."Journal Batch Name" := GenPayment."Req Journal Batch";
            GenJournalLineTemp."Line No." := Rec."Line No";
            GenJournalLineTemp."Document No." := Rec."Document No";
            GenJournalLineTemp."Account Type" := GenJournalLineTemp."Account Type"::Customer;
            GenJournalLineTemp.Validate("Account No.", PayHeader."Payee No");
            GenJournalLineTemp.Description := Rec.Description;
            if PayHeader."Posting Date" <> 0D then
                GenJournalLineTemp."Posting Date" := PayHeader."Posting Date"
            else
                GenJournalLineTemp."Posting Date" := PayHeader."Document Date";
            GenJournalLineTemp."Document Type" := GenJournalLineTemp."Document Type"::" ";
            GenJournalLineTemp.Insert();

            CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
            CustLedgEntry.SetRange("Customer No.", PayHeader."Payee No");
            CustLedgEntry.SetRange(Open, true);
            CustLedgEntry.SetRange("Global Dimension 1 Code", PayHeader."Global Dimension 1 Code");
            if GenJournalLineTemp."Applies-to ID" = '' then
                GenJournalLineTemp."Applies-to ID" := GenJournalLineTemp."Document No.";
            if GenJournalLineTemp."Applies-to ID" = '' then
                Error(
                  Text000,
                  GenJournalLineTemp.FieldCaption("Document No."), GenJournalLineTemp.FieldCaption("Applies-to ID"));
            ApplyCustEntries.SetGenJnlLine(GenJournalLineTemp, GenJournalLineTemp.FieldNo("Applies-to ID"));
            ApplyCustEntries.SetRecord(CustLedgEntry);
            ApplyCustEntries.SetTableView(CustLedgEntry);
            ApplyCustEntries.LookupMode(true);
            Selected := ApplyCustEntries.RunModal = ACTION::LookupOK;
            Clear(ApplyCustEntries);

            if Selected then begin
                CustLedgEntry_Apply.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                CustLedgEntry_Apply.SetRange("Customer No.", PayHeader."Payee No");
                CustLedgEntry_Apply.SetRange("Applies-to ID", Rec."Document No");
                CustLedgEntry_Apply.SetRange(Open, true);
                if CustLedgEntry_Apply.FindSet() then
                    repeat
                        if PayHeader."Currency Code" <> CustLedgEntry_Apply."Currency Code" then begin

                            totalAppliedAmount += CurrExchRate.ExchangeAmount(CustLedgEntry_Apply."Amount to Apply", CustLedgEntry_Apply."Currency Code", PayHeader."Currency Code", GenJournalLineTemp."Posting Date");
                        end
                        else
                            totalAppliedAmount += CustLedgEntry_Apply."Amount to Apply";
                    until CustLedgEntry_Apply.Next() = 0;

            end;
            if Selected then begin
                //Rec.Rate := ABS(totalAppliedAmount);
                //Rec.Amount := ABS(totalAppliedAmount) - totalWHT - totalWHTOnVAT;
                Rec."Amount To Pay" := ABS(totalAppliedAmount);
                //Rec."Amount (LCY)" := 1 * Rec.CurrencyConversion(Rec.Amount);
                Rec."Amount To Pay (LCY)" := 1 * Rec.CurrencyConversion(Rec."Amount To Pay");
            end;

        end;
    end;

    procedure ClearAppliedCustEntries()
    var
        CustLedgEntry_Apply: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry_Apply.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
        CustLedgEntry_Apply.SetRange("Customer No.", Rec."Account No");
        CustLedgEntry_Apply.SetRange("Applies-to ID", Rec."Document No");
        CustLedgEntry_Apply.SetRange(Open, true);
        if CustLedgEntry_Apply.FindSet() then
            repeat
                CustLedgEntry_Apply.Validate("Amount to Apply", 0);
                CustLedgEntry_Apply.Validate("Applies-to ID", '');
                CustLedgEntry_Apply.Modify();
            until CustLedgEntry_Apply.Next() = 0;
    end;

    procedure CheckLineChanges()
    var
        lvHeader: Record "Accountability Header";
    begin

    end;

    procedure BudgetCheck(LineAmount: Decimal)
    var
        Text001: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual Exps= %4\\Total Commit=%5\\Line Amount=%6\\Available Funds=%7';
        Text002: Label 'There is no budget that was allocated for this line';
        WorkPlanLine: Record "WorkPlan Line";
        PaymentLine: Record "Payment Requisition Line";
        PendingLineAmount: Decimal;
        BudgetControlSetup: Record "Budget Control Setup";
    begin
        BudgetControlSetup.Get();
        //Calculating Pending Amount Per Work Plan Entry
        PaymentLine.SetRange("Document Type", "Document Type");
        PaymentLine.SetRange("Document No", "Document No");
        PaymentLine.SetRange("WorkPlan Entry No", "WorkPlan Entry No");
        IF PaymentLine.FindSet() then
            repeat
                PendingLineAmount += PaymentLine."Amount (LCY)";
            until PaymentLine.Next() = 0;

        //Calculating Budget Amount, Actual Amount, Commitments
        BudgetControlSetup.Get();
        BudgetControlSetup.CheckBudget(PaymentLine."WorkPlan No", PaymentLine."WorkPlan Entry No", PaymentLine."Budget Code", LineAmount, PendingLineAmount)

    end;

    trigger OnInsert()
    var
        AccountabilityHeader: Record "Accountability Header";
    begin
        Rec."System Id" := System.CreateGuid();
        AccountabilityHeader.SetRange("No.", "Document No");
        if AccountabilityHeader.FindFirst() then begin
            if (AccountabilityHeader.Status = AccountabilityHeader.Status::"Pending Approval") or (AccountabilityHeader.Status = AccountabilityHeader.Status::Approved) then
                Error('You cannot create a new line because the accountability is ' + Format(AccountabilityHeader.Status) + '.');
            Rec."Currency Code" := AccountabilityHeader."Currency Code";
            Rec."Currency Factor" := AccountabilityHeader."Currency Factor";
            Rec."Applies To DocType" := Rec."Applies To DocType"::" ";
            Rec."Applies-To-DocNo" := AccountabilityHeader."PV No.";
            if Rec."Dimension Set ID" = 0 then
                Rec.validate("Dimension Set ID", AccountabilityHeader."Dimension Set ID");
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestAccountabilityStatus();
        if Rec."Generated From PR" or (Rec."Related PR Line No" <> 0) then
            Error('This line cannot be deleted since it generated from an imprest pending accountability.');
        ClearAppliedCustEntries();
    end;

    trigger OnRename()
    begin

    end;

    procedure TestAccountabilityStatus()
    var
        lvAccountbilityHeader: Record "Accountability Header";
    begin
        lvAccountbilityHeader.Reset();
        lvAccountbilityHeader.SetRange("No.", "Document No");
        if lvAccountbilityHeader.FindFirst() then
            lvAccountbilityHeader.TestField(Status, lvAccountbilityHeader.Status::Open);
    end;

}