table 50011 "Payment Req. Header Archive"
{

    DataClassification = ToBeClassified;
    Permissions = tabledata "Cust. Ledger Entry" = m;

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
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Type".Code;
            trigger OnValidate()
            var
                PayType: Record "Payment Type";
            begin
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
            TableRelation = IF ("Payee Type" = filter(Customer)) Customer
            ELSE
            IF ("Payee Type" = CONST(Vendor)) Vendor
            else
            IF ("Payee Type" = CONST(Bank)) "Bank Account";

            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
                GLAccRec: Record "G/L Account";
                BankRec: Record "Bank Account";
                EmployeeLedger: Record "Employee Ledger Entry";
            begin
                /*
                if "Payee Type" = "Payee Type"::"Statutory Body" then
                    Error('Payment Type of Statutory does not require Payee No');
                */
                If CustRec.GET("Payee No") then
                    "Payee Name" := CustRec.Name;

                IF VendorRec.GET("Payee No") then begin
                    VendorRec.TestField("WHT Posting Group");
                    "Payee Name" := VendorRec.Name;
                end;

                IF GLAccRec.GET("Payee No") then
                    "Payee Name" := GLAccRec.Name;

                IF BankRec.GET("Payee No") then
                    "Payee Name" := BankRec.Name;
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

            //OptionMembers = "Payment Requisition";
        }
        field(9; "WorkPlan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No." where("Shortcut Dimension 1 Code" = field("Global Dimension 1 Code"), Blocked = const(false), Status = const(Approved), "Transferred To Budget" = const(true));
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
        }
        field(15; "Total Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Payment Req Line Archive"."Amount Paid" where("Document No" = field("No.")));
            Caption = 'Total Amount';
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
            CalcFormula = Sum("Payment Req Line Archive"."Amount To Pay" WHERE("Document No" = FIELD("No.")));
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
        field(37; Processed; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Paid Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Payment Req Line Archive"."Amount Paid" WHERE("Document No" = FIELD("No.")));
            Caption = 'Paid Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(40; "PV No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; Accountability; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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

        field(50; "Archive No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Archived By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Archive Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(53; Accounted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56; Reversed; Boolean)
        {
        }
        field(58; Rejected; Boolean)
        {
        }
        field(60; "Total WHT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Req Line Archive"."WHT Amount" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(62; "Total WHT Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Req Line Archive"."WHT Amount (LCY)" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(64; "Total WHT on VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Req Line Archive"."WHT on VAT Amount" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(66; "Total WHT on VAT (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Req Line Archive"."WHT on VAT Amount (LCY)" where("Document Type" = field("Document Type"), "Document No" = field("No.")));
        }
        field(67; "Travel Start Date"; Date)
        {
            DataClassification = ToBeClassified;

        }

        field(68; "Travel End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Destination"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(70; Delegatee; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(71; Staff; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Request No."; Code[20])
        {

        }
        field(74; "Registered MM Number"; Text[30])
        {
            Caption = 'Registered Mobile Money Number';
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

        }

        field(80; "Accountability Posting No."; Code[20])
        {
            Editable = false;
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
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

        }
        field(490; "Amount Not Accounted"; Decimal)
        {
            Caption = 'Total Amount Not Accounted';
            FieldClass = FlowField;
            CalcFormula = sum("Payment Req Line Archive"."Acc. Remaining Amount (LCY)" where("Document No" = field("No."), "Document Type" = field("Document Type")));
        }
        field(491; "Accountability Undone"; Boolean)
        {
            Caption = 'Accountability Undone';
        }
        field(492; "Acct. Undone By"; Code[50])
        {
            Caption = 'Accountability Undone By';
        }
        field(493; "Acct. Undone On"; DateTime)
        {
            Caption = 'Accountability Undone On';
        }
        field(50000; "System Id"; Guid) { }


    }
    keys
    {
        key(Key1; "Archive No")
        {
            Clustered = true;
        }
    }

    var
        GenReqSetup: Record "Gen. Requisition Setup";
        GenLedSetup: Record "General Ledger Setup";
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

    procedure InitInsert(var Header: Record "Payment Req. Header Archive")
    var
    begin
        GenReqSetup.Get();
        if "Archive No" = '' then begin
            GenReqSetup.TestField("Payment Req. Archive Nos.");
            Rec."Archive No" := NoSeriesMgt.GetNextNo(GenReqSetup."Payment Req. Archive Nos.", Today, true);
            Header."Archived By" := UserId;
            Header."Archive Date" := Today;
        end;
    end;

    // Edited functionality
    procedure CreateAccountability(ArchHeader: Record "Payment Req. Header Archive")
    var
        ArchiveLine: Record "Payment Req Line Archive";
        ArchiveLine2: Record "Payment Req Line Archive";
        AccountabilityHeader: Record "Accountability Header";
        AccountabilitySpecification: Record "Accountability Specifications";
        AccountabilityLine: Record "Accountability Line";
        AccLine: Record "Accountability Line";
        GenReqtnSetup: Record "Gen. Requisition Setup";
        NextDocNo: Code[20];
        FullyAccounted: Boolean;
        iterable: Integer;
        LineNoAmountDictionary: Dictionary of [Integer, Decimal];
        DictionaryValue: Decimal;
        LNo: Integer;
    begin

        TestField("Payee Type", "Payee Type"::Imprest);
        if Accounted then begin
            Message('This Imprest has already been accounted for');
            exit;
        end;

        foreach iterable in LineNoAmountDictionary.keys do
            LineNoAmountDictionary.Remove(iterable);

        clear(NextDocNo);
        GenReqtnSetup.Get();
        AccountabilityHeader.Init();
        NextDocNo := NoSeriesMgt.GetNextNo(GenReqtnSetup."Accountability Nos.", TODAY, true);
        AccountabilityHeader.TransferFields(ArchHeader);
        AccountabilityHeader."No." := NextDocNo;
        AccountabilityHeader."Document Type" := AccountabilityHeader."Document Type"::Accountability;
        AccountabilityHeader."Requisition No." := ArchHeader."No.";
        AccountabilityHeader."Accountability Posting No." := NextDocNo;
        AccountabilityHeader.Status := AccountabilityHeader.Status::Open;
        AccountabilityHeader.Accountability := true;
        AccountabilityHeader."Created By" := UserId;
        AccountabilityHeader.Insert();

        Accline.Reset();
        Accline.setRange("Document No", AccountabilityHeader."No.");
        if Accline.FindLast() then
            LNo := Accline."Line No" + 1000
        else
            LNo := 1000;

        // Specifications usage
        AccountabilitySpecification.Reset();
        AccountabilitySpecification.SetRange("Document No", ArchHeader."No.");
        AccountabilitySpecification.SetRange("Archive No.", ArchHeader."Archive No");
        AccountabilitySpecification.Setfilter(Amount, '<>%1', 0);
        if AccountabilitySpecification.FindSet() then
            repeat
                ArchiveLine.SetRange("Document No", ArchHeader."No.");
                ArchiveLine.setRange("Line No", AccountabilitySpecification."Originating Line No");
                ArchiveLine.SetFilter(Accounted, '=%1', false);
                ArchiveLine.SetFilter("Amount to Account", '>%1', 0);
                if ArchiveLine.FindFirst() then begin
                    AccountabilityLine.Init();
                    AccountabilityLine.TransferFields(ArchiveLine);
                    AccountabilityLine."Document No" := NextDocNo;
                    AccountabilityLine."Line No" := LNo;
                    AccountabilityLine."Document Type" := AccountabilityLine."Document Type"::Accountability;
                    AccountabilityLine."Related PR Line No" := AccountabilitySpecification."Originating Line No";
                    AccountabilityLine."Related PR No" := AccountabilitySpecification."Document No";
                    if AccountabilitySpecification."Accountability Option" = AccountabilitySpecification."Accountability Option"::Return then begin
                        AccountabilitySpecification.Testfield("Bank Account No.");
                        AccountabilityLine."Account Type" := AccountabilityLine."Account Type"::"Bank Account";
                        AccountabilityLine."Account No" := AccountabilitySpecification."Bank Account No.";
                        AccountabilityLine."Account Name" := AccountabilitySpecification."Bank Account Name";
                    end;
                    AccountabilityLine.Validate(Rate, AccountabilitySpecification.Amount);
                    AccountabilityLine.Validate(Amount, AccountabilitySpecification.Amount);
                    AccountabilityLine.Validate("Amount To Pay", AccountabilitySpecification.Amount);
                    AccountabilityLine.Validate("Amount Paid", 0);
                    AccountabilityLine."Generated From PR" := true;
                    if AccountabilityLine.Insert(true) then begin
                        ArchiveLine.Validate("Amount Accounted", (ArchiveLine."Amount Accounted" + AccountabilitySpecification.Amount));
                        ArchiveLine.Validate("Amount to Account", (ArchiveLine."Amount Paid" - ArchiveLine."Amount Accounted"));
                        if ArchiveLine."Amount Accounted" = ArchiveLine."Amount Paid" then
                            ArchiveLine.Accounted := true;
                        ArchiveLine.Modify();
                        // ApplyPaymentVoucher(AccountabilityHeader, AccountabilityLine, ArchHeader."PV No.");
                    end;
                    // Catering for a whole amount to apply on per line;
                    if not LineNoAmountDictionary.ContainsKey(AccountabilitySpecification."Originating Line No") then
                        LineNoAmountDictionary.Add(AccountabilitySpecification."Originating Line No", AccountabilitySpecification.Amount)
                    else begin
                        LineNoAmountDictionary.Get(AccountabilitySpecification."Originating Line No", DictionaryValue);
                        LineNoAmountDictionary.Set(AccountabilitySpecification."Originating Line No", DictionaryValue + AccountabilitySpecification.Amount);
                    end;
                    AccountabilitySpecification.Delete();
                    LNo += 1000;
                end;

            until AccountabilitySpecification.next() = 0;


        // Application
        foreach iterable in LineNoAmountDictionary.keys do begin
            LineNoAmountDictionary.Get(iterable, DictionaryValue);
            ApplyPaymentVoucher(AccountabilityHeader, iterable, DictionaryValue, ArchHeader."No.", ArchHeader."PV No.")
        end;




        Clear(FullyAccounted);
        ArchiveLine2.Reset();
        ArchiveLine2.SetRange("Document No", ArchHeader."No.");
        if ArchiveLine2.FindSet() then
            repeat
                if ArchiveLine2.Accounted then
                    FullyAccounted := true
                else
                    FullyAccounted := false;
            until ArchiveLine2.Next() = 0;

        if FullyAccounted then begin
            ArchHeader.Accounted := true;
            ArchHeader.Modify();
        end;

        AccountabilityHeader.Reset();
        AccountabilityHeader.SetRange("Document Type", AccountabilityHeader."Document Type"::Accountability);
        AccountabilityHeader.SetRange("No.", NextDocNo);
        if AccountabilityHeader.FindFirst() then;
        if GuiAllowed then
            if not confirm('Accountability ' + AccountabilityHeader."No." + ' has been successfully created. Do you want to open the created accountability?') then
                exit
            else
                Page.run(Page::"Accountability Card", AccountabilityHeader);
    end;
    // Original Functionality
    // procedure CreateAccountability(ArchHeader: Record "Payment Req. Header Archive")
    // var
    //     ArchiveLine: Record "Payment Req Line Archive";
    //     ArchiveLine2: Record "Payment Req Line Archive";
    //     AccountabilityHeader: Record "Accountability Header";
    //     AccountabilityLine: Record "Accountability Line";
    //     GenReqtnSetup: Record "Gen. Requisition Setup";
    //     NextDocNo: Code[20];
    //     FullyAccounted: Boolean;
    // begin

    //     TestField("Payee Type", "Payee Type"::Imprest);
    //     if Accounted then begin
    //         Message('This Imprest has already been accounted for');
    //         exit;
    //     end;

    //     clear(NextDocNo);
    //     GenReqtnSetup.Get();
    //     AccountabilityHeader.Init();
    //     NextDocNo := NoSeriesMgt.GetNextNo(GenReqtnSetup."Accountability Nos.", TODAY, TRUE);
    //     AccountabilityHeader.TransferFields(ArchHeader);
    //     AccountabilityHeader."No." := NextDocNo;
    //     AccountabilityHeader."Document Type" := AccountabilityHeader."Document Type"::Accountability;
    //     AccountabilityHeader."Requisition No." := ArchHeader."No.";
    //     AccountabilityHeader."Accountability Posting No." := NextDocNo;
    //     AccountabilityHeader.Status := AccountabilityHeader.Status::Open;
    //     AccountabilityHeader.Accountability := true;
    //     AccountabilityHeader."Created By" := UserId;
    //     AccountabilityHeader.Insert();
    //     ArchiveLine.SetRange("Document No", ArchHeader."No.");
    //     ArchiveLine.SetFilter(Accounted, '=%1', false);
    //     ArchiveLine.SetFilter("Amount to Account", '>%1', 0);
    //     if ArchiveLine.FindSet() then
    //         repeat
    //             AccountabilityLine.Init();
    //             AccountabilityLine.TransferFields(ArchiveLine);
    //             AccountabilityLine."Document No" := NextDocNo;
    //             AccountabilityLine."Document Type" := AccountabilityLine."Document Type"::Accountability;
    //             AccountabilityLine."Related PR Line No" := ArchiveLine."Line No";
    //             AccountabilityLine."Related PR No" := ArchiveLine."Document No";
    //             AccountabilityLine.Validate(Rate, ArchiveLine."Amount to Account");
    //             AccountabilityLine.Validate(Amount, ArchiveLine."Amount to Account");
    //             AccountabilityLine.Validate("Amount To Pay", ArchiveLine."Amount to Account");
    //             AccountabilityLine.Validate("Amount Paid", 0);
    //             AccountabilityLine."Generated From PR" := true;
    //             if AccountabilityLine.Insert(true) then begin
    //                 ArchiveLine.Validate("Amount Accounted", (ArchiveLine."Amount Accounted" + ArchiveLine."Amount to Account"));
    //                 ArchiveLine.Validate("Amount to Account", (ArchiveLine."Amount Paid" - ArchiveLine."Amount Accounted"));

    //                 if ArchiveLine."Amount Accounted" = ArchiveLine."Amount Paid" then
    //                     ArchiveLine.Accounted := true;
    //                 ArchiveLine.Modify();
    //                 ApplyPaymentVoucher(AccountabilityHeader, AccountabilityLine, ArchHeader."PV No.");
    //             end;
    //         until ArchiveLine.Next() = 0;

    //     Clear(FullyAccounted);
    //     ArchiveLine2.Reset();
    //     ArchiveLine2.SetRange("Document No", ArchHeader."No.");
    //     if ArchiveLine2.FindSet() then
    //         repeat
    //             if ArchiveLine2.Accounted then
    //                 FullyAccounted := true
    //             else
    //                 FullyAccounted := false;
    //         until ArchiveLine2.Next() = 0;

    //     if FullyAccounted then begin
    //         ArchHeader.Accounted := true;
    //         ArchHeader.Modify();
    //     end;

    //     AccountabilityHeader.Reset();
    //     AccountabilityHeader.SetRange("Document Type", AccountabilityHeader."Document Type"::Accountability);
    //     AccountabilityHeader.SetRange("No.", NextDocNo);
    //     if AccountabilityHeader.FindFirst() then;
    //     if GuiAllowed then
    //         if not confirm('Accountability ' + AccountabilityHeader."No." + ' has been successfully created. Do you want to open the created accountability?') then
    //             exit
    //         else
    //             Page.run(Page::"Accountability Card", AccountabilityHeader);
    // end;
    // Original Application
    // procedure ApplyPaymentVoucher(var AccountabilityHeader: Record "Accountability Header"; var AccountabilityLine: Record "Accountability Line"; paymentVoucherNo: code[20])
    // var
    //     lvCustomerLedgerEntry: Record "Cust. Ledger Entry";
    //     CurrExchRate: Record "Currency Exchange Rate";
    //     Currency: Record Currency;
    // begin
    //     lvCustomerLedgerEntry.Reset();
    //     lvCustomerLedgerEntry.SetCurrentKey("Document No.", "Customer No.", "Payment Req. Line No.", Open);
    //     lvCustomerLedgerEntry.SetRange("Customer No.", AccountabilityHeader."Payee No");
    //     lvCustomerLedgerEntry.SetRange("Document No.", paymentVoucherNo);
    //     lvCustomerLedgerEntry.SetRange("Payment Requisition No.", AccountabilityLine."Related PR No");
    //     lvCustomerLedgerEntry.SetRange("Payment Req. Line No.", AccountabilityLine."Related PR Line No");
    //     lvCustomerLedgerEntry.SetRange(Open, true);
    //     if lvCustomerLedgerEntry.FindFirst() then begin
    //         lvCustomerLedgerEntry.Validate("Applies-to ID", AccountabilityHeader."Accountability Posting No.");
    //         lvCustomerLedgerEntry.validate("Amount to Apply", AccountabilityLine.Amount);
    //         lvCustomerLedgerEntry."Amount to Apply" :=
    //        CurrExchRate.ExchangeAmount(
    //          lvCustomerLedgerEntry."Amount to Apply", lvCustomerLedgerEntry."Currency Code", AccountabilityHeader."Currency Code", AccountabilityHeader."Posting Date");
    //         lvCustomerLedgerEntry."Amount to Apply" :=
    //           Round(lvCustomerLedgerEntry."Amount to Apply", Currency."Amount Rounding Precision");
    //         lvCustomerLedgerEntry.Modify();
    //     end;
    // end;
    procedure ApplyPaymentVoucher(var AccountabilityHeader: Record "Accountability Header"; LineNo: Integer; Amt: Decimal; ReqnNo: Code[20]; PVNo: Code[20])
    var
        lvCustomerLedgerEntry: Record "Cust. Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        lvCustomerLedgerEntry.Reset();
        lvCustomerLedgerEntry.SetCurrentKey("Document No.", "Customer No.", "Payment Req. Line No.", Open);
        lvCustomerLedgerEntry.SetRange("Customer No.", AccountabilityHeader."Payee No");
        lvCustomerLedgerEntry.SetRange("Document No.", PVNo);
        lvCustomerLedgerEntry.SetRange("Payment Requisition No.", ReqnNo);
        lvCustomerLedgerEntry.SetRange("Payment Req. Line No.", LineNo);
        lvCustomerLedgerEntry.SetRange(Open, true);
        if lvCustomerLedgerEntry.FindFirst() then begin
            lvCustomerLedgerEntry.Validate("Applies-to ID", AccountabilityHeader."Accountability Posting No.");
            lvCustomerLedgerEntry.validate("Amount to Apply", Amt);
            lvCustomerLedgerEntry."Amount to Apply" :=
           CurrExchRate.ExchangeAmount(
             lvCustomerLedgerEntry."Amount to Apply", lvCustomerLedgerEntry."Currency Code", AccountabilityHeader."Currency Code", AccountabilityHeader."Posting Date");
            lvCustomerLedgerEntry."Amount to Apply" :=
              Round(lvCustomerLedgerEntry."Amount to Apply", Currency."Amount Rounding Precision");
            lvCustomerLedgerEntry.Modify();
        end;
    end;


}