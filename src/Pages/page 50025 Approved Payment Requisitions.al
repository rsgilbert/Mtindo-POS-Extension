page 50025 "Approved Payment Requisitions"
{
    PageType = List;
    CardPageId = "Payment Requisition";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Requisition Header";
    SourceTableView = where(Status = filter(Approved), "Bank Transfer" = filter(false), "Document Type" = filter("Payment Requisition"));
    Editable = false;
    MultipleNewLines = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {


            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("PV No."; Rec."PV No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Transfer_Doc)
            {
                ApplicationArea = All;
                Caption = 'Transfer to Journal';
                Image = PostOrder;
                Visible = TransferDocVisibility;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;



                trigger OnAction()
                var
                    PaymentHeader: Record "Payment Requisition Header";
                    selectedPaymentHeader: Text;
                begin

                    // CurrPage.SetSelectionFilter(PaymentHeader);
                    // if PaymentHeader.IsEmpty then
                    //     Error('Please select the desired payment requisition to transfer to the journal.');

                    // if PaymentHeader."PV No." <> '' then
                    //     if PaymentHeader."Bank Account No" <> '' then
                    // 
                    clear(selectedPaymentHeader);
                    CurrPage.SetSelectionFilter(PaymentHeader);
                    if PaymentHeader.FindSet() then
                        repeat
                            if selectedPaymentHeader = '' then
                                selectedPaymentHeader := PaymentHeader."No."
                            else
                                selectedPaymentHeader := selectedPaymentHeader + '|' + Format(PaymentHeader."No.");
                        until PaymentHeader.Next() = 0;

                    Rec.PostPaymentForTransferToJournal(selectedPaymentHeader);
                    // repeat
                    //     if PaymentHeader."PV No." <> '' then
                    //         if PaymentHeader."Bank Account No" <> '' then
                    //             if PaymentHeader."Gen. Batch Name" <> '' then
                    //                 Message(PaymentHeader."No.");
                    // until PaymentHeader.Next() = 0;
                end;
            }
            action(Filter_To_Read_To_post)
            {
                ApplicationArea = all;
                Caption = 'Filter To Ready To Post';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                begin
                    Rec.SetRange("Status", paymReq.Status::Approved);
                    Rec.SetFilter("PV No.", '<>%1', '');
                    Rec.SetFilter("Bank Account No", '<>%1', ' ');
                    Rec.SetFilter("Gen. Batch Name", '<>%1', ' ');
                    // Rec.SetFilter("");
                    CurrPage.Update();

                end;


            }
        }
    }

    var
        paymReq: Record "Payment Requisition Header";
        IsTransferToJournal: Boolean;
        TransferDocVisibility: Boolean;




    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        UserSetup: Record "User Setup";
    begin
        GenReqSetup.Get();
        if GenReqSetup."Auto Transfer Approved Pay Req" then
            IsTransferToJournal := true;
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            if not UserSetup."View All Payment Reqs." then begin
                Rec.FilterGroup(10);
                REC.SetFilter("Created By", USERID);
                Rec.FilterGroup(0);
            end;
        if ((Rec.Status = Rec.Status::Approved) and (Rec."PV No." <> ' ') and (Rec."Bank Account No" <> '') and (Rec."Gen. Batch Name" <> '') and IsTransferToJournal) then
            TransferDocVisibility := true
        else
            TransferDocVisibility := false;
    end;


}