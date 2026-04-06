report 50301 "POS Session Summary"
{
    Caption = 'POS Session Summary';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/rdl/POS Session Summary.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("POS Session"; "POS Session")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(SessionNo; "No.")
            {
            }
            column(StoreCode; "POS Store Code")
            {
            }
            column(TerminalCode; "POS Terminal Code")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(StatusText; Format(Status))
            {
            }
            column(OpenedAt; "Opened At")
            {
            }
            column(ClosedAt; "Closed At")
            {
            }
            column(OpeningFloat; "Opening Float")
            {
            }
            column(ExpectedCash; "Expected Cash")
            {
            }
            column(CountedCash; "Counted Cash")
            {
            }
            column(CashVariance; "Cash Variance")
            {
            }
            column(VarianceReason; "Variance Reason")
            {
            }
            column(ClosedBySupervisor; "Closed By Supervisor")
            {
            }
            column(SaleCount; SaleCount)
            {
            }
            column(ReturnCount; ReturnCount)
            {
            }
            column(SalesAmount; SalesAmount)
            {
            }
            column(ReturnAmount; ReturnAmount)
            {
            }
            column(CashSales; CashSales)
            {
            }
            column(CardSales; CardSales)
            {
            }
            column(MobileSales; MobileSales)
            {
            }
            column(CashRefunds; CashRefunds)
            {
            }
            column(CardRefunds; CardRefunds)
            {
            }
            column(MobileRefunds; MobileRefunds)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalculateSessionTotals("POS Session");
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure CalculateSessionTotals(var POSSession: Record "POS Session")
    var
        POSTransactionHeader: Record "POS Transaction Header";
        POSPaymentLine: Record "POS Payment Line";
    begin
        Clear(SaleCount);
        Clear(ReturnCount);
        Clear(SalesAmount);
        Clear(ReturnAmount);
        Clear(CashSales);
        Clear(CardSales);
        Clear(MobileSales);
        Clear(CashRefunds);
        Clear(CardRefunds);
        Clear(MobileRefunds);

        POSTransactionHeader.SetRange("POS Session No.", POSSession."No.");
        POSTransactionHeader.SetRange(Status, POSTransactionHeader.Status::Posted);
        if POSTransactionHeader.FindSet() then
            repeat
                POSTransactionHeader.CalcFields("Total Amount");
                if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then begin
                    SaleCount += 1;
                    SalesAmount += POSTransactionHeader."Total Amount";
                end else begin
                    ReturnCount += 1;
                    ReturnAmount += POSTransactionHeader."Total Amount";
                end;

                POSPaymentLine.SetRange("Document No.", POSTransactionHeader."No.");
                if POSPaymentLine.FindSet() then
                    repeat
                        case POSPaymentLine."Payment Type" of
                            POSPaymentLine."Payment Type"::Payment:
                                case POSPaymentLine."Payment Method" of
                                    POSPaymentLine."Payment Method"::Cash:
                                        CashSales += POSPaymentLine.Amount;
                                    POSPaymentLine."Payment Method"::Card:
                                        CardSales += POSPaymentLine.Amount;
                                    POSPaymentLine."Payment Method"::Mobile:
                                        MobileSales += POSPaymentLine.Amount;
                                end;
                            POSPaymentLine."Payment Type"::Refund:
                                case POSPaymentLine."Payment Method" of
                                    POSPaymentLine."Payment Method"::Cash:
                                        CashRefunds += POSPaymentLine.Amount;
                                    POSPaymentLine."Payment Method"::Card:
                                        CardRefunds += POSPaymentLine.Amount;
                                    POSPaymentLine."Payment Method"::Mobile:
                                        MobileRefunds += POSPaymentLine.Amount;
                                end;
                        end;
                    until POSPaymentLine.Next() = 0;

                // Subtract change given back to customer (change is always in cash)
                if POSTransactionHeader."Transaction Type" = POSTransactionHeader."Transaction Type"::Sale then
                    CashSales -= POSTransactionHeader."Change Amount";
            until POSTransactionHeader.Next() = 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        SaleCount: Integer;
        ReturnCount: Integer;
        SalesAmount: Decimal;
        ReturnAmount: Decimal;
        CashSales: Decimal;
        CardSales: Decimal;
        MobileSales: Decimal;
        CashRefunds: Decimal;
        CardRefunds: Decimal;
        MobileRefunds: Decimal;
}
