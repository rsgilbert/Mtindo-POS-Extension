report 50035 "Update Arch. Payt. Req Lines"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Updated Archived Payment Requisition Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payment Req. Header Archive"; "Payment Req. Header Archive")
        {
            dataitem("Payment Req Line Archive"; "Payment Req Line Archive")
            {
                DataItemLinkReference = "Payment Req. Header Archive";
                DataItemLink = "Document Type" = field("Document Type"), "Document No" = field("No.");
                trigger OnAfterGetRecord()
                begin
                    if ("Amount Paid" > 0) and ("Acc. Remaining Amount" = 0) then begin
                        Validate("Acc. Remaining Amount", "Amount Paid");
                        Modify();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Payee Type", '=%1', "Payee Type"::Imprest);
                end;
            }

            trigger OnPreDataItem()
            begin
                SetFilter("Payee Type", '=%1', "Payee Type"::Imprest);
                SetFilter(Accounted, '=%1', false);
            end;
        }
    }

}