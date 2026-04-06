table 50018 "Accountability Header"
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
        field(4; "Payment Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Type".Code;

        }
        field(5; "Payee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Vendor,Customer,Bank,Statutory,Imprest,Employee;
        }
        field(6; "Payee No"; Code[20])
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
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            DataClassification = ToBeClassified;
            //OptionMembers = "Purchase Requisition","Purchase Order","Purchase Invoice","Prepayment Invoice","Payment Requisition";
        }
        field(9; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "WorkPlan Header"."No." where("Shortcut Dimension 1 Code" = field("Global Dimension 1 Code"), Blocked = const(false), Status = const(Approved), "Transferred To Budget" = const(true));
            trigger OnValidate()
            var
                WorkPlanRec: Record "WorkPlan Header";
            begin

                if WorkPlanRec.Get("WorkPlan No") then begin
                    Validate("Global Dimension 2 Code", WorkPlanRec."Shortcut Dimension 2 Code");
                    Validate("Budget Code", WorkPlanRec."Budget Code");
                end;
            end;
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

            trigger OnValidate()
            var
                EmpRec: Record Employee;
            begin
                if EmpRec.Get("Requisitioned By") then
                    "Requestor Name" := EmpRec.FullName();
            end;
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
            CalcFormula = Sum("Accountability Line".Amount WHERE("Document No" = FIELD("No.")));
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
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
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
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            var
                StandardCodesMgt: Codeunit "Standard Codes Mgt.";
            begin
                if (xRec."Currency Code" <> '') AND (xRec."Currency Code" <> Rec."Currency Code") then
                    if not Confirm('Are you sure you would like to change the currency code ? this will update the lines', false)
                    then begin
                        Rec."Currency Code" := xRec."Currency Code";
                        exit
                    end;

                if not (CurrFieldNo in [0, FieldNo("Posting Date")]) or ("Currency Code" <> xRec."Currency Code") then
                    //TestField(Status, Status::Open);
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                        UpdateCurrencyFactor
                    else
                        if "Currency Code" <> xRec."Currency Code" then
                            UpdateCurrencyFactor
                        else
                            if "Currency Code" <> '' then begin
                                UpdateCurrencyFactor();
                                if "Currency Factor" <> xRec."Currency Factor" then
                                    ConfirmCurrencyFactorUpdate();
                            end;
            end;
        }
        field(23; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then begin
                    PaymentLine.SetRange("Document Type", "Document Type");
                    PaymentLine.SetRange("Document No", "No.");
                    if PaymentLine.FindSet() then
                        repeat
                            RecreatePaymentLines(PaymentLine);
                        until PaymentLine.Next() = 0;
                end;
            end;
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
        field(29; "Bank Account Name"; Text[50])
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
            CalcFormula = Sum("Accountability Line"."Amount To Pay" WHERE("Document No" = FIELD("No.")));
            Caption = 'Amount To Account';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Pay. Subcategory"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Subcategory".Code where("Payment Type" = field("Payment Category"), Block = const(false));
        }
        field(34; "Paid Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Accountability Line"."Amount Paid" where("Document No" = field("No.")));
            Caption = 'Accounted Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "PV Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            Editable = false;
        }
        field(37; Processed; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(38; "Bank Transfer"; Boolean)
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
        field(86; "Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }

        field(87; "Acc. Posted By"; Date)
        {
            Editable = false;
        }
        field(88; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(89; "Acc. Posted On"; Date)
        {
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

        field(93; "Accountability Due Date"; Date)
        {
            Caption = 'Accountability Due Date';
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
        field(50000; "System Id"; Guid) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        Text022: Label 'Do you want to update the exchange rate?';
        GenReqSetup: Record "Gen. Requisition Setup";
        GenLedSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentLine: Record "Payment Requisition Line";
        CurrExchRate: Record "Currency Exchange Rate";
        Purch: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        CurrencyDate: Date;
        Confirmed: Boolean;

    trigger OnInsert()
    var
        EmployeeRec: Record Employee;
    begin
        InitInsert();
        Rec."System Id" := System.CreateGuid();

        "Document Date" := Today;
        "Created By" := UserId;
        if EmployeeRec.FindFirst() then begin
            Validate("Global Dimension 1 Code", EmployeeRec."Global Dimension 1 Code");
            Validate("Requisitioned By", EmployeeRec."No.");
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        IF Confirm('Are you really sure you would like to delete this requisition ?', false) then begin
            PaymentLine.SetRange("Document No", "No.");
            if PaymentLine.FindFirst() then
                PaymentLine.DeleteAll();
        end;
    end;

    trigger OnRename()
    begin

    end;

    procedure InitInsert()
    var
        IsHandled: Boolean;
    begin
        GenReqSetup.Get();
        if "No." = '' then begin
            GenReqSetup.TestField("Accountability Nos.");
            Rec."No." := NoSeriesMgt.GetNextNo(GenReqSetup."Accountability Nos.", Today, true);
            "Accountability Posting No." := "No.";
        end;
    end;

    procedure ConfirmCurrencyFactorUpdate(): Boolean
    begin
        if not GuiAllowed then
            Confirmed := true
        else
            Confirmed := Confirm(Text022, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
        exit(Confirmed);
    end;

    procedure UpdateCurrencyFactor()
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        PaymentLine: Record "Payment Requisition Line";
        Updated: Boolean;
    begin
        if "Currency Code" <> '' then begin
            if "Posting Date" <> 0D then
                CurrencyDate := "Posting Date"
            else
                CurrencyDate := WorkDate;

            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then begin
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
                if "Currency Code" <> xRec."Currency Code" then begin
                    PaymentLine.SetRange("Document Type", "Document Type");
                    PaymentLine.SetRange("Document No", "No.");
                    if PaymentLine.FindSet() then
                        repeat
                            RecreatePaymentLines(PaymentLine);
                        until PaymentLine.Next() = 0;
                end;
            end else
                UpdateCurrencyExchangeRates.ShowMissingExchangeRatesNotification("Currency Code");
        end else begin
            Validate("Currency Factor", 0);
            if "Currency Code" <> xRec."Currency Code" then begin
                PaymentLine.SetRange("Document Type", "Document Type");
                PaymentLine.SetRange("Document No", "No.");
                if PaymentLine.FindSet() then
                    repeat
                        RecreatePaymentLines(PaymentLine);
                    until PaymentLine.Next() = 0;
            end;
        end;
    end;

    procedure RecreatePaymentLines(var PaymentLine: Record "Payment Requisition Line")
    var

    begin

        IF Rec."Currency Code" <> '' THEN BEGIN
            Rec.TESTFIELD("Currency Factor");
            PaymentLine."Rate (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                GetDate, Rec."Currency Code",
                PaymentLine.Rate, Rec."Currency Factor");
        END ELSE
            PaymentLine."Rate (LCY)" := PaymentLine.Rate;

        PaymentLine."Amount (LCY)" := PaymentLine.Quantity * PaymentLine."Rate (LCY)";

        PaymentLine.Validate("Currency Code", Rec."Currency Code");
        PaymentLine.Validate("Currency Factor", Rec."Currency Factor");
        PaymentLine.Validate(Amount);
        PaymentLine.Validate("Amount To Pay");
        PaymentLine.Modify();
    end;

    procedure GetDate(): Date
    var
        myInt: Integer;
    begin
        if Rec."Posting Date" <> 0D then
            exit(Rec."Posting Date")
        else
            exit(WorkDate());
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

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
        end;
    end;

    procedure CheckForAccountabilityLinesMandatoryFields(AccountListHeader: Record "Accountability Header")
    var
        AccLine: Record "Accountability Line";
    begin
        If AccountListHeader."WorkPlan No" <> '' then begin
            AccLine.Reset();
            AccLine.SetRange("Document Type", AccountListHeader."Document Type");
            AccLine.SetRange("Document No", AccountListHeader."No.");
            if AccLine.FindSet() then
                repeat
                    AccLine.TestField("Account No");
                    AccLine.TestField("Amount To Pay");
                until AccLine.Next() = 0;
        end;
    end;

    procedure PostAccountability()
    var
        AccountabilityLine: Record "Accountability Line";
        GenJournalTemp: Record "Gen. Journal Line";
        GenJournalTemp2: Record "Gen. Journal Line";
        PaymentSetup: Record "Gen. Requisition Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Txt000: Label 'Are you really sure you would like to post this Accountability ?';
        Txt001: Label 'Document has been posted successfully';
    begin
        SourceCodeSetup.Get();
        TestField("Bank Account No");
        //AmountAccountedForEqualToAmountToAccount(Rec);
        if GuiAllowed then
            if not Confirm(Txt000) then
                exit;
        PaymentSetup.Get();
        AccountabilityLine.SetRange("Document No", "No.");
        if AccountabilityLine.FindSet() then begin
            GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
            GenJournalTemp2.SetRange("Journal Batch Name", PaymentSetup."Req Journal Batch");
            if GenJournalTemp2.FindFirst() then
                GenJournalTemp2.DeleteAll();
            repeat
                if AccountabilityLine."Amount Paid" < (AccountabilityLine."Amount To Pay" + AccountabilityLine."Amount Paid") then begin
                    GenJournalTemp.Init();
                    GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                    GenJournalTemp."Journal Batch Name" := PaymentSetup."Req Journal Batch";
                    GenJournalTemp."Line No." := AccountabilityLine."Line No";
                    GenJournalTemp.Validate("Posting Date", "Posting Date");
                    GenJournalTemp.Validate("Document Type", GenJournalTemp."Document Type"::" ");
                    GenJournalTemp.Validate("Document No.", "Accountability Posting No.");
                    GenJournalTemp.Amount := AccountabilityLine."Amount To Pay";
                    GenJournalTemp."Amount (LCY)" := Round(AccountabilityLine."Amount To Pay (LCY)", 0.02, '>');
                    GenJournalTemp."Budget Name" := AccountabilityLine."Budget Code";
                    GenJournalTemp."Work Plan" := AccountabilityLine."WorkPlan No";
                    GenJournalTemp."Work Plan Entry No." := AccountabilityLine."WorkPlan Entry No";

                    if AccountabilityLine."Account Type" = AccountabilityLine."Account Type"::"Bank Account" then begin
                        GenJournalTemp.Validate(GenJournalTemp."Account Type", GenJournalTemp."Bal. Account Type"::"Bank Account");
                        GenJournalTemp."Account No." := AccountabilityLine."Account No";
                        GenJournalTemp."Work Plan" := AccountabilityLine."WorkPlan No";
                        GenJournalTemp."Work Plan Entry No." := AccountabilityLine."WorkPlan Entry No";
                    end
                    else
                        if AccountabilityLine."Account Type" = AccountabilityLine."Account Type"::"G/L Account" then begin
                            GenJournalTemp.Validate(GenJournalTemp."Account Type", GenJournalTemp."Bal. Account Type"::"G/L Account");
                            GenJournalTemp."Account No." := AccountabilityLine."Account No";
                            GenJournalTemp.Validate("Work Plan", AccountabilityLine."WorkPlan No");
                            GenJournalTemp.Validate("Work Plan Entry No.", AccountabilityLine."WorkPlan Entry No");
                        end;

                    GenJournalTemp.Description := AccountabilityLine.Description;
                    GenJournalTemp.Validate(GenJournalTemp."Bal. Account Type", GenJournalTemp."Account Type"::Customer);
                    GenJournalTemp."Bal. Account No." := Rec."Payee No";
                    GenJournalTemp."Currency Code" := AccountabilityLine."Currency Code";
                    GenJournalTemp."System-Created Entry" := true;
                    GenJournalTemp.validate("Currency Factor", AccountabilityLine."Currency Factor");
                    GenJournalTemp."External Document No." := "Ext Document No";

                    GenJournalTemp."Payment Requisition No." := AccountabilityLine."Related PR No";
                    GenJournalTemp."Payment Req. Line No." := AccountabilityLine."Related PR Line No";

                    if checkForAppliedDocuments(AccountabilityLine, Rec."Payee No") then
                        GenJournalTemp.Validate("Applies-to ID", Rec."Accountability Posting No.")
                    else begin
                        GenJournalTemp.Validate("Applies-to Doc. Type", AccountabilityLine."Applies To DocType");
                        GenJournalTemp.Validate("Applies-to Doc. No.", AccountabilityLine."Applies-To-DocNo");
                    end;
                    //GenJournalTemp.Validate("Work Plan", AccountabilityLine."WorkPlan No");
                    //GenJournalTemp.Validate("Work Plan Entry No.", AccountabilityLine."WorkPlan Entry No");
                    GenJournalTemp.Validate("Shortcut Dimension 1 Code", AccountabilityLine."Shortcut Dimension 1 Code");
                    GenJournalTemp.Validate("Shortcut Dimension 2 Code", AccountabilityLine."Shortcut Dimension 2 Code");
                    GenJournalTemp.Validate("Dimension Set ID", AccountabilityLine."Dimension Set ID");

                    //Assign the source code for accountability
                    if SourceCodeSetup.Accountability <> '' then
                        GenJournalTemp."Source Code" := SourceCodeSetup.Accountability;


                    GenJournalTemp.Insert(true);

                    AccountabilityLine."Amount Paid" += AccountabilityLine."Amount To Pay";
                    AccountabilityLine.Validate("Amount Paid");
                    AccountabilityLine."Amount To Pay" := 0;
                    AccountabilityLine."Amount To Pay (LCY)" := 0;

                    AccountabilityLine.Modify();
                end;


            until AccountabilityLine.Next() = 0;
            ApplyEntries(Rec);
            Rec.CalcFields("Total Amount", "Paid Amount");
            if GenJournalTemp.Amount <> 0 then
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalTemp);
            Commit();
            //Post applicaion for any unapplied entries.
            PostApplicationForUnappliedEntries(Rec);

            Rec.CalcFields("Total Amount", "Paid Amount");
            if "Paid Amount" > 0 then begin
                CreatePostedAccountabilityHeader(Rec);
                UpdateAccRemaingAmountIfBankLineExists(Rec);
            end;

            if PaymentSetup."Auto Archive Pay. Req" then
                if "Total Amount" = "Paid Amount" then
                    ArchivePayment(Rec);
        end;
    end;

    procedure ApplyEntries(var AccHeader: Record "Accountability Header"): Boolean
    var
        lvCustomerLedgEntry: Record "Cust. Ledger Entry";
    begin
        lvCustomerLedgEntry.SetCurrentKey("Customer No.", "Document No.", Open);
        lvCustomerLedgEntry.SetRange("Customer No.", AccHeader."Payee No");
        lvCustomerLedgEntry.SetRange("Document No.", AccHeader."PV No.");
        lvCustomerLedgEntry.SetRange(Open, true);
        if lvCustomerLedgEntry.FindSet() then
            repeat
                lvCustomerLedgEntry.CalcFields("Remaining Amount");
                lvCustomerLedgEntry.Validate("Applies-to ID", AccHeader."Accountability Posting No.");
                lvCustomerLedgEntry.Validate("Amount to Apply", lvCustomerLedgEntry."Remaining Amount");
                CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", lvCustomerLedgEntry);
            until lvCustomerLedgEntry.Next() = 0;
    end;

    procedure PostApplicationForUnappliedEntries(var AccHeader: Record "Accountability Header")
    var
        // ApplyEntryParameters: Record "Apply Unapply Parameters";
        CustLedgerEntryToApply: Record "Cust. Ledger Entry";
        ApplyingCustomerLedger: Record "Cust. Ledger Entry";
        TempApplyingCustomerLedger: Record "Cust. Ledger Entry" temporary;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        ApplyingCustomerLedger.SetCurrentKey("Customer No.", "Document No.", Open);
        ApplyingCustomerLedger.SetRange("Customer No.", AccHeader."Payee No");
        ApplyingCustomerLedger.SetRange("Document No.", AccHeader."No.");
        ApplyingCustomerLedger.SetRange(Open, true);
        if ApplyingCustomerLedger.FindSet() then
            repeat
                TempApplyingCustomerLedger := ApplyingCustomerLedger;
                TempApplyingCustomerLedger.Insert();
                TempApplyingCustomerLedger."Applies-to ID" := UserId;
                TempApplyingCustomerLedger.CalcFields("Remaining Amount");
                TempApplyingCustomerLedger.Validate("Amount to Apply", TempApplyingCustomerLedger."Remaining Amount");
                CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", TempApplyingCustomerLedger);

                //Copy application parameters from the applying entry
                // ApplyEntryParameters.CopyFromCustLedgEntry(TempApplyingCustomerLedger);
                // ApplyEntryParameters."Posting Date" := CustEntryApplyPostedEntries.GetApplicationDate(TempApplyingCustomerLedger);

                GLSetup.GetRecordOnce();
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    // ApplyEntryParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    // ApplyEntryParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;

                CustLedgerEntryToApply.SetCurrentKey("Customer No.", "Document No.", Open);
                CustLedgerEntryToApply.SetRange("Customer No.", AccHeader."Payee No");
                CustLedgerEntryToApply.SetRange("Document No.", AccHeader."PV No.");
                CustLedgerEntryToApply.SetRange(Open, true);
                if CustLedgerEntryToApply.FindSet() then
                    repeat
                        CustLedgerEntryToApply.CalcFields("Remaining Amount");
                        CustLedgerEntryToApply.Validate("Applies-to ID", UserId);
                        CustLedgerEntryToApply.Validate("Amount to Apply", CustLedgerEntryToApply."Remaining Amount");
                        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", CustLedgerEntryToApply);
                    until CustLedgerEntryToApply.Next() = 0;
            // CustEntryApplyPostedEntries.Apply(TempApplyingCustomerLedger, ApplyEntryParameters);
            until ApplyingCustomerLedger.Next() = 0;
    end;

    // procedure CreatePostedAccountabilityHeader(var AccHeader: Record "Accountability Header")
    // var
    //     PostedAccountabilityHeader: Record "Posted Accountability Header";
    //     PostedAccountabilityLine: Record "Posted Accountability Line";
    //     AccountabilityLine: Record "Accountability Line";
    // begin
    //     PostedAccountabilityHeader.Init();
    //     PostedAccountabilityHeader.TransferFields(AccHeader);
    //     PostedAccountabilityHeader."Acc. Posted On" := Today;
    //     PostedAccountabilityHeader.Insert();
    //     AccountabilityLine.Reset();
    //     AccountabilityLine.SetRange("Document Type", AccHeader."Document Type");
    //     AccountabilityLine.SetRange("Document No", AccHeader."No.");
    //     if AccountabilityLine.FindSet() then
    //         repeat
    //             PostedAccountabilityLine.Init();
    //             PostedAccountabilityLine.TransferFields(AccountabilityLine);
    //             PostedAccountabilityLine.Insert();
    //             AccountabilityLine.Posted := true;
    //             AccountabilityLine.Modify();
    //         until AccountabilityLine.Next() = 0;
    // end;
    procedure CreatePostedAccountabilityHeader(var AccHeader: Record "Accountability Header")
    var
        PostedAccountabilityHeader: Record "Accountability Header";
        PostedAccountabilityLine: Record "Accountability Line";
        AccountabilityLine: Record "Accountability Line";
    begin
        PostedAccountabilityHeader.Reset();
        PostedAccountabilityHeader.SetRange("No.", AccHeader."No.");
        PostedAccountabilityHeader.SetRange("Document Type", AccHeader."Document Type"::Accountability);
        if PostedAccountabilityHeader.FindFirst() then begin
            PostedAccountabilityHeader."Acc. Posted On" := Today;
            PostedAccountabilityHeader.Posted := true;
            PostedAccountabilityHeader.Modify();
        end;

        PostedAccountabilityLine.Reset();
        PostedAccountabilityLine.SetRange("Document Type", AccHeader."Document Type"::Accountability);
        PostedAccountabilityLine.SetRange("Document No", AccHeader."No.");
        if PostedAccountabilityLine.FindSet() then
            repeat
                PostedAccountabilityLine.Posted := true;
                PostedAccountabilityLine.Modify();
            until PostedAccountabilityLine.Next() = 0;
    end;


    procedure ClearAppliedVendEntries()
    var
        VendLedgEntry_Apply: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry_Apply.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
        VendLedgEntry_Apply.SetRange("Vendor No.", Rec."Payee No");
        VendLedgEntry_Apply.SetRange("Applies-to ID", Rec."No.");
        VendLedgEntry_Apply.SetRange(Open, true);
        if VendLedgEntry_Apply.FindSet() then
            repeat
                VendLedgEntry_Apply.Validate("Amount to Apply", 0);
                VendLedgEntry_Apply.Validate("Applies-to ID", '');
                VendLedgEntry_Apply.Modify();
            until VendLedgEntry_Apply.Next() = 0;
    end;

    procedure ArchivePayment(Header: Record "Accountability Header")
    var
        PLine: Record "Accountability Line";
        ArchPLine: Record "Payment Req Line Archive";
        ArchHeader: Record "Payment Req. Header Archive";
    begin
        ArchHeader.Init();
        ArchHeader.TransferFields(Header);
        ArchHeader.InitInsert(ArchHeader);
        ArchHeader.Insert(true);
        PLine.SetRange("Document No", Header."No.");
        if PLine.FindSet() then
            repeat
                ArchPLine.Init();
                ArchPLine.TransferFields(PLine);
                ArchPLine."Archive No" := ArchHeader."Archive No";
                ArchPLine.Insert(true);
            until PLine.Next() = 0;
        PLine.Reset();
        PLine.SetRange("Document No", Header."No.");
        if PLine.FindFirst() then
            PLine.DeleteAll();
        Header.Delete();
    end;

    procedure CheckExistence(Header: Record "Payment Requisition Header")
    var
        lvLine: Record "Payment Requisition Line";
    begin
        lvLine.SetRange("Document Type", "Document Type");
        lvLine.SetRange("Document No", "No.");
        if lvLine.FindSet() then
            repeat
                lvLine.TestField(Description);
            until lvLine.Next() = 0;
    end;

    procedure checkForAppliedDocuments(var AccountabilityLine: Record "Accountability Line"; CustomerNo: Code[20]): Boolean
    var
        lvCustLedgerEntry: Record "Cust. Ledger Entry";
        LineApplied: Boolean;
    begin
        Clear(LineApplied);
        lvCustLedgerEntry.Reset();
        lvCustLedgerEntry.SetRange("Customer No.", CustomerNo);
        lvCustLedgerEntry.SetRange("Applies-to ID", AccountabilityLine."Document No");
        lvCustLedgerEntry.SetRange("Payment Requisition No.", AccountabilityLine."Related PR No");
        lvCustLedgerEntry.SetRange("Payment Req. Line No.", AccountabilityLine."Related PR Line No");
        if not lvCustLedgerEntry.IsEmpty() then
            LineApplied := true
        else
            LineApplied := false;

        exit(LineApplied);
    end;

    procedure AmountAccountedForEqualToAmountToAccount(var AccountabilityHeader: Record "Accountability Header")
    var
        lvAccountabilityLine: Record "Accountability Line";
        TotalAmountToAccount: Decimal;
        TotalAmountAccounted: Decimal;
    begin
        AccountabilityHeader.CalcFields("Total Amount");
        Clear(TotalAmountAccounted);
        Clear(TotalAmountToAccount);
        lvAccountabilityLine.Reset();
        lvAccountabilityLine.SetRange("Document Type", AccountabilityHeader."Document Type");
        lvAccountabilityLine.SetRange("Document No", AccountabilityHeader."No.");
        lvAccountabilityLine.SetFilter("Generated From PR", '=%1', true);
        if lvAccountabilityLine.FindSet() then
            repeat
                TotalAmountToAccount += lvAccountabilityLine.Amount;
            until lvAccountabilityLine.Next() = 0;
        lvAccountabilityLine.Reset();
        lvAccountabilityLine.SetRange("Document Type", AccountabilityHeader."Document Type");
        lvAccountabilityLine.SetRange("Document No", AccountabilityHeader."No.");
        if lvAccountabilityLine.FindSet() then
            repeat
                TotalAmountAccounted += lvAccountabilityLine."Amount To Pay";
            until lvAccountabilityLine.Next() = 0;

        if TotalAmountAccounted <> TotalAmountToAccount then
            Error('The total amount (' + Format(TotalAmountAccounted) + ') accounted for must be equal to the total amount dispersed to staff (' + Format(TotalAmountToAccount) + ').');
    end;

    procedure CheckBankAccountLineAmount(var AccountabilityHeader: Record "Accountability Header")
    var
        AccountabilityLine: Record "Accountability Line";
        PaymentReqLineArchive: Record "Payment Req Line Archive";
        TotalBankLineAmount: Decimal;
        TotalAmountPendingAccountability: Decimal;
    begin
        TotalBankLineAmount := 0;
        TotalAmountPendingAccountability := 0;
        AccountabilityLine.Reset();
        AccountabilityLine.SetRange("Document Type", AccountabilityHeader."Document Type");
        AccountabilityLine.SetRange("Document No", AccountabilityHeader."No.");
        AccountabilityLine.SetFilter("Account Type", '=%1', AccountabilityLine."Account Type"::"Bank Account");
        if AccountabilityLine.FindSet() then
            repeat
                TotalBankLineAmount += AccountabilityLine.Amount;
            until AccountabilityLine.Next() = 0;

        PaymentReqLineArchive.Reset();
        PaymentReqLineArchive.SetRange("Document Type", PaymentReqLineArchive."Document Type"::"Payment Requisition");
        PaymentReqLineArchive.SetRange("Document No", AccountabilityHeader."Requisition No.");
        if PaymentReqLineArchive.FindSet() then
            repeat
                TotalAmountPendingAccountability += (PaymentReqLineArchive."Amount Paid" - PaymentReqLineArchive."Amount Accounted");
            until PaymentReqLineArchive.Next() = 0;
        if TotalBankLineAmount > 0 then
            if not (TotalAmountPendingAccountability = TotalBankLineAmount) then
                Error('The amount (%1) of the bank account line should be equal to the total amount pending accountability (%2).', Format(TotalBankLineAmount), Format(TotalAmountPendingAccountability));
    end;

    procedure UpdateAccRemaingAmountIfBankLineExists(var AccountabilityHeader: Record "Accountability Header")
    var
        PaymentReqHeaderArchive: Record "Payment Req. Header Archive";
        PaymentReqLineArchive: Record "Payment Req Line Archive";
        AccountabilityLine: Record "Accountability Line";
    begin
        AccountabilityLine.Reset();
        AccountabilityLine.SetRange("Document Type", AccountabilityHeader."Document Type");
        AccountabilityLine.SetRange("Document No", AccountabilityHeader."No.");
        AccountabilityLine.SetFilter("Account Type", '=%1', AccountabilityLine."Account Type"::"Bank Account");
        if AccountabilityLine.FindFirst() then begin
            PaymentReqHeaderArchive.Reset();
            PaymentReqHeaderArchive.SetRange("Document Type", PaymentReqHeaderArchive."Document Type"::"Payment Requisition");
            PaymentReqHeaderArchive.SetRange("No.", AccountabilityHeader."Requisition No.");
            if PaymentReqHeaderArchive.FindFirst() then begin
                PaymentReqLineArchive.Reset();
                PaymentReqLineArchive.SetRange("Document Type", PaymentReqHeaderArchive."Document Type");
                PaymentReqLineArchive.SetRange("Document No", PaymentReqHeaderArchive."No.");
                if PaymentReqLineArchive.FindSet() then
                    repeat
                        PaymentReqLineArchive.Validate("Amount Accounted", (PaymentReqLineArchive."Amount Accounted" + (PaymentReqLineArchive."Amount Paid" - PaymentReqLineArchive."Amount Accounted")));
                        PaymentReqLineArchive.Accounted := true;
                        PaymentReqLineArchive.Modify();
                    until PaymentReqLineArchive.Next() = 0;

                PaymentReqHeaderArchive.Accounted := true;
                PaymentReqHeaderArchive.Modify();
            end;
        end;
    end;


    procedure UndoAccountability(var AccountabilityHeader: Record "Accountability Header")
    var
        lvPaymentReqHeaderArchive: Record "Payment Req. Header Archive";
        lvPaymentReqLineArchive: Record "Payment Req Line Archive";
        lvAccountabilityLine: Record "Accountability Line";
    begin
        lvAccountabilityLine.Reset();
        lvAccountabilityLine.SetRange("Document Type", AccountabilityHeader."Document Type");
        lvAccountabilityLine.SetRange("Document No", AccountabilityHeader."No.");
        if lvAccountabilityLine.FindSet() then
            repeat
                lvPaymentReqLineArchive.Reset();
                lvPaymentReqLineArchive.SetRange("Document Type", lvPaymentReqLineArchive."Document Type"::"Payment Requisition");
                lvPaymentReqLineArchive.SetRange("Document No", AccountabilityHeader."Requisition No.");
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
        lvPaymentReqHeaderArchive.SetRange("No.", AccountabilityHeader."Requisition No.");
        if lvPaymentReqHeaderArchive.FindFirst() then
            if lvPaymentReqHeaderArchive.Accounted then begin
                lvPaymentReqHeaderArchive.Accounted := false;
                lvPaymentReqHeaderArchive.Modify();
            end;

        ArchivePayment(AccountabilityHeader);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAccountabilityApprovalRequest(var Recref: RecordRef; SenderUserID: Code[50])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAccountabilityApprovalRequest(var AccHeader: Record "Accountability Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewAccountabilityApprovalHistory(var AccHeader: Record "Accountability Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewAccountabilityComments(var AccHeader: Record "Accountability Header")
    begin
    end;

}