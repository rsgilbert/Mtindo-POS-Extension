report 50300 "POS Receipt"
{
    Caption = 'POS Receipt';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/rdl/POS Receipt.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("POS Transaction Header"; "POS Transaction Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(ReceiptNo; "No.")
            {
            }
            column(TransactionType; Format("Transaction Type"))
            {
            }
            column(StatusText; Format(Status))
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(StoreCode; "POS Store Code")
            {
            }
            column(TerminalCode; "POS Terminal Code")
            {
            }
            column(CashierUserId; "Cashier User ID")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(OriginalReceiptNo; "Original Receipt No.")
            {
            }
            column(ApprovedBy; "Approved By")
            {
            }
            column(ApprovalReason; "Approval Reason")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(TenderedAmount; "Tendered Amount")
            {
            }
            column(RefundAmount; "Refund Amount")
            {
            }
            column(ChangeAmount; "Change Amount")
            {
            }
            column(CashAmount; CashAmount)
            {
            }
            column(CardAmount; CardAmount)
            {
            }
            column(MobileAmount; MobileAmount)
            {
            }
            column(CashRefundAmount; CashRefundAmount)
            {
            }
            column(CardRefundAmount; CardRefundAmount)
            {
            }
            column(MobileRefundAmount; MobileRefundAmount)
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
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            dataitem("POS Transaction Line"; "POS Transaction Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "POS Transaction Header";
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.")
                {
                }
                column(ItemNo; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitPrice; "Unit Price")
                {
                }
                column(LineDiscountPct; "Line Discount %")
                {
                }
                column(LineDiscountAmount; "Line Discount Amount")
                {
                }
                column(LineTotal; "Line Total")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Total Amount", "Tendered Amount", "Refund Amount");
                LoadPaymentSummary("POS Transaction Header");
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure LoadPaymentSummary(POSTransactionHeader: Record "POS Transaction Header")
    var
        POSPaymentLine: Record "POS Payment Line";
    begin
        Clear(CashAmount);
        Clear(CardAmount);
        Clear(MobileAmount);
        Clear(CashRefundAmount);
        Clear(CardRefundAmount);
        Clear(MobileRefundAmount);

        POSPaymentLine.SetRange("Document No.", POSTransactionHeader."No.");
        if POSPaymentLine.FindSet() then
            repeat
                case POSPaymentLine."Payment Type" of
                    POSPaymentLine."Payment Type"::Payment:
                        case POSPaymentLine."Payment Method" of
                            POSPaymentLine."Payment Method"::Cash:
                                CashAmount += POSPaymentLine.Amount;
                            POSPaymentLine."Payment Method"::Card:
                                CardAmount += POSPaymentLine.Amount;
                            POSPaymentLine."Payment Method"::Mobile:
                                MobileAmount += POSPaymentLine.Amount;
                        end;
                    POSPaymentLine."Payment Type"::Refund:
                        case POSPaymentLine."Payment Method" of
                            POSPaymentLine."Payment Method"::Cash:
                                CashRefundAmount += POSPaymentLine.Amount;
                            POSPaymentLine."Payment Method"::Card:
                                CardRefundAmount += POSPaymentLine.Amount;
                            POSPaymentLine."Payment Method"::Mobile:
                                MobileRefundAmount += POSPaymentLine.Amount;
                        end;
                end;
            until POSPaymentLine.Next() = 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        CashAmount: Decimal;
        CardAmount: Decimal;
        MobileAmount: Decimal;
        CashRefundAmount: Decimal;
        CardRefundAmount: Decimal;
        MobileRefundAmount: Decimal;
}
