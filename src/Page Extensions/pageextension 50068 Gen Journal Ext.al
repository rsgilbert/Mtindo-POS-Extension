pageextension 50068 "Gen Journal Ext." extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account No.")
        {
            field("Work Plan"; Rec."Work Plan")
            {
                Caption = 'Workplan No.';
                ApplicationArea = All;
            }
            field("Work Plan Entry No."; Rec."Work Plan Entry No.")
            {
                Caption = 'Workplan Entry No.';
                ApplicationArea = All;
            }
            field("FA Posting Type"; Rec."FA Posting Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(PrintPaymentVoucherPRFormat)
            {
                ApplicationArea = All;
                Caption = 'Print Payment Voucher';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print the payment voucher using the same layout as Payment Requisition.';

                trigger OnAction()
                begin
                    PrintPaymentVoucherFromJournal(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure PrintPaymentVoucherFromJournal(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalLineFilter: Record "Gen. Journal Line";
        PaymentVoucherJournalReport: Report "Payment Voucher Journal Print";
    begin
        GenJournalLineFilter.Copy(GenJournalLine);
        GenJournalLineFilter.SetRecFilter();
        PaymentVoucherJournalReport.SetTableView(GenJournalLineFilter);
        PaymentVoucherJournalReport.RunModal();
    end;
}
