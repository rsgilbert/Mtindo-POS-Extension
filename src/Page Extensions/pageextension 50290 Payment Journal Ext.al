pageextension 50290 "Payment Journal Ext." extends "Payment Journal"
{
    layout
    {
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
        }
    }

    actions
    {
        modify("Print Payment Voucher")
        {
            Visible = false;
        }

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

    local procedure PrintPaymentVoucherFromJournal(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalLineFilter: Record "Gen. Journal Line";
        PaymentVoucherJournalReport: Report "Payment Voucher Journal Print";
    begin
        GenJournalLineFilter.Reset();
        GenJournalLineFilter.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLineFilter.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLineFilter.SetRange("Document No.", GenJournalLine."Document No.");
        PaymentVoucherJournalReport.SetTableView(GenJournalLineFilter);
        PaymentVoucherJournalReport.RunModal();
    end;
}
