table 50010 "Payment Requisition Line"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Payment Requistion Lines";

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            //OptionMembers = "Purchase Requisition","Purchase Order","Purchase Invoice","Prepayment Invoice","Payment Requisition";
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(4; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No.";
        }
        field(5; "WorkPlan Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                WorkPlanLne: Record "WorkPlan Line";
            begin
                TestReqStatus();
                TestField("WorkPlan No");
                WorkPlanLne.SetRange("WorkPlan No", "WorkPlan No");
                WorkPlanLne.SetRange("Budget Code", "Budget Code");
                WorkPlanLne.SetRange("Entry No", "WorkPlan Entry No");
                if "Account No" <> '' then
                    WorkPlanLne.SetRange("Account No", "Account No");
                if WorkPlanLne.FindFirst() then
                    ApplyWorkPlanLineSelection(WorkPlanLne)
                else begin
                    if "Account No" = '' then
                        Error('Workplan Entry Number %1 does not exist on work plan %2.', "WorkPlan Entry No", "WorkPlan No");

                    Error('Workplan Entry Number %1 is not associated with budget line account No. %2.', "WorkPlan Entry No", "Account No");
                end;
            end;

            trigger OnLookup()
            var
                WorkPlanEntry: Page "Budget Entries";
                WorkPlanLne: Record "WorkPlan Line";
            begin
                if "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer] then begin
                    TestField("WorkPlan No");
                    WorkPlanLne.SetRange("WorkPlan No", "WorkPlan No");
                    WorkPlanLne.SetRange("Budget Code", "Budget Code");
                    if "Account No" <> '' then
                        WorkPlanLne.SetRange("Account No", "Account No");
                    if WorkPlanLne.FindFirst() then begin
                        WorkPlanEntry.SetTableView(WorkPlanLne);
                        WorkPlanEntry.SetRecord(WorkPlanLne);
                        WorkPlanEntry.LookupMode(true);
                        if WorkPlanEntry.RunModal() = Action::LookupOK then begin
                            WorkPlanEntry.GetRecord(WorkPlanLne);
                            ApplyWorkPlanLineSelection(WorkPlanLne);
                        end;
                    end
                    else begin
                        if "Account No" = '' then
                            Error('There are no budget entries on work plan %1.', "WorkPlan No");

                        Error('Account No %1 does not exist on your work plan %2', "Account No", "WorkPlan No");
                    end;
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
                lvPaymentHeader: Record "Payment Requisition Header";
            begin
                TestReqStatus();
                lvPaymentHeader.SetRange("Document Type", "Document Type");
                lvPaymentHeader.SetRange("No.", "Document No");
                if lvPaymentHeader.FindFirst() then
                    case lvPaymentHeader."Payee Type" of
                        lvPaymentHeader."Payee Type"::Vendor:
                            if "Account Type" <> Rec."Account Type"::Vendor then
                                Error('Account Type must only be Vendor for Payment Type %1', lvPaymentHeader."Payment Category");
                        lvPaymentHeader."Payee Type"::Bank:
                            if "Account Type" <> Rec."Account Type"::"Bank Account" then
                                Error('Account Type must only be Bank Account for Payment Type %1', lvPaymentHeader."Payment Category");
                        lvPaymentHeader."Payee Type"::Customer:
                            if "Account Type" <> Rec."Account Type"::Customer then
                                Error('Account Type must only be Customer for Payment Type %1', lvPaymentHeader."Payment Category");
                        else
                            if "Account Type" <> Rec."Account Type"::"G/L Account" then
                                Error('Account Type must be G/L Account for Payment Category %1', lvPaymentHeader."Payment Category");
                    end;
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
            //Editable = false;
            TableRelation = IF ("Account Type" = filter("G/L Account")) "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting), "Direct Posting" = const(true))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor where(Blocked = const(" "))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer where(Blocked = const(" "))
            else
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" where(Blocked = const(false));
            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
                GLAccRec: Record "G/L Account";
                BankRec: Record "Bank Account";
                EmployeeLedger: Record "Employee Ledger Entry";
                WorkPlanLine: Record "WorkPlan Line";
            begin
                TestReqStatus();
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

                IF GLAccRec.GET("Account No") then begin
                    "Account Name" := GLAccRec.Name;
                    GLAccRec.TestField("Direct Posting", true);
                    Rec."Travel Expense Type" := GLAccRec."Travel Expense Type";
                end;
                IF BankRec.GET("Account No") then
                    "Account Name" := BankRec.Name;

                if ("Account Type" = "Account Type"::"G/L Account") and ("WorkPlan No" <> '') and ("Account No" <> '') then begin
                    WorkPlanLine.SetRange("WorkPlan No", "WorkPlan No");
                    WorkPlanLine.SetRange("Budget Code", "Budget Code");
                    WorkPlanLine.SetRange("Account No", "Account No");
                    if not WorkPlanLine.FindFirst() then
                        Error('Account No %1 does not exist on work plan %2. Select a valid work plan budget line.', "Account No", "WorkPlan No");

                    if WorkPlanLine.Count = 1 then
                        Validate("WorkPlan Entry No", WorkPlanLine."Entry No");
                end;
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
                TestReqStatus();
            end;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                BudgetContSetup: Record "Budget Control Setup";
                LinePendingAmountLCY: Decimal;
                PaymentLine: Record "Payment Requisition Line";
            begin
                TestReqStatus();
                BudgetContSetup.Get();
                GetPaymentHeader();
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
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Amount To Pay" > (Amount - "Amount Paid") then
                    Error('The amount to pay %1 must not be greater than the difference between the Amount %2 and Amount paid %3.', "Amount To Pay", Amount, "Amount Paid");
                Validate("Amount To Pay (LCY)", 1 * CurrencyConversion("Amount To Pay"));
            end;
        }
        field(33; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            var
            begin
                if "Amount Paid" > "Amount" then
                    Error('Amount Paid cannot be greater than the Amount LCY for line %1, document number %2', "Line No", "Document No");
                "Outstanding Amount (LCY)" := "Amount (LCY)" - 1 * CurrencyConversion("Amount Paid");
                Validate("Amount Paid (LCY)", CurrencyConversion("Amount Paid"));
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
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestReqStatus();
                GetPaymentHeader();
                UpdateRate();
                Validate(Amount, Quantity * Rate * Frequency);
            end;
        }
        field(37; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate(Frequency, 1);
                TestReqStatus();
                Validate(Amount, Quantity * Rate * Frequency);
            end;
        }
        field(40; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                BudgetContSetup: Record "Budget Control Setup";
                LinePendingAmountLCY: Decimal;
                PaymentLine: Record "Payment Requisition Line";
            begin
                if "Account Type" IN ["Account Type"::Customer, "Account Type"::"G/L Account"] then begin
                    //Budget Check ======================================
                    if Rec."WorkPlan No" <> '' then begin
                        PaymentLine.SetRange("Document No", "Document No");
                        PaymentLine.SetFilter("Line No", '<>%1', "Line No");
                        PaymentLine.SetRange("WorkPlan Entry No", "WorkPlan Entry No");
                        if PaymentLine.FindSet() then
                            repeat
                                LinePendingAmountLCY += PaymentLine."Amount (LCY)";
                            until PaymentLine.Next() = 0;
                        BudgetContSetup.CheckBudget("WorkPlan No", "WorkPlan Entry No", "Budget Code", "Amount (LCY)", LinePendingAmountLCY);
                    end;
                    //===================================================
                end;
                "Outstanding Amount (LCY)" := "Amount (LCY)" - 1 * CurrencyConversion("Amount Paid");
            end;
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
        field(46; "Period ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "No of Installments"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Activity Description"; Text[100])
        {
            Editable = false;
        }
        field(52; "Running Balance"; Decimal)
        {
            Editable = false;
        }
        field(56; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            Editable = false;
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
        field(50045; "G/L CPontrol Acc"; Code[20])
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
        key(Key2; "Account No", "WorkPlan No", "WorkPlan Entry No", "Budget Code", Status)
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
    }

    var
        DimVal: Record "Dimension Value";
        PayHeader: Record "Payment Requisition Header";
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

    procedure ShowDimensions(addNew: Boolean) IsChanged: Boolean
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

        //OnAfterShowDimensions(Rec, xRec);
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Document No"));
    end;

    procedure GetPaymentHeader()
    var
    begin
        TestField("Document No");
        if ("Document Type" <> PayHeader."Document Type") or ("Document No" <> PayHeader."No.") then begin
            PayHeader.Get("Document No");
            if PayHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision()
            else begin
                PayHeader.TestField("Currency Factor");
                Currency.Get(PayHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
        //OutPayHeader := PayHeader;
        //OutCurrency := Currency;
    end;

    procedure UpdateRate()
    var
        PayHeader2: Record "Payment Requisition Header";
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
        //"Amount (LCY)" := Quantity * "Rate (LCY)";
    end;

    procedure GetDate(): Date
    var
    begin
        if PayHeader."Posting Date" <> 0D then
            exit(PayHeader."Posting Date")
        else
            exit(WorkDate());
    end;

    procedure CurrencyConversion(ParaAmount: Decimal): Decimal
    var
        PayHeader2: Record "Payment Requisition Header";
        CurrExchRate: Record "Currency Exchange Rate";
        lvRate: Decimal;
        lvCurrencyFactor: Decimal;
    begin
        Clear(lvCurrencyFactor);
        if ParaAmount > 0 then begin
            PayHeader2.SetRange("Document Type", Rec."Document Type");
            PayHeader2.SetRange("No.", Rec."Document No");
            if PayHeader2.FindFirst() then begin
                IF PayHeader2."Currency Code" <> '' THEN BEGIN
                    PayHeader2.TESTFIELD("Currency Factor");
                    if Rec."Currency Factor" = 0 then
                        lvCurrencyFactor := PayHeader2."Currency Factor"
                    else
                        lvCurrencyFactor := Rec."Currency Factor";
                    lvRate :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        Rec.GetDate, PayHeader2."Currency Code",
                        ParaAmount, lvCurrencyFactor);
                END ELSE
                    lvRate := ParaAmount;
                exit(lvRate);
            end;
        end;
    end;

    procedure CurrencyConversionAtApplication(Curr: Code[20]; ParaAmount: Decimal): Decimal
    var
        PayHeader2: Record "Payment Requisition Header";
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

    procedure ApplyVendEntries()
    var
        Text000: Label 'You must specify %1 or %2.';
        GenJournalLineTemp: Record "Gen. Journal Line" temporary;
        GenPayment: Record "Gen. Requisition Setup";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry_Apply: Record "Vendor Ledger Entry";
        PayHeader: Record "Payment Requisition Header";
        PayHeader2: Record "Payment Requisition Header";
        ApplyVendEntries: Page "Apply Vendor Entries";
        CurrExchRate: Record "Currency Exchange Rate";
        totalAppliedAmount: Decimal;
        totalWHT: Decimal;
        totalWHTOnVAT: Decimal;
        lvRate: Decimal;
        totalVAT: Decimal;
        Selected: Boolean;

    begin
        if Rec."Account Type" = Rec."Account Type"::Vendor then begin
            PayHeader.Get(Rec."Document No");
            GenJournalLineTemp.Init();
            GenJournalLineTemp."Journal Template Name" := GenPayment."Requisition Journal Template";
            GenJournalLineTemp."Journal Batch Name" := GenPayment."Req Journal Batch";
            GenJournalLineTemp."Line No." := Rec."Line No";
            GenJournalLineTemp."Document No." := Rec."Document No";
            GenJournalLineTemp."Account Type" := GenJournalLineTemp."Account Type"::Vendor;
            GenJournalLineTemp.Validate("Account No.", Rec."Account No");
            GenJournalLineTemp.Description := Rec.Description;
            if PayHeader."Posting Date" <> 0D then
                GenJournalLineTemp."Posting Date" := PayHeader."Posting Date"
            else
                GenJournalLineTemp."Posting Date" := PayHeader."Document Date";
            GenJournalLineTemp."Document Type" := GenJournalLineTemp."Document Type"::Payment;
            GenJournalLineTemp.Insert();

            VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
            VendLedgEntry.SetRange("Vendor No.", Rec."Account No");
            VendLedgEntry.SetRange(Open, true);
            //VendLedgEntry.SetRange("Global Dimension 1 Code", PayHeader."Global Dimension 1 Code");
            if GenJournalLineTemp."Applies-to ID" = '' then
                GenJournalLineTemp."Applies-to ID" := GenJournalLineTemp."Document No.";
            if GenJournalLineTemp."Applies-to ID" = '' then
                Error(
                  Text000,
                  GenJournalLineTemp.FieldCaption("Document No."), GenJournalLineTemp.FieldCaption("Applies-to ID"));
            ApplyVendEntries.SetGenJnlLine(GenJournalLineTemp, GenJournalLineTemp.FieldNo("Applies-to ID"));
            ApplyVendEntries.SetRecord(VendLedgEntry);
            ApplyVendEntries.SetTableView(VendLedgEntry);
            ApplyVendEntries.LookupMode(true);
            Selected := ApplyVendEntries.RunModal = ACTION::LookupOK;
            Clear(ApplyVendEntries);

            if Selected then begin
                VendLedgEntry_Apply.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                VendLedgEntry_Apply.SetRange("Vendor No.", Rec."Account No");
                VendLedgEntry_Apply.SetRange("Applies-to ID", Rec."Document No");
                VendLedgEntry_Apply.SetRange(Open, true);
                if VendLedgEntry_Apply.FindSet() then
                    repeat
                        if PayHeader."Currency Code" <> VendLedgEntry_Apply."Currency Code" then begin

                            totalAppliedAmount += CurrExchRate.ExchangeAmount(VendLedgEntry_Apply."Amount to Apply", VendLedgEntry_Apply."Currency Code", PayHeader."Currency Code", GenJournalLineTemp."Posting Date");
                            totalWHT += CurrExchRate.ExchangeAmount(VendLedgEntry_Apply."WHT Amount", VendLedgEntry_Apply."Currency Code", PayHeader."Currency Code", GenJournalLineTemp."Posting Date");
                            totalWHTOnVAT += CurrExchRate.ExchangeAmount(VendLedgEntry_Apply."WHT on VAT Amount", VendLedgEntry_Apply."Currency Code", PayHeader."Currency Code", GenJournalLineTemp."Posting Date");
                        end
                        else begin
                            totalAppliedAmount += VendLedgEntry_Apply."Amount to Apply";
                            totalWHT += VendLedgEntry_Apply."WHT Amount";
                            totalWHTOnVAT += VendLedgEntry_Apply."WHT on VAT Amount";
                        end;
                        if VendLedgEntry_Apply."Dimension Set ID" <> 0 then
                            Rec.validate("Dimension Set ID", VendLedgEntry_Apply."Dimension Set ID")
                        else begin
                            Rec.validate("Shortcut Dimension 1 Code", VendLedgEntry_Apply."Global Dimension 1 Code");
                            Rec.validate("Shortcut Dimension 2 Code", VendLedgEntry_Apply."Global Dimension 2 Code");
                        end;
                        Rec.Modify();
                    until VendLedgEntry_Apply.Next() = 0;

            end;
            if Selected then begin
                Rec.Rate := ABS(totalAppliedAmount);
                Rec.Amount := ABS(totalAppliedAmount) - totalWHT - totalWHTOnVAT;
                Rec."Amount To Pay" := Rec.Amount;
                Rec."WHT Amount" := totalWHT;
                Rec."WHT on VAT Amount" := totalWHTOnVAT;
                Rec."Amount (LCY)" := 1 * Rec.CurrencyConversion(Rec.Amount);
                Rec."Amount To Pay (LCY)" := 1 * Rec.CurrencyConversion(Rec."Amount To Pay");
                Rec."WHT Amount (LCY)" := 1 * Rec.CurrencyConversion(Rec."WHT Amount");
                Rec."WHT on VAT Amount (LCY)" := 1 * Rec.CurrencyConversion(Rec."WHT on VAT Amount");
                Rec.Validate("Amount (LCY)");
            end;

        end;
    end;

    procedure ClearAppliedVendEntries()
    var
        VendLedgEntry_Apply: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry_Apply.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
        VendLedgEntry_Apply.SetRange("Vendor No.", Rec."Account No");
        VendLedgEntry_Apply.SetRange("Applies-to ID", Rec."Document No");
        VendLedgEntry_Apply.SetRange(Open, true);
        if VendLedgEntry_Apply.FindSet() then
            repeat
                VendLedgEntry_Apply.Validate("Amount to Apply", 0);
                VendLedgEntry_Apply.Validate("Applies-to ID", '');
                VendLedgEntry_Apply.Modify();
            until VendLedgEntry_Apply.Next() = 0;
    end;

    procedure CheckLineChanges()
    var
        lvHeader: Record "Payment Requisition Header";
    begin

    end;

    procedure BudgetCheck(LineAmount: Decimal; LineNo: Integer)
    var
        Text001: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual Exps= %4\\Total Commit=%5\\Line Amount=%6\\Available Funds=%7';
        Text002: Label 'There is no budget that was allocated for this line';
        WorkPlanLine: Record "WorkPlan Line";
        PaymentLine: Record "Payment Requisition Line";
        PendingLineAmount: Decimal;
        lvBudgetControlSetup: Record "Budget Control Setup";
    begin
        lvBudgetControlSetup.Get();
        //Calculating Pending Amount Per Work Plan Entry
        PaymentLine.SetRange("Document Type", "Document Type");
        PaymentLine.SetRange("Document No", "Document No");
        PaymentLine.SetRange("WorkPlan Entry No", "WorkPlan Entry No");
        PaymentLine.SetFilter("Line No", '<>%1', LineNo);
        IF PaymentLine.FindSet() then
            repeat
                PendingLineAmount += PaymentLine."Amount (LCY)";
            until PaymentLine.Next() = 0;

        //Line Budget check based on the workplan number and workplan entry number.
        lvBudgetControlSetup.CheckBudget("WorkPlan No", "WorkPlan Entry No", "Budget Code", LineAmount, PendingLineAmount);

    end;

    trigger OnInsert()
    var
        PaymentReqHeader: Record "Payment Requisition Header";
    begin
        Rec."System Id" := System.CreateGuid();
        PaymentReqHeader.SetRange("No.", "Document No");
        PaymentReqHeader.SetRange("Document Type", "Document Type");
        if PaymentReqHeader.FindSet() then begin
            Rec.Validate("WorkPlan No", PaymentReqHeader."WorkPlan No");
            Rec.Validate("Budget Code", PaymentReqHeader."Budget Code");
            Rec."Payee Type" := PaymentReqHeader."Payee Type";
            Rec."Currency Code" := PaymentReqHeader."Currency Code";
            Rec."Currency Factor" := PaymentReqHeader."Currency Factor";
        end;
        Rec.Frequency := 1;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        ClearAppliedVendEntries();
    end;

    trigger OnRename()
    begin

    end;

    procedure TestReqStatus()
    var
        lvPaymentReqHeader: Record "Payment Requisition Header";
    begin
        lvPaymentReqHeader.Reset();
        lvPaymentReqHeader.SetRange("No.", "Document No");
        if lvPaymentReqHeader.FindFirst() then
            lvPaymentReqHeader.TestField(Status, lvPaymentReqHeader.Status::Open);
    end;

    local procedure ApplyWorkPlanLineSelection(var WorkPlanLne: Record "WorkPlan Line")
    var
        BudControlSetup: Record "Budget Control Setup";
        GLAccRec: Record "G/L Account";
    begin
        BudControlSetup.Get();
        "WorkPlan Entry No" := WorkPlanLne."Entry No";
        "Account No" := WorkPlanLne."Account No";
        "Account Name" := WorkPlanLne."Account Name";
        if ("Account Type" = "Account Type"::"G/L Account") and GLAccRec.Get("Account No") then
            Rec."Travel Expense Type" := GLAccRec."Travel Expense Type";
        Validate("Shortcut Dimension 1 Code", WorkPlanLne."Global Dimension 1 Code");
        Validate("Shortcut Dimension 2 Code", WorkPlanLne."Global Dimension 2 Code");
        Validate("Dimension Set ID", WorkPlanLne."Dimension Set ID");
        "Activity Description" := WorkPlanLne.Description;
        WorkPlanLne.CalcFields(Actuals);
        "Running Balance" := BudControlSetup.CheckBudget("WorkPlan No", "WorkPlan Entry No", "Budget Code", 0, 0);
    end;

}
