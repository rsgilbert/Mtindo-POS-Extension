table 50009 "Payment Requisition Header"
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
                //Removed because the LCY value posted is different from the one on the approved request.
                //This happens in scenarios where the exchange rate at posting is different from the one used while initiating the request.
                //Validate("Currency Code");
            end;
        }
        field(4; "Payment Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Type".Code;
            trigger OnValidate()
            var
                PayType: Record "Payment Type";
            begin
                TestOpen(Rec);
                if PayType.Get("Payment Category") then
                    Validate("Payee Type", PayType."Payee Type");
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
            if ("Payee Type" = const(Employee)) Employee where(Status = filter(Active));

            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
                GLAccRec: Record "G/L Account";
                BankRec: Record "Bank Account";
                EmployeeRec: Record Employee;
                lvGenLedgerSetup: Record "General Ledger Setup";
            begin
                TestOpen(Rec);
                lvGenLedgerSetup.Get();
                if "Payee No" <> '' then begin
                    If CustRec.GET("Payee No") then
                        "Payee Name" := CustRec.Name;

                    IF VendorRec.GET("Payee No") then begin
                        // if lvGenLedgerSetup."Enable WHT" then
                        //     VendorRec.TestField("WHT Posting Group");
                        "Payee Name" := VendorRec.Name;
                        Validate("Currency Code", VendorRec."Currency Code");
                    end;

                    IF GLAccRec.GET("Payee No") then
                        "Payee Name" := GLAccRec.Name;

                    IF BankRec.GET("Payee No") then begin
                        "Payee Name" := BankRec.Name;
                        Validate("Currency Code", BankRec."Currency Code");
                    end;

                    IF EmployeeRec.Get("Payee No") then begin
                        "Payee Name" := EmployeeRec.FullName();
                    end;
                end
                else
                    Clear("Payee Name");
            end;
        }
        field(7; "Payee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            // trigger OnValidate()
            // begin
            //     TestOpen(Rec);
            // end;
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
            TableRelation = "WorkPlan Header"."No." where("Shortcut Dimension 1 Code" = field("Global Dimension 1 Code"), Blocked = const(false), Status = const(Approved), "Transferred To Budget" = const(true));
            trigger OnValidate()
            var
                WorkPlanRec: Record "WorkPlan Header";
                lvPaymentReqLine: Record "Payment Requisition Line";
            begin
                if (xRec."WorkPlan No" <> '') AND (xRec."WorkPlan No" <> Rec."WorkPlan No") then begin
                    if GuiAllowed then
                        if not Confirm('Are you sure you would like to change the workplan ?, this will delete the lines', false) then
                            exit;
                    lvPaymentReqLine.SetRange("Document Type", Rec."Document Type");
                    lvPaymentReqLine.SetRange("Document No", Rec."No.");
                    if lvPaymentReqLine.FindFirst() then
                        lvPaymentReqLine.DeleteAll(true);
                end;
                TestOpen(Rec);
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
                defaultDimensions: Record "Default Dimension";
                GeneralLedger: Record "General Ledger Setup";
            begin
                TestOpen(Rec);
                if EmpRec.Get("Requisitioned By") then
                    "Requestor Name" := EmpRec.FullName();
                GeneralLedger.Get();
                defaultDimensions.Reset();
                defaultDimensions.SetRange("Table ID", Database::Employee);
                defaultDimensions.SetRange("No.", Rec."Requisitioned By");
                defaultDimensions.SetRange("Dimension Code", GeneralLedger."Global Dimension 1 Code");
                if defaultDimensions.FindFirst() then
                    Validate("Global Dimension 1 Code", defaultDimensions."Dimension Value Code");
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
                TestOpen(Rec);
            end;
        }
        field(15; "Total Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Payment Requisition Line".Amount WHERE("Document No" = FIELD("No.")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), "Dimension Value Type" = const(Standard), Blocked = const(false));
            //Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestOpen(Rec);
                if xRec."Global Dimension 1 Code" <> '' then
                    if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then begin
                        if GuiAllowed then
                            if not Confirm('Do you want to change the dimension? The workplan No will be cleared and lines deleted.') then
                                exit;
                        Rec.Validate("WorkPlan No", '');
                    end;
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }

        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), "Dimension Value Type" = const(Standard), Blocked = const(false));
            //Editable = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestOpen(Rec);
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

            trigger OnValidate()
            var
                StandardCodesMgt: Codeunit "Standard Codes Mgt.";
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date")]) or ("Currency Code" <> xRec."Currency Code") then
                    TestOpen(Rec);

                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then begin
                    UpdateCurrencyFactor();
                end
                else
                    if "Currency Code" <> xRec."Currency Code" then
                        UpdateCurrencyFactor()
                    else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor();
                            if "Currency Factor" <> xRec."Currency Factor" then
                                if GuiAllowed then
                                    if Confirm('Do you want to update the exchange rate?') then
                                        Validate("Currency Factor")
                                    else
                                        Rec."Currency Factor" := xRec."Currency Factor";
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
            var
                myInt: Integer;
                lvPaymentLine: Record "Payment Requisition Line";
            begin
                if Rec."Currency Factor" <> xRec."Currency Factor" then begin
                    lvPaymentLine.SetRange("Document Type", Rec."Document Type");
                    lvPaymentLine.SetRange("Document No", Rec."No.");
                    if lvPaymentLine.FindSet() then
                        repeat
                            lvPaymentLine."Currency Factor" := Rec."Currency Factor";
                            lvPaymentLine.Validate(Amount);
                            lvPaymentLine.Validate("Amount To Pay");
                            lvPaymentLine.Modify();
                        until lvPaymentLine.Next() = 0
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
                GenReqSetup.Get();
                if Rec."Bank Account No" <> '' then begin
                    if BankRec.Get("Bank Account No") then
                        "Bank Account Name" := BankRec.Name;
                end
                else
                    "Bank Account Name" := '';

                if "Bank Account No" <> '' then begin
                    "Modified By" := UserId;
                    "Modified Date" := Today;
                    "Modified Time" := Time;
                    //PV No to be assigned using no series on the Journal Batch Name
                    // if "PV No." = '' then begin
                    //     "PV No." := NoSeriesMgt.GetNextNo(GenReqSetup."Payment Voucher Nos.", "Posting Date", true);
                    // end;
                end;
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
            CalcFormula = Sum("Payment Requisition Line"."Amount To Pay" WHERE("Document No" = FIELD("No.")));
            Caption = 'Amount To Pay';
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
            CalcFormula = sum("Payment Requisition Line"."Amount Paid" where("Document No" = field("No."), "Document Type" = field("Document Type")));
            Caption = 'Paid Amount';
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

        field(42; "Requires Accountability"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Modified By"; Code[20])
        {
            Editable = false;
        }
        field(46; "Modified Date"; Date)
        {
        }
        field(47; "Modified Time"; Time)
        {

        }
        field(48; "File Number"; Code[20])
        {

        }
        field(58; Rejected; Boolean)
        {
        }
        field(60; "Total WHT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Requisition Line"."WHT Amount" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(62; "Total WHT Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Requisition Line"."WHT Amount (LCY)" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(64; "Total WHT on VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Requisition Line"."WHT on VAT Amount" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(66; "Total WHT on VAT (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Requisition Line"."WHT on VAT Amount (LCY)" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(67; "Travel Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Txt0001: Label 'Travel Start Date cannot be earlier than today';
            begin
                TestOpen(Rec);
                // Restriction removed to allow users to make requests when the travel start date is earlier than today's date.
                // if Rec."Travel Start Date" < Today then
                //     Error(Txt0001);
            end;
        }

        field(68; "Travel End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Txt0001: Label 'Travel End Date cannot be earlier than Travel Start Date';
            begin
                TestOpen(Rec);
                if Rec."Travel Start Date" <> 0D then
                    if Rec."Travel End Date" < Rec."Travel Start Date" then
                        Error(Txt0001);
            end;
        }
        field(69; "Destination"; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestOpen(Rec);
            end;
        }
        field(70; Delegatee; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(71; Staff; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestOpen(Rec);
            end;
        }
        field(72; "Request No."; Code[20])
        {

        }
        field(74; "Registered MM Number"; Text[30])
        {
            Caption = 'Registered Mobile Money Number';
            trigger OnValidate()
            var
                i: Integer;
                PhoneNoCannotContainLettersErr: Label 'must not contain letters';
            begin
                for i := 1 to StrLen("Registered MM Number") do
                    if (Format(Rec."Registered MM Number"[i]) in ['0' .. '9']) or (Format(Rec."Registered MM Number"[i]) in ['.']) then
                        if StrLen(DelChr(Rec."Registered MM Number", ' ', DelChr(Rec."Registered MM Number", '+', '/'))) <= 1 then
                            FieldError(Rec."Registered MM Number", PhoneNoCannotContainLettersErr);
            end;
        }
        field(75; "Registered MM Name"; Text[100])
        {
            Caption = 'Registered Mobile Money Name';
        }
        field(78; "Mode Of Payment"; Text[100])
        {
            TableRelation = "Payment Method".Code;
        }
        field(79; "Gen. Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name;

            trigger OnLookup()
            var
                GenJnlBatch: Record "Gen. Journal Batch";
                lvGenReqSetup: Record "Gen. Requisition Setup";
            begin
                lvGenReqSetup.Get();
                GenJnlBatch.Reset();
                GenJnlBatch.SetFilter("Journal Template Name", lvGenReqSetup."Requisition Journal Template");
                if Page.RunModal(Page::"General Journal Batches", GenJnlBatch) = Action::LookupOK then
                    validate("Gen. Batch Name", GenJnlBatch.Name);
            end;

            trigger OnValidate()
            var
                lvGenLedgerSetup: Record "General Ledger Setup";
            // lvDocNumbering: Record "Numbering By Donor";
            begin
                GenReqSetup.get();
                lvGenLedgerSetup.Get();
                // if "Gen. Batch Name" <> '' then begin
                //     lvDocNumbering.SetRange("Dimension Code", lvGenLedgerSetup."Global Dimension 2 Code");
                //     lvDocNumbering.SetRange("Dimension Value Code", Rec."Global Dimension 2 Code");
                //     if lvDocNumbering.FindFirst() then begin
                //         lvDocNumbering.TestField("Payment Voucher Nos.");
                //         if "PV No." = '' then
                //             NoSeriesMgt.InitSeries(lvDocNumbering."Payment Voucher Nos.", xRec."No. Series", Today, "PV No.", "No. Series");
                //     end
                //     else
                if "PV No." = '' then
                    NoSeriesMgt.InitSeries(GenReqSetup."Payment Voucher Nos.", xRec."No. Series", Today, "PV No.", "No. Series");
                // end;
            end;
        }
        field(82; "Prepared By"; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active));
            Caption = 'Prepared By';
            trigger OnValidate()
            var
                lvEmployee: Record Employee;
            begin
                if "Prepared By" <> '' then begin
                    if lvEmployee.Get("Prepared By") then
                        "Prepared By Name" := lvEmployee.FullName();
                end
                else
                    Clear("Prepared By Name");
            end;
        }
        field(83; "Prepared By Name"; Text[100])
        {
            Editable = false;
            Caption = 'Prepared By Name';
        }
        field(84; Posted; Boolean)
        {

        }
        field(85; "Travellors Names"; Text[200])
        {
            Caption = 'Travellors Names';
        }
        field(86; "Destination Address"; Text[100])
        {
            Caption = 'Destination Location';
        }
        field(88; "Expected Check in Dates"; Text[100])
        {
            Caption = 'Expected checkin Dates';
        }
        field(89; "Expected Check Out Dates"; Text[100])
        {
            Caption = 'Expected checkin Dates';
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
        gvPaymentLine: Record "Payment Requisition Line";
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        CurrencyDate: Date;
        Confirmed: Boolean;
        EmployeeRec: Record Employee;
        RecreatePaymentLinesMsg: Label 'If you change the currency code, the lines will be updated.\\Do you want to continue?', Comment = '%1: FieldCaption';
        RecreatePaymentLinesCancelErr: Label 'You must delete the existing purchase lines before you can change %1.', Comment = '%1 - Field Name, Sample:You must delete the existing payment lines before you can change Currency Code.';
        LastLineNo: Integer;

    trigger OnInsert()
    var
    begin
        "System Id" := System.CreateGuid();
        InitInsert();
        "Document Date" := Today;
        "Created By" := UserId;
        if "Requisitioned By" = '' then begin
            EmployeeRec.SetRange("User ID", UserId);
            if EmployeeRec.FindFirst() then begin
                Validate("Global Dimension 1 Code", EmployeeRec."Global Dimension 1 Code");
                Validate("Requisitioned By", EmployeeRec."No.");
            end;
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestOpen(Rec);
        if GuiAllowed then
            IF not Confirm('Are you really sure you would like to delete this requisition ?', false) then
                exit;
        PaymentLine.SetRange("Document Type", "Document Type");
        PaymentLine.SetRange("Document No", "No.");
        if PaymentLine.FindSet() then
            PaymentLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure InitInsert()
    var

    begin
        GenReqSetup.Get();
        if "No." = '' then
            case "Document Type" of
                "Document Type"::"Bank Transfer":
                    begin
                        GenReqSetup.TestField("Bank Transfer Nos.");
                        GenReqSetup.TestField("Payment Voucher Nos.");
                        NoSeriesMgt.InitSeries(GenReqSetup."Bank Transfer Nos.", xRec."No. Series", Today, Rec."No.", "No. Series");

                    end;
                "Document Type"::"Travel Requests":
                    begin
                        GenReqSetup.TestField("Travel Request Nos.");
                        GenReqSetup.TestField("Payment Voucher Nos.");
                        NoSeriesMgt.InitSeries(GenReqSetup."Travel Request Nos.", xRec."No. Series", Today, Rec."No.", "No. Series");
                    end
                else begin
                    GenReqSetup.TestField("Payment Requisition Nos.");
                    GenReqSetup.TestField("Payment Voucher Nos.");
                    NoSeriesMgt.InitSeries(GenReqSetup."Payment Requisition Nos.", xRec."No. Series", Today, Rec."No.", "No. Series");
                end;
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
                            RecreatePaymentLines(FieldCaption("Currency Code"));
                        until PaymentLine.Next() = 0;
                end;
            end else
                UpdateCurrencyExchangeRates.ShowMissingExchangeRatesNotification("Currency Code");
        end else begin
            Validate("Currency Factor", 0);
            if "Currency Code" <> xRec."Currency Code" then begin
                RecreatePaymentLines(FieldCaption("Currency Code"));
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

    procedure RecreatePaymentLines(ChangedFieldName: Text[100])
    var
        TempPaymentLine: Record "Payment Requisition Line" temporary;
        ConfirmManagement: Codeunit "Confirm Management";
        ExtendedTextAdded: Boolean;
        ConfirmText: Text;
        IsHandled: Boolean;
    begin
        if not PaymentLineExist() then
            exit;

        IsHandled := false;
        if IsHandled then
            exit;
        ConfirmText := RecreatePaymentLinesMsg;
        Confirmed := ConfirmManagement.ConfirmProcess(StrSubstNo(ConfirmText, ChangedFieldName), true);
        //end;

        if Confirmed then begin
            gvPaymentLine.LockTable();
            Modify();

            gvPaymentLine.Reset();
            gvPaymentLine.SetRange("Document Type", "Document Type");
            gvPaymentLine.SetRange("Document No", "No.");
            if gvPaymentLine.FindSet() then begin
                repeat
                    TempPaymentLine := gvPaymentLine;
                    TempPaymentLine.Insert();
                until gvPaymentLine.Next() = 0;

                gvPaymentLine.DeleteAll(true);

                gvPaymentLine.Init();
                gvPaymentLine."Line No" := 0;
                TempPaymentLine.FindSet();
                ExtendedTextAdded := false;
                repeat
                    gvPaymentLine.Init();
                    gvPaymentLine."Line No" := gvPaymentLine."Line No" + 10000;
                    gvPaymentLine.Validate("Account Type", TempPaymentLine."Account Type");
                    if TempPaymentLine."Account No" = '' then begin
                        gvPaymentLine.Description := TempPaymentLine.Description;
                        gvPaymentLine."Payee Type" := TempPaymentLine."Payee Type";
                    end else begin
                        gvPaymentLine."Payee Type" := TempPaymentLine."Payee Type";
                        gvPaymentLine.Validate("Account No", TempPaymentLine."Account No");
                        gvPaymentLine.Validate("WorkPlan No", TempPaymentLine."WorkPlan No");
                        gvPaymentLine.Validate("Budget Code", TempPaymentLine."Budget Code");
                        gvPaymentLine.Validate("WorkPlan Entry No", TempPaymentLine."WorkPlan Entry No");
                        gvPaymentLine.Description := TempPaymentLine.Description;
                        gvPaymentLine.Validate(Quantity, TempPaymentLine.Quantity);
                        if TempPaymentLine."Payee Type" <> TempPaymentLine."Payee Type"::Vendor then
                            gvPaymentLine.Validate(Rate, TempPaymentLine.Rate);
                        IsHandled := false;
                    end;
                    gvPaymentLine.Insert();
                    ExtendedTextAdded := false;
                until TempPaymentLine.Next() = 0;

                TempPaymentLine.SetRange("Account Type");
                TempPaymentLine.DeleteAll();
            end;
        end else
            Error(RecreatePaymentLinesCancelErr, ChangedFieldName);
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
        if "No." <> '' then
            //Modify;

        if OldDimSetID <> "Dimension Set ID" then
                //Modify;
                if OldDimSetID <> "Dimension Set ID" then
                    //Modify;
                    if ("Document Type" = "Document Type"::"Bank Transfer") or ("WorkPlan No" = '') then
                        if PaymentLineExist() then
                            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
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

    procedure PostPayment()
    var
        PaymentLine: Record "Payment Requisition Line";
        GenJournalTemp: Record "Gen. Journal Line";
        GenJournalTemp2: Record "Gen. Journal Line";
        PaymentSetup: Record "Gen. Requisition Setup";
        WHTPostingGroup: Record "WHT Posting Groups";
        PaymtType: Record "Payment Type";
        PaymentLineTemp: Record "Payment Requisition Line" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostCU: Codeunit "Gen. Jnl.-Post Line";
        Txt000: Label 'Are you really sure you would like to post this Payment ?';
        Txt001: Label 'Document has been posted successfully';
        lvGenBatchName: Code[20];
    begin
        SourceCodeSetup.get();

        TestField("Bank Account No");
        PaymentSetup.Get();
        if GuiAllowed then
            if not Confirm(Txt000) then
                exit;
        Clear(lvGenBatchName);
        if "Gen. Batch Name" <> '' then
            lvGenBatchName := "Gen. Batch Name"
        else
            lvGenBatchName := PaymentSetup."Req Journal Batch";
        PaymtType.Get("Payment Category");
        PaymentLine.SetRange("Document No", "No.");
        if PaymentLine.FindSet() then begin
            GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
            GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
            if GenJournalTemp2.FindFirst() then
                GenJournalTemp2.DeleteAll();
            repeat
                if PaymentLine."Amount Paid" < PaymentLine.Amount then begin
                    GenJournalTemp.Init();
                    GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                    GenJournalTemp."Journal Batch Name" := lvGenBatchName;
                    GenJournalTemp."Line No." := PaymentLine."Line No";
                    GenJournalTemp.Validate("Posting Date", "Posting Date");
                    GenJournalTemp.Validate("Document Type", GenJournalTemp."Document Type"::Payment);
                    GenJournalTemp.Validate("Document No.", "PV No.");
                    if "Document Type" = "Document Type"::"Bank Transfer" then
                        GenJournalTemp."Document No." := "No.";
                    GenJournalTemp.Description := Rec.Purpose;
                    GenJournalTemp.Amount := PaymentLine."Amount To Pay";
                    GenJournalTemp."Amount (LCY)" := Round(PaymentLine."Amount To Pay (LCY)", 0.02, '>');
                    GenJournalTemp."Budget Name" := PaymentLine."Budget Code";
                    GenJournalTemp."Work Plan" := PaymentLine."WorkPlan No";
                    GenJournalTemp."Work Plan Entry No." := PaymentLine."WorkPlan Entry No";
                    GenJournalTemp."Created From Requisition" := true;
                    GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                    GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");
                    if "Payee Type" = "Payee Type"::Vendor then begin
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Vendor);
                        GenJournalTemp.Amount := PaymentLine."Amount To Pay" + PaymentLine."WHT Amount" + PaymentLine."WHT on VAT Amount";
                        GenJournalTemp."External Document No." := "PV No.";
                        GenJournalTemp.Description := PaymentLine.Description;
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                        //GenJournalTemp."Amount (LCY)" := PaymentLine."Amount To Pay (LCY)" + PaymentLine."WHT Amount (LCY)" + PaymentLine."WHT on VAT Amount (LCY)";
                        GenJournalTemp.Validate("Applies-to ID", "No.");
                        GenJournalTemp."Account No." := Rec."Payee No";
                        GenJournalTemp.Payee := Rec."Payee Name";
                    end;
                    if "Payee Type" = "Payee Type"::Bank then begin
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"Bank Account");
                        GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                        GenJournalTemp."Account No." := Rec."Payee No";
                        GenJournalTemp.Payee := Rec."Payee Name";
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Description := PaymentLine.Description;
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    end;
                    if "Payee Type" = "Payee Type"::Customer then begin
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Customer);
                        GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                        GenJournalTemp."Account No." := Rec."Payee No";
                        GenJournalTemp.Payee := Rec."Payee Name";
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Description := PaymentLine.Description;
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    end;

                    if Rec."Payee Type" = Rec."Payee Type"::Imprest then begin
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Customer);
                        GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                        GenJournalTemp."Account No." := Rec."Payee No";
                        GenJournalTemp.Payee := Rec."Payee Name";
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Description := PaymentLine.Description;
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    end;
                    if "Payee Type" IN ["Payee Type"::Statutory, "Payee Type"::Employee, "Payee Type"::" "] then begin
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                        GenJournalTemp."Account No." := PaymentLine."Account No";
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Description := Rec.Purpose;
                        GenJournalTemp.Payee := Rec."Payee Name";
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    end;
                    GenJournalTemp.Validate("Currency Code", Rec."Currency Code");
                    GenJournalTemp.Validate("Currency Factor", Rec."Currency Factor");
                    GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");

                    //Assign the source code for payment requisitions
                    if SourceCodeSetup."Payment Requisition" <> '' then
                        GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                    //create a link between the payment requisition line and customer ledger entry.
                    GenJournalTemp."Payment Requisition No." := PaymentLine."Document No";
                    GenJournalTemp."Payment Req. Line No." := PaymentLine."Line No";

                    GenJournalTemp.Insert(true);

                    if PaymentLine."WHT Amount" <> 0 then begin
                        WHTPostingGroup.SetRange(Code, PaymentLine."WHT Code");
                        if WHTPostingGroup.FindFirst() then;
                        GenJournalTemp."Line No." := PaymentLine."Line No" + 100;
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                        GenJournalTemp.Validate("Account No.", WHTPostingGroup."Payable WHT Account Code");
                        GenJournalTemp.Amount := -1 * PaymentLine."WHT Amount";
                        GenJournalTemp.Description := Rec.Purpose;
                        //GenJournalTemp."Amount (LCY)" := -1 * PaymentLine."WHT Amount (LCY)";
                        GenJournalTemp."Applies-to ID" := '';
                        GenJournalTemp.Validate("Currency Code", Rec."Currency Code");
                        GenJournalTemp.Validate("Currency Factor", Rec."Currency Factor");
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                        GenJournalTemp.Payee := Rec."Payee Name";

                        //Assign the source code for payment requisitions
                        if SourceCodeSetup."Payment Requisition" <> '' then
                            GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                        GenJournalTemp."Created From Requisition" := true;

                        GenJournalTemp.Insert(true);
                    end;

                    if PaymentLine."WHT on VAT Amount" <> 0 then begin
                        WHTPostingGroup.SetRange(Code, PaymentLine."WHT Code");
                        if WHTPostingGroup.FindFirst() then;
                        GenJournalTemp."Line No." := PaymentLine."Line No" + 200;
                        GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                        GenJournalTemp.Validate("Account No.", WHTPostingGroup."WHT On VAT Account No.");
                        GenJournalTemp.Amount := -1 * PaymentLine."WHT on VAT Amount";
                        GenJournalTemp.Description := Rec.Purpose;
                        //GenJournalTemp."Amount (LCY)" := -1 * PaymentLine."WHT on VAT Amount (LCY)";
                        GenJournalTemp."Applies-to ID" := '';
                        GenJournalTemp.Validate("Currency Code", PaymentLine."Currency Code");
                        GenJournalTemp.Validate("Currency Factor", PaymentLine."Currency Factor");
                        GenJournalTemp."External Document No." := "Ext Document No";
                        GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                        GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                        GenJournalTemp.Payee := Rec."Payee Name";

                        //Assign the source code for payment requisitions
                        if SourceCodeSetup."Payment Requisition" <> '' then
                            GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                        GenJournalTemp."Created From Requisition" := true;

                        GenJournalTemp.Insert(true);
                    end;

                    //Insert Balancing Line
                    GenJournalTemp."Line No." := PaymentLine."Line No" + 300;
                    GenJournalTemp."Account Type" := GenJournalTemp."Account Type"::"Bank Account";
                    GenJournalTemp.Description := Rec.Purpose;
                    GenJournalTemp."Account No." := "Bank Account No";
                    GenJournalTemp.Amount := -1 * PaymentLine."Amount To Pay";
                    //GenJournalTemp."Amount (LCY)" := -1 * ROUND(PaymentLine."Amount To Pay (LCY)", 0.02, '>');
                    GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                    GenJournalTemp."External Document No." := "Ext Document No";
                    GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                    GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");
                    GenJournalTemp."Applies-to ID" := '';
                    GenJournalTemp.Validate("Currency Code", Rec."Currency Code");
                    GenJournalTemp.Validate("Currency Factor", Rec."Currency Factor");

                    //Assign the source code for payment requisitions
                    if SourceCodeSetup."Payment Requisition" <> '' then
                        GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                    GenJournalTemp."Created From Requisition" := true;

                    GenJournalTemp.Insert(true);

                    PaymentLine.Validate("Amount Paid", PaymentLine."Amount Paid" + PaymentLine."Amount To Pay");
                    // message(format(PaymentLineTemp."Amount Paid"));
                    PaymentLine.Validate("Amount To Pay", (PaymentLine.Amount - PaymentLine."Amount Paid"));
                    PaymentLine.Modify();
                    // PaymentLineTemp.TransferFields(PaymentLine);
                    // Message('here 1');
                    // PaymentLineTemp.Insert();
                    // Message('here 2');
                    // PaymentLineTemp.Validate("Amount Paid", PaymentLineTemp."Amount Paid" + PaymentLine."Amount To Pay");
                    // message(format(PaymentLineTemp."Amount Paid"));
                    // PaymentLineTemp.Validate("Amount To Pay", (PaymentLineTemp.Amount - PaymentLineTemp."Amount Paid"));
                    // PaymentLineTemp.Modify();
                end;
            until PaymentLine.Next() = 0;
            if GenJournalTemp.Amount <> 0 then
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalTemp);

            // If PaymentLineTemp.FindSet() then
            //     repeat
            //         PaymentLine.Reset();
            //         PaymentLine.SetRange("Document Type", PaymentLineTemp."Document Type");
            //         PaymentLine.SetRange("Document No", PaymentLineTemp."Document No");
            //         PaymentLine.SetRange("Line No", PaymentLineTemp."Line No");
            //         if PaymentLine.FindFirst() then begin
            //             PaymentLine := PaymentLineTemp;
            //             PaymentLine.Modify();
            //         end;
            //     until PaymentLineTemp.Next() = 0;
            // Commit();
            Rec.CalcFields("Total Amount", "Paid Amount");
            if Rec."Paid Amount" > 0 then begin
                Rec.Posted := true;
                Rec.Modify(true);
            end;

            if TestEligibilityToArchive(Rec) then
                ArchivePayment(Rec);
        end;

    end;

    local procedure TestEligibilityToArchive(PaymentRequisitionHeader: Record "Payment Requisition Header"): Boolean
    var
        PmtReqLine: Record "Payment Requisition Line";
        ArchivalStatus: Boolean;
    begin
        ArchivalStatus := TRUE;
        PmtReqLine.Reset();
        PmtReqLine.SETRANGE("Document No", PaymentRequisitionHeader."No.");
        IF PmtReqLine.FINDSET THEN
            REPEAT
                IF (PmtReqLine.Amount <> PmtReqLine."Amount Paid") then
                    ArchivalStatus := FALSE;
            UNTIL PmtReqLine.NEXT = 0;
        EXIT(ArchivalStatus);
    end;


    procedure PostPaymentForTransferToJournal(selectedPaymentHeader: Text)
    var
        // PaymentHeader: Record "Payment Requisition Header";
        PaymentLine: Record "Payment Requisition Line";
        GenJournalTemp: Record "Gen. Journal Line";
        GenJournalTemp2: Record "Gen. Journal Line";
        GenJournalTemp3: Record "Gen. Journal Line";
        PaymentSetup: Record "Gen. Requisition Setup";
        WHTPostingGroup: Record "WHT Posting Groups";
        GenJnlPostCU: Codeunit "Gen. Jnl.-Post Line";
        PaymtType: Record "Payment Type";
        PaymentLineTemp: Record "Payment Requisition Line" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        lvGenBatchName: Code[20];
        lvGenReqSetup: Record "Gen. Requisition Setup";
        lineNo: Integer;

        Txt000: Label 'Are you really sure you would like to transfer this Payment to journal ?';
        Txt001: Label 'Document has been transferred to journal successfully';

        WHTPostingSetup: Record "WHT Posting Groups";
        PaymentHeader: Record "Payment Requisition Header";
        PaymentHeader2: Record "Payment Requisition Header";
        lvSumofBankAmount: Integer;
        DocumentWithoutFields: List of [Text];
        MissingDocumentsText: Text;
        Document: Text;
    begin
        TestField("Bank Account No");
        PaymentSetup.Get();
        GenReqSetup.Get();
        if GuiAllowed then
            if not Confirm(Txt000) then
                exit;
        PaymentHeader.Reset();
        PaymentHeader.SETFILTER("No.", selectedPaymentHeader);
        if PaymentHeader.FindSet() then
            repeat
                if PaymentHeader."PV No." = '' then
                    if PaymentHeader."Bank Account No" = '' then
                        if PaymentHeader."Gen. Batch Name" = '' then
                            DocumentWithoutFields.Add(PaymentHeader."No.");
            until PaymentHeader.Next() = 0;
        if DocumentWithoutFields.Count > 0 then begin
            foreach Document in DocumentWithoutFields do
                MissingDocumentsText += Document + ', ';

            // Remove the trailing comma and space
            if MissingDocumentsText <> '' then
                MissingDocumentsText := DelStr(MissingDocumentsText, StrLen(MissingDocumentsText), 2);
            Error('The following documents have missing required fields. Please either unselect them or fill in the missing fields: %1', MissingDocumentsText);
        end;
        if PaymentHeader.FindSet() then
            repeat
                Clear(lvGenBatchName);
                Clear(LastLineNo);
                lvGenBatchName := PaymentHeader."Gen. Batch Name";
                PaymtType.Get("Payment Category");
                PaymentLine.Reset();
                PaymentLine.SetRange("Document No", PaymentHeader."No.");
                if PaymentLine.FindSet() then begin
                    GenJournalTemp.Reset();
                    GenJournalTemp.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                    GenJournalTemp.SetRange("Journal Batch Name", lvGenBatchName);
                    if GenJournalTemp.FindLast() then
                        LastLineNo := GenJournalTemp."Line No."
                    else
                        LastLineNo := 0;

                    PaymentLineTemp.Reset();
                    repeat
                        if PaymentLine."Amount Paid" < PaymentLine.Amount then begin
                            // Main entry
                            // Message()
                            LastLineNo += 10000;
                            GenJournalTemp.Init();
                            GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                            GenJournalTemp."Journal Batch Name" := lvGenBatchName;
                            GenJournalTemp."Line No." := LastLineNo;
                            GenJournalTemp.Validate("Posting Date", PaymentHeader."Posting Date");
                            // GenJournalTemp.Validate("Document Type", GenJournalTemp."Document Type"::Payment);
                            GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                            GenJournalTemp."Created From Requisition" := true;
                            GenJournalTemp.Validate("Document No.", PaymentHeader."PV No.");
                            GenJournalTemp.Description := PaymentHeader.Purpose;
                            GenJournalTemp.Amount := PaymentLine."Amount To Pay";
                            GenJournalTemp."Amount (LCY)" := Round(PaymentLine."Amount To Pay (LCY)", 0.02, '>');
                            GenJournalTemp."Budget Name" := PaymentLine."Budget Code";
                            GenJournalTemp."Work Plan" := PaymentLine."WorkPlan No";
                            GenJournalTemp."Work Plan Entry No." := PaymentLine."WorkPlan Entry No";
                            GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                            GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");
                            if PaymentHeader."Payee Type" = PaymentHeader."Payee Type"::Vendor then begin
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Vendor);
                                GenJournalTemp.Amount := PaymentLine."Amount To Pay" + PaymentLine."WHT Amount" + PaymentLine."WHT on VAT Amount";
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                                GenJournalTemp.Validate("Applies-to ID", "No.");
                                GenJournalTemp."Account No." := PaymentHeader."Payee No";
                                GenJournalTemp.Payee := PaymentHeader."Payee Name"
                            end;
                            if PaymentHeader."Payee Type" = PaymentHeader."Payee Type"::Bank then begin
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"Bank Account");
                                GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                                GenJournalTemp."Account No." := PaymentHeader."Payee No";
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            end;
                            if PaymentHeader."Payee Type" = PaymentHeader."Payee Type"::Customer then begin
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Customer);
                                GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                                GenJournalTemp."Account No." := PaymentHeader."Payee No";
                                GenJournalTemp.Payee := PaymentHeader."Payee Name";
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            end;

                            if PaymentHeader."Payee Type" = PaymentHeader."Payee Type"::Imprest then begin
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::Customer);
                                GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                                GenJournalTemp."Account No." := PaymentHeader."Payee No";
                                GenJournalTemp.Payee := PaymentHeader."Payee Name";
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            end;
                            if PaymentHeader."Payee Type" IN [PaymentHeader."Payee Type"::Statutory, PaymentHeader."Payee Type"::Employee, PaymentHeader."Payee Type"::" "] then begin
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                                GenJournalTemp."Account No." := PaymentLine."Account No";
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp.Payee := PaymentHeader."Payee Name";
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            end;
                            GenJournalTemp.Validate("Currency Code", Rec."Currency Code");
                            GenJournalTemp.Validate("Currency Factor", Rec."Currency Factor");
                            GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");

                            //Assign the source code for payment requisitions
                            if SourceCodeSetup."Payment Requisition" <> '' then
                                GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                            GenJournalTemp.Insert(true);

                            // WHT entry
                            if PaymentLine."WHT Amount" <> 0 then begin
                                LastLineNo += 10000;
                                // Clear(GenJournalTemp);
                                GenJournalTemp.Init();
                                WHTPostingGroup.SetRange(Code, PaymentLine."WHT Code");
                                if WHTPostingGroup.FindFirst() then;
                                GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                                GenJournalTemp."Journal Batch Name" := lvGenBatchName;
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp."Line No." := LastLineNo;
                                GenJournalTemp.Validate("Posting Date", PaymentHeader."Posting Date");
                                GenJournalTemp.Validate("Document No.", PaymentHeader."PV No.");
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                                GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                                GenJournalTemp.Validate("Account No.", WHTPostingGroup."Payable WHT Account Code");
                                GenJournalTemp.Amount := -1 * PaymentLine."WHT Amount";
                                //GenJournalTemp."Amount (LCY)" := -1 * PaymentLine."WHT Amount (LCY)";
                                GenJournalTemp."Applies-to ID" := '';
                                GenJournalTemp.Validate("Currency Code", PaymentLine."Currency Code");
                                GenJournalTemp.Validate("Currency Factor", PaymentLine."Currency Factor");
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                                GenJournalTemp.Payee := PaymentHeader."Payee Name";

                                //Assign the source code for payment requisitions
                                if SourceCodeSetup."Payment Requisition" <> '' then
                                    GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                                GenJournalTemp.Insert(true);
                            end;

                            if PaymentLine."WHT on VAT Amount" <> 0 then begin
                                LastLineNo += 10000;
                                // Clear(GenJournalTemp);
                                GenJournalTemp.Init();
                                GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                                GenJournalTemp."Journal Batch Name" := lvGenBatchName;
                                GenJournalTemp."Created From Requisition" := true;
                                GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                                GenJournalTemp."Line No." := LastLineNo;
                                GenJournalTemp.Validate("Account Type", GenJournalTemp."Account Type"::"G/L Account");
                                GenJournalTemp."Document Type" := GenJournalTemp."Document Type"::" ";
                                GenJournalTemp.Validate("Posting Date", PaymentHeader."Posting Date");
                                GenJournalTemp.Validate("Document No.", PaymentHeader."PV No.");
                                GenJournalTemp.Validate("Account No.", WHTPostingGroup."WHT On VAT Account No.");
                                GenJournalTemp.Amount := -1 * PaymentLine."WHT on VAT Amount";
                                GenJournalTemp.Description := PaymentHeader.Purpose;
                                //GenJournalTemp."Amount (LCY)" := -1 * PaymentLine."WHT on VAT Amount (LCY)";
                                GenJournalTemp."Applies-to ID" := '';
                                GenJournalTemp.Validate("Currency Code", PaymentLine."Currency Code");
                                GenJournalTemp.Validate("Currency Factor", PaymentLine."Currency Factor");
                                GenJournalTemp."External Document No." := PaymentHeader."Ext Document No";
                                GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                                GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                                GenJournalTemp.Payee := PaymentHeader."Payee Name";

                                //Assign the source code for payment requisitions
                                if SourceCodeSetup."Payment Requisition" <> '' then
                                    GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                                GenJournalTemp.Insert(true);
                            end;

                            // Balancing bank line
                            LastLineNo += 10000;
                            Clear(GenJournalTemp);
                            GenJournalTemp.Init();
                            GenJournalTemp."Journal Template Name" := PaymentSetup."Requisition Journal Template";
                            GenJournalTemp."Journal Batch Name" := lvGenBatchName;
                            GenJournalTemp."Line No." := LastLineNo;
                            GenJournalTemp."Created From Requisition" := true;
                            GenJournalTemp."Payment Requisition No." := PaymentHeader."No.";
                            GenJournalTemp."Account Type" := GenJournalTemp."Account Type"::"Bank Account";
                            GenJournalTemp.Description := PaymentHeader.Purpose;
                            GenJournalTemp."Account No." := PaymentHeader."Bank Account No";
                            GenJournalTemp.Payee := PaymentHeader."Payee Name";
                            GenJournalTemp.Amount := -1 * PaymentLine."Amount To Pay";
                            GenJournalTemp."Posting Date" := PaymentHeader."Posting Date";
                            GenJournalTemp."Document No." := PaymentHeader."PV No.";
                            GenJournalTemp."Work Plan" := PaymentLine."WorkPlan No";
                            GenJournalTemp."Work Plan Entry No." := PaymentLine."WorkPlan Entry No";
                            GenJournalTemp."Budget Name" := PaymentLine."Budget Code";

                            //GenJournalTemp."Amount (LCY)" := -1 * ROUND(PaymentLine."Amount To Pay (LCY)", 0.02, '>');
                            GenJournalTemp.Validate("Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 1 Code");
                            GenJournalTemp."External Document No." := "Ext Document No";
                            GenJournalTemp.Validate("Shortcut Dimension 2 Code", PaymentLine."Shortcut Dimension 2 Code");
                            GenJournalTemp.Validate("Dimension Set ID", PaymentLine."Dimension Set ID");
                            GenJournalTemp."Applies-to ID" := '';
                            GenJournalTemp.Validate("Currency Code", Rec."Currency Code");
                            GenJournalTemp.Validate("Currency Factor", Rec."Currency Factor");

                            //Assign the source code for payment requisitions
                            if SourceCodeSetup."Payment Requisition" <> '' then
                                GenJournalTemp."Source Code" := SourceCodeSetup."Payment Requisition";

                            GenJournalTemp.Insert(true);
                            PaymentLineTemp.TransferFields(PaymentLine);
                            PaymentLineTemp.Insert();
                            PaymentLineTemp."Amount Paid" += PaymentLine."Amount To Pay";
                            PaymentLineTemp.Validate("Amount Paid");
                            PaymentLineTemp.Validate("Amount To Pay", (PaymentLineTemp.Amount - PaymentLineTemp."Amount Paid"));

                            PaymentLineTemp.Modify();
                        end;

                    until PaymentLine.Next() = 0;
                    //suming up all the bank balancing accounts
                    Clear(lvSumofBankAmount);
                    if PaymentLine."Account Type" <> GenJournalTemp2."Account Type"::"Bank Account" then begin
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        GenJournalTemp2.SetRange("Account Type", GenJournalTemp2."Account Type"::"Bank Account");
                        GenJournalTemp2.SetRange("Document No.", PaymentHeader."PV No.");
                        if GenJournalTemp2.FindSet() then
                            repeat
                                lvSumofBankAmount += GenJournalTemp2.Amount;
                            until GenJournalTemp2.Next() = 0;

                        // create a single balancing for bank
                        // Get last used no
                        Clear(LastLineNo);
                        GenJournalTemp2.Reset();
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        if GenJournalTemp2.FindLast() then
                            LastLineNo := GenJournalTemp2."Line No."
                        else
                            LastLineNo := 0;


                        GenJournalTemp2.Reset();
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        GenJournalTemp2.SetRange("Account Type", GenJournalTemp2."Account Type"::"Bank Account");
                        GenJournalTemp2.SetRange("Document No.", PaymentHeader."PV No.");
                        if GenJournalTemp2.FindFirst() then
                            GenJournalTemp3.Reset();
                        GenJournalTemp3.TransferFields(GenJournalTemp2);
                        LastLineNo += 10000;
                        GenJournalTemp3."Line No." := LastLineNo;
                        GenJournalTemp3.Validate(Amount, lvSumofBankAmount);
                        GenJournalTemp3.Insert(true);


                        // delete the bank account lines from the original journal
                        GenJournalTemp2.Reset();
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        GenJournalTemp2.SetRange("Account Type", GenJournalTemp2."Account Type"::"Bank Account");
                        GenJournalTemp2.SetRange("Document No.", PaymentHeader."PV No.");
                        GenJournalTemp2.SetFilter("Line No.", '<>%1', GenJournalTemp3."Line No.");
                        if (GenJournalTemp2.Count() >= 1) then
                            GenJournalTemp2.DeleteAll();
                    end else begin
                        GenJournalTemp2.Reset();
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        GenJournalTemp2.SetRange("Account Type", GenJournalTemp2."Account Type"::"Bank Account");
                        GenJournalTemp2.SetRange("Document No.", PaymentHeader."PV No.");

                        if GenJournalTemp2.FindSet() then
                            repeat
                                // sum up all negative amounts
                                if GenJournalTemp2.Amount < 0 then begin
                                    lvSumofBankAmount += GenJournalTemp2.Amount;
                                    GenJournalTemp2.Delete();
                                end;
                            until GenJournalTemp2.Next() = 0;

                        GenJournalTemp2.Reset();
                        GenJournalTemp3.Reset();
                        GenJournalTemp2.SetRange("Journal Template Name", PaymentSetup."Requisition Journal Template");
                        GenJournalTemp2.SetRange("Journal Batch Name", lvGenBatchName);
                        GenJournalTemp2.SetRange("Account Type", GenJournalTemp2."Account Type"::"Bank Account");
                        GenJournalTemp2.SetRange("Document No.", PaymentHeader."PV No.");
                        if GenJournalTemp2.FindFirst() then
                            GenJournalTemp3.Reset();
                        GenJournalTemp3.TransferFields(GenJournalTemp2);
                        LastLineNo += 10000;
                        GenJournalTemp3."Line No." := LastLineNo;
                        GenJournalTemp3.Validate(Amount, lvSumofBankAmount);
                        GenJournalTemp3.Insert(true);
                    end;
                    If PaymentLineTemp.FindSet() then
                        repeat
                            PaymentLine.SetRange("Document Type", PaymentLineTemp."Document Type");
                            PaymentLine.SetRange("Document No", PaymentLineTemp."Document No");
                            PaymentLine.SetRange("Line No", PaymentLineTemp."Line No");
                            if PaymentLine.FindFirst() then begin
                                PaymentLine := PaymentLineTemp;
                                PaymentLine.Modify();
                            end;
                        until PaymentLineTemp.Next() = 0;
                    Commit();

                    PaymentHeader.CalcFields("Total Amount", "Paid Amount");
                    if PaymentHeader."Paid Amount" > 0 then begin
                        PaymentHeader.Posted := true;
                        PaymentHeader.Modify();
                    end;
                    if PaymentSetup."Auto Archive Pay. Req" then
                        if PaymentHeader."Paid Amount" >= PaymentHeader."Total Amount" then
                            ArchivePayment(PaymentHeader);
                end;
            until PaymentHeader.Next() = 0;

        Message('Payment Requisition successfully transferred');

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

    procedure ArchivePayment(Header: Record "Payment Requisition Header")
    var
        PLine: Record "Payment Requisition Line";
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
                if ArchPLine."Payee Type" = ArchPLine."Payee Type"::Imprest then begin
                    ArchPLine.Validate("Amount Paid");
                    ArchPLine.Validate("Acc. Remaining Amount", ArchPLine."Amount Paid");
                end;

                ArchPLine.Insert(true);
            until PLine.Next() = 0;
        TransferAttachmentsToArchives(Rec);
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

    procedure CheckAttachments(RecHeader: Record "Payment Requisition Header"): Boolean
    var
        DocumentAtt: Record "Document Attachment";
    begin
        DocumentAtt.SetRange("Document Type", RecHeader."Document Type");
        DocumentAtt.SetRange("No.", RecHeader."No.");
        IF DocumentAtt.FindFirst() then
            exit(true)
        else
            EXIT(false);
    end;

    procedure TransferAttachmentsToArchives(var PaymentReqHeader: Record "Payment Requisition Header")
    var
        DocumentAttachments: Record "Document Attachment";
        DocumentAttachments_New: Record "Document Attachment";
    begin
        DocumentAttachments.SetRange("Table ID", Database::"Payment Requisition Header");
        DocumentAttachments.SetRange("No.", PaymentReqHeader."No.");
        if DocumentAttachments.FindSet() then
            repeat
                DocumentAttachments_New.Init();
                DocumentAttachments_New.TransferFields(DocumentAttachments);
                DocumentAttachments_New."Table ID" := Database::"Payment Req. Header Archive";
                DocumentAttachments_New."No." := PaymentReqHeader."No.";
                DocumentAttachments_New.Insert(true);
            until DocumentAttachments.Next() = 0;
    end;

    procedure CheckForPaymentReqLinesMandatoryFields(PaymentReqHeader: Record "Payment Requisition Header")
    var
        PaymentReqLines: Record "Payment Requisition Line";
    begin
        PaymentReqLines.Reset();
        PaymentReqLines.SetRange("Document Type", PaymentReqHeader."Document Type");
        PaymentReqLines.SetRange("Document No", PaymentReqHeader."No.");
        if PaymentReqLines.FindSet() then
            repeat
                PaymentReqLines.TestField(Description);
                PaymentReqLines.TestField("Amount (LCY)");
                if PaymentReqLines."WorkPlan No" <> '' then
                    PaymentReqLines.TestField("WorkPlan Entry No");
            until PaymentReqLines.Next() = 0;
    end;

    procedure CheckForSupplierAppliedDocuments(PaymentReqHeader: Record "Payment Requisition Header")
    var
        PaymentReqLines: Record "Payment Requisition Line";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        If PaymentReqHeader."Payee Type" = PaymentReqHeader."Payee Type"::Vendor then begin
            PaymentReqLines.Reset();
            PaymentReqLines.SetRange("Document Type", PaymentReqHeader."Document Type");
            PaymentReqLines.SetRange("Document No", PaymentReqHeader."No.");
            PaymentReqLines.SetRange("Account Type", PaymentReqLines."Account Type"::Vendor);
            if PaymentReqLines.FindSet() then
                repeat
                    VendLedgerEntry.Reset();
                    VendLedgerEntry.SetRange("Vendor No.", PaymentReqLines."Account No");
                    VendLedgerEntry.SetRange("Document Type", VendLedgerEntry."Document Type"::Invoice);
                    VendLedgerEntry.SetRange("Applies-to ID", PaymentReqLines."Document No");
                    if not VendLedgerEntry.FindFirst() then
                        Error('Atleast one posted invoice must be applied for supplier %1 before the voucher is posted.', PaymentReqHeader."Payee Name");
                until PaymentReqLines.Next() = 0;
        end;
    end;

    procedure UpdateLineStatus(var PaymentReqHeader: Record "Payment Requisition Header")
    var
        PaymentReqLine: Record "Payment Requisition Line";
    begin
        PaymentReqLine.SetRange("Document Type", PaymentReqHeader."Document Type");
        PaymentReqLine.SetRange("Document No", PaymentReqHeader."No.");
        If PaymentReqLine.FindSet() then
            repeat
                PaymentReqLine.Status := PaymentReqHeader.Status;
                PaymentReqLine.Modify();
            until PaymentReqLine.Next() = 0;
    end;

    procedure TestOpen(var PaymentHeader: Record "Payment Requisition Header")
    begin
        PaymentHeader.TestField(Status, PaymentHeader.Status::Open);
    end;

    procedure PRBudgetCheck(var PaymentHeader: Record "Payment Requisition Header")
    var
        lvPaymentReqLine: Record "Payment Requisition Line";
    begin
        lvPaymentReqLine.reset();
        lvPaymentReqLine.SetRange("Document Type", lvPaymentReqLine."Document Type"::"Payment Requisition", lvPaymentReqLine."Document Type"::"Petty Cash");
        lvPaymentReqLine.SetRange("Document No", PaymentHeader."No.");
        if lvPaymentReqLine.FindSet() then
            repeat
                lvPaymentReqLine.BudgetCheck(lvPaymentReqLine."Amount (LCY)", lvPaymentReqLine."Line No");
            until lvPaymentReqLine.Next() = 0;
    end;

    procedure PaymentLineExist(): Boolean
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", "Document Type");
        PaymentLine.SetRange("Document No", "No.");
        exit(not PaymentLine.IsEmpty);
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
        IsHandled: Boolean;
        lvRequestLine: Record "Payment Requisition Line";
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;

        lvRequestLine.Reset();
        lvRequestLine.SetRange("Document Type", "Document Type");
        lvRequestLine.SetRange("Document No", "No.");
        lvRequestLine.LockTable();
        if lvRequestLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(lvRequestLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if lvRequestLine."Dimension Set ID" <> NewDimSetID then begin
                    lvRequestLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      lvRequestLine."Dimension Set ID", lvRequestLine."Shortcut Dimension 1 Code", lvRequestLine."Shortcut Dimension 2 Code");

                    lvRequestLine.Modify();
                end;
            until lvRequestLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPaymentApprovalRequest(var RecRef: RecordRef; SenderUserID: Code[50])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPaymentApprovalRequest(var PaymentReqHeader: Record "Payment Requisition Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewPaymentApprovalHistory(var PaymentReqHeader: Record "Payment Requisition Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewPaymentComments(var PaymentReqHeader: Record "Payment Requisition Header")
    begin
    end;

}