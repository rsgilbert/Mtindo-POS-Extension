page 50027 "Payment Requisition Archive"
{
    PageType = Document;
    SourceTable = "Payment Req. Header Archive";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Requisitioned By"; Rec."Requisitioned By")
                {
                    ApplicationArea = All;
                }
                field("Payment Category"; Rec."Payment Category")
                {
                    ApplicationArea = All;
                }
                field("Pay. Subcategory"; Rec."Pay. Subcategory")
                {
                    ApplicationArea = All;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
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
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;

                }
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                }
                field("Prepared By Name"; Rec."Prepared By Name")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("File Number"; Rec."File Number")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
            group("Payment Lines")
            {
                part("Lines"; "Payment Req. Subform Archive")
                {
                    ApplicationArea = All;
                    SubPageLink = "Archive No" = field("Archive No");
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
            group(Related)
            {
                action("Approval History")
                {
                    ApplicationArea = All;
                    Image = History;
                    ToolTip = 'Shows the approval history of the payment requisition';
                    RunObject = page "Approval Entries";
                    RunPageLink = "Document Type" = filter("Payment Requisition"), "Document No." = field("No.");
                }
                action("PrintPV")
                {
                    ApplicationArea = All;
                    ToolTip = 'Prepare to Print the payment voucher';
                    Caption = 'Print Voucher';
                    Image = Print;

                    trigger OnAction()
                    var
                        PaymentHeader: Record "Payment Req. Header Archive";
                        PaymentReport: Report "Payment Voucher Archive";
                    begin
                        PaymentHeader.SetRange("No.", Rec."No.");
                        PaymentReport.SetTableView(PaymentHeader);
                        PaymentReport.Run();
                    end;
                }

                action("Account")
                {
                    ApplicationArea = All;
                    Caption = 'Create Accountability';
                    ToolTip = 'Create an accountability document based on the amount to account';
                    Image = SendApprovalRequest;
                    Visible = AccountAllowed;
                    trigger OnAction()
                    var
                        lvPaymentArchReqLine: Record "Payment Req Line Archive";
                    begin
                        lvPaymentArchReqLine.Reset();
                        lvPaymentArchReqLine.SetRange("Document No", Rec."No.");
                        lvPaymentArchReqLine.SetFilter("Amount to Account", '>%1', 0);
                        if lvPaymentArchReqLine.IsEmpty then
                            Error('At least one should have an amount to convert.');
                        if Confirm('Are you sure you would like to create an accountability from this requisition ?', false) then
                            Rec.CreateAccountability(Rec);
                        CurrPage.Close();
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = All;
                    Image = Attachments;
                    ToolTip = 'Shows the attachments for the archived document.';
                    trigger OnAction()
                    var
                        DocumentAttachments: Record "Document Attachment";
                        DocumentAttachmentsDetail: Page "Document Attachment custom";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachments.SetRange("Table ID", Database::"Payment Requisition Header", Database::"Accountability Header");
                        DocumentAttachments.SetRange("No.", Rec."No.");
                        DocumentAttachmentsDetail.SetTableView(DocumentAttachments);
                        DocumentAttachmentsDetail.RunModal();
                        DocumentAttachmentsDetail.Editable := false;
                    end;
                }
                action("Relating Attachments")
                {
                    ApplicationArea = All;
                    Caption = 'Related Document Attachments';
                    Image = Attachments;
                    ToolTip = 'Shows attachments relating to the supplier payment requisition';
                    Visible = RecTypeVendor;
                    trigger OnAction()
                    var
                        lvVendorLedgerEntry: Record "Vendor Ledger Entry";
                        lvVendorLedgerEntryPV: Record "Vendor Ledger Entry";
                        lvPurchInvHeader: Record "Purch. Inv. Header";
                        lvPurchInvHeader2: Record "Purch. Inv. Header";
                        lvDocAttachment: Record "Document Attachment";
                        lvDocAttachment2: Record "Document Attachment";
                        lvDocumentAttachmentDetails: Page "Document Attachment Custom";
                        DocNo: Text;
                        counter: Integer;

                    begin
                        Clear(counter);
                        DocNo := '';
                        lvVendorLedgerEntryPV.Reset();
                        lvVendorLedgerEntryPV.SetCurrentKey("Document No.");
                        lvVendorLedgerEntryPV.SetRange("Document No.", Rec."PV No.");
                        if lvVendorLedgerEntryPV.FindSet() then
                            repeat
                                lvVendorLedgerEntry.Reset();
                                lvVendorLedgerEntry.SetCurrentKey("Closed by Entry No.");
                                lvVendorLedgerEntry.SetRange("Closed by Entry No.", lvVendorLedgerEntryPV."Entry No.");
                                if lvVendorLedgerEntry.FindSet() then
                                    repeat
                                        counter += 1;
                                        lvDocAttachment.SetRange("No.", lvVendorLedgerEntry."Document No.");
                                        if lvDocAttachment.IsEmpty then begin
                                            lvPurchInvHeader.Reset();
                                            if lvPurchInvHeader.Get(lvVendorLedgerEntry."Document No.") then begin
                                                lvDocAttachment.SetRange("Table ID", Database::"Purchase Header");
                                                lvDocAttachment.SetRange("No.", lvPurchInvHeader."Order No.");
                                                if not lvDocAttachment.IsEmpty then begin
                                                    if counter = 1 then
                                                        DocNo := lvPurchInvHeader."Order No."
                                                    else
                                                        DocNo += '|' + lvPurchInvHeader."Order No.";
                                                end
                                                else begin
                                                    lvPurchInvHeader2.Reset();
                                                    lvPurchInvHeader2.SetCurrentKey("Order No.", "No.");
                                                    lvPurchInvHeader2.SetAscending("No.", true);
                                                    lvPurchInvHeader2.SetRange("Order No.", lvPurchInvHeader."Order No.");
                                                    if lvPurchInvHeader2.FindLast() then
                                                        if counter = 1 then
                                                            DocNo := lvPurchInvHeader2."No."
                                                        else
                                                            DocNo += '|' + lvPurchInvHeader2."No.";
                                                end;
                                            end;
                                        end
                                        else
                                            if counter = 1 then
                                                DocNo := lvVendorLedgerEntry."Document No."
                                            else
                                                DocNo += '|' + lvVendorLedgerEntry."Document No.";
                                    until lvVendorLedgerEntry.Next() = 0;
                                lvDocAttachment2.Reset();
                                if DocNo <> '' then begin
                                    lvDocAttachment2.SetFilter("No.", DocNo);
                                    lvDocAttachment2.FindSet();
                                    lvDocumentAttachmentDetails.SetTableView(lvDocAttachment2);
                                    lvDocumentAttachmentDetails.Editable := false;
                                    lvDocumentAttachmentDetails.RunModal();
                                end else
                                    Message('No Related Attachments found!!!');
                            until lvVendorLedgerEntryPV.Next() = 0;
                    end;
                }
            }

        }
    }
    var
        RecTypeVendor: Boolean;
        AccountAllowed: Boolean;

    trigger OnOpenPage()
    var
    begin
        if (Rec."Payee Type" = Rec."Payee Type"::Vendor) then
            RecTypeVendor := true
        else
            RecTypeVendor := false;

        if (Rec.Accounted = false and (Rec."Payee Type" = Rec."Payee Type"::Imprest) and (Rec.Posted = true)) then
            AccountAllowed := true
        else
            AccountAllowed := false;

    end;


    procedure printPaymentRequisition(paymentReqHeader: Record "Payment Req. Header Archive")
    var
        lvPaymentReqHeader: Record "Payment Req. Header Archive";
        lvPaymentVoucherReport: Report "Payment Requisition Archive";
    begin
        lvPaymentReqHeader.SetRange("No.", paymentReqHeader."No.");
        lvPaymentVoucherReport.SetTableView(lvPaymentReqHeader);
        lvPaymentVoucherReport.RunModal();
        Clear(lvPaymentVoucherReport);
    end;

}