codeunit 50300 "POS Management"
{
    procedure GetSetup(var POSSetup: Record "POS Setup")
    begin
        POSSetup.Reset();
        if not POSSetup.Get('POS') then
            Error('POS Setup has not been created.');
    end;

    procedure EnsureCashier(UserIDValue: Code[50])
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserIDValue) then
            Error('User Setup does not exist for %1.', UserIDValue);

        if not (UserSetup."POS Cashier" or UserSetup."POS Supervisor") then
            Error('User %1 is not configured as a POS cashier or supervisor.', UserIDValue);
    end;

    procedure EnsureSupervisor(UserIDValue: Code[50])
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserIDValue) then
            Error('User Setup does not exist for %1.', UserIDValue);

        UserSetup.TestField("POS Supervisor", true);
    end;

    procedure IsSupervisor(UserIDValue: Code[50]): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserIDValue) then
            exit(false);

        exit(UserSetup."POS Supervisor");
    end;

    procedure ApplyTransactionVisibilityFilter(var POSTransactionHeader: Record "POS Transaction Header")
    begin
        EnsureCashier(UserId);
        if not IsSupervisor(UserId) then
            POSTransactionHeader.SetRange("Cashier User ID", UserId);
    end;

    procedure ApplySessionVisibilityFilter(var POSSession: Record "POS Session")
    begin
        EnsureCashier(UserId);
        if not IsSupervisor(UserId) then
            POSSession.SetRange("User ID", UserId);
    end;

    procedure EnsureTransactionAccess(var POSTransactionHeader: Record "POS Transaction Header")
    begin
        EnsureCashier(UserId);
        if IsSupervisor(UserId) then
            exit;

        if POSTransactionHeader."Cashier User ID" <> UserId then
            Error('You can only access your own POS transactions.');
    end;

    procedure EnsureSessionAccess(var POSSession: Record "POS Session")
    begin
        EnsureCashier(UserId);
        if IsSupervisor(UserId) then
            exit;

        if POSSession."User ID" <> UserId then
            Error('You can only access your own POS sessions.');
    end;

    procedure GetOpenSession(UserIDValue: Code[50]; var POSSession: Record "POS Session"): Boolean
    begin
        POSSession.Reset();
        POSSession.SetRange("User ID", UserIDValue);
        POSSession.SetRange(Status, POSSession.Status::Open);
        exit(POSSession.FindFirst());
    end;

    procedure CreateTransaction(TransactionType: Option Sale,Return; var POSTransactionHeader: Record "POS Transaction Header")
    begin
        EnsureCashier(UserId);

        POSTransactionHeader.Init();
        POSTransactionHeader."Transaction Type" := TransactionType;
        POSTransactionHeader.Insert(true);
    end;

    procedure RefreshSessionCash(var POSSession: Record "POS Session")
    var
        POSTransactionHeader: Record "POS Transaction Header";
        POSPaymentLine: Record "POS Payment Line";
        ExpectedCash: Decimal;
        CashTendered: Decimal;
        CashRefunded: Decimal;
    begin
        ExpectedCash := POSSession."Opening Float";

        POSTransactionHeader.SetRange("POS Session No.", POSSession."No.");
        POSTransactionHeader.SetRange(Status, POSTransactionHeader.Status::Posted);
        if POSTransactionHeader.FindSet() then
            repeat
                POSPaymentLine.SetRange("Document No.", POSTransactionHeader."No.");
                POSPaymentLine.SetRange("Payment Method", POSPaymentLine."Payment Method"::Cash);

                POSPaymentLine.SetRange("Payment Type", POSPaymentLine."Payment Type"::Payment);
                POSPaymentLine.CalcSums(Amount);
                CashTendered := POSPaymentLine.Amount;

                POSPaymentLine.SetRange("Payment Type", POSPaymentLine."Payment Type"::Refund);
                POSPaymentLine.CalcSums(Amount);
                CashRefunded := POSPaymentLine.Amount;

                // Subtract change given back to customer (change is always in cash)
                ExpectedCash += CashTendered - POSTransactionHeader."Change Amount" - CashRefunded;
            until POSTransactionHeader.Next() = 0;

        POSSession."Expected Cash" := ExpectedCash;
        POSSession."Cash Variance" := POSSession."Counted Cash" - POSSession."Expected Cash";
        POSSession.Modify(true);
    end;

    procedure CloseSession(var POSSession: Record "POS Session")
    var
        POSSetup: Record "POS Setup";
    begin
        GetSetup(POSSetup);
        RefreshSessionCash(POSSession);
        POSSession.TestField(Status, POSSession.Status::Open);
        POSSession.TestField("Counted Cash");

        POSSession."Cash Variance" := POSSession."Counted Cash" - POSSession."Expected Cash";
        if POSSession."Cash Variance" <> 0 then
            POSSession.TestField("Variance Reason");

        if Abs(POSSession."Cash Variance") > POSSetup."Session Variance Threshold" then begin
            EnsureSupervisor(UserId);
            POSSession."Closed By Supervisor" := UserId;
        end;

        POSSession.Status := POSSession.Status::Closed;
        POSSession."Closed At" := CurrentDateTime;
        POSSession.Modify(true);
    end;

    procedure ValidateTransaction(var POSTransactionHeader: Record "POS Transaction Header")
    var
        POSLine: Record "POS Transaction Line";
        POSPaymentLine: Record "POS Payment Line";
        HasCashPayment: Boolean;
    begin
        POSTransactionHeader.CalcFields("Total Amount", "Tendered Amount", "Refund Amount");
        POSTransactionHeader.TestField("POS Session No.");
        POSTransactionHeader.TestField("Customer No.");

        POSLine.SetRange("Document No.", POSTransactionHeader."No.");
        if not POSLine.FindFirst() then
            Error('Transaction %1 does not contain any lines.', POSTransactionHeader."No.");

        POSPaymentLine.SetRange("Document No.", POSTransactionHeader."No.");
        if not POSPaymentLine.FindSet() then
            Error('Transaction %1 does not contain any payment lines.', POSTransactionHeader."No.");

        repeat
            POSPaymentLine.ValidateLine();
            if POSPaymentLine."Payment Method" = POSPaymentLine."Payment Method"::Cash then
                HasCashPayment := true;
        until POSPaymentLine.Next() = 0;

        if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then begin
            if POSTransactionHeader."Tendered Amount" < POSTransactionHeader."Total Amount" then
                Error('Tendered Amount (%1) must be at least the Total Amount (%2).', POSTransactionHeader."Tendered Amount", POSTransactionHeader."Total Amount");

            if (POSTransactionHeader."Change Amount" > 0) and (not HasCashPayment) then
                Error('Change can only be given when the transaction includes a cash payment line.');
        end else begin
            if POSTransactionHeader."Original Receipt No." = '' then
                Error('Original Receipt No. is required for returns.');

            if POSTransactionHeader."Refund Amount" <> POSTransactionHeader."Total Amount" then
                Error('Refund Amount (%1) must equal the Total Amount (%2).', POSTransactionHeader."Refund Amount", POSTransactionHeader."Total Amount");
        end;
    end;

    procedure SuspendTransaction(var POSTransactionHeader: Record "POS Transaction Header")
    begin
        POSTransactionHeader.TestField(Status, POSTransactionHeader.Status::Open);
        POSTransactionHeader.Status := POSTransactionHeader.Status::Suspended;
        POSTransactionHeader.Modify(true);
    end;

    procedure ResumeTransaction(var POSTransactionHeader: Record "POS Transaction Header")
    begin
        POSTransactionHeader.TestField(Status, POSTransactionHeader.Status::Suspended);
        if POSTransactionHeader."Cashier User ID" <> UserId then
            Error('Only the cashier who created the transaction can resume it.');

        POSTransactionHeader.Status := POSTransactionHeader.Status::Open;
        POSTransactionHeader.Modify(true);
    end;

    procedure PrintReceipt(var POSTransactionHeader: Record "POS Transaction Header")
    var
        POSSetup: Record "POS Setup";
        ReceiptTransaction: Record "POS Transaction Header";
    begin
        EnsureTransactionAccess(POSTransactionHeader);
        POSTransactionHeader.TestField(Status, POSTransactionHeader.Status::Posted);
        GetSetup(POSSetup);

        if (POSTransactionHeader."Receipt Print Count" > 0) and (not POSSetup."Allow Receipt Reprint") then
            Error('Receipt reprint is disabled in POS Setup.');

        POSTransactionHeader."Receipt Print Count" += 1;
        POSTransactionHeader."Last Receipt Printed At" := CurrentDateTime;
        POSTransactionHeader.Modify(true);
        Commit();

        ReceiptTransaction.SetRange("No.", POSTransactionHeader."No.");
        Report.RunModal(Report::"POS Receipt", true, false, ReceiptTransaction);
    end;
}
