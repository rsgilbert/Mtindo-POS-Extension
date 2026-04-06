page 50022 "Payment Requisition"
{
    PageType = Document;
    SourceTable = "Payment Requisition Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Requisitioned By"; Rec."Requisitioned By")
                {
                    ApplicationArea = All;
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Category"; Rec."Payment Category")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        PaymentLine: Record "Payment Requisition Line";
                        lvPayType: Record "Payment Type";
                        lvPaySubType: Record "Payment Subcategory";
                        Txt001: Label 'Are you sure you would like to the change the Payment Type ?, it will clear the Payment Sub Catergory, Payee No, Payee Name and delete the Lines';
                    begin
                        if (xRec."Payment Category" <> '') AND (xRec."Payment Category" <> Rec."Payment Category") then begin
                            if not Confirm(Txt001, false) then begin
                                Rec."Payment Category" := xRec."Payment Category";
                                exit
                            end;
                            Clear(Rec."Pay. Subcategory");
                            Clear(Rec."Payee No");
                            Clear(Rec."Payee Name");
                            Clear(Rec."WorkPlan No");
                            Clear(Rec."Budget Code");
                            Clear(rec."Global Dimension 2 Code");
                            PaymentLine.SetRange("Document No", Rec."No.");
                            if PaymentLine.FindFirst() then
                                PaymentLine.DeleteAll(true);

                            Rec.ClearAppliedVendEntries();

                        end;
                        if lvPayType.Get(Rec."Payment Category") then
                            if lvPayType."Payee Type" IN [lvPayType."Payee Type"::Vendor, lvPayType."Payee Type"::Customer, lvPaySubType."Payee Type"::Bank, lvPaySubType."Payee Type"::Imprest] then begin
                                lvPaySubType.SetRange("Payment Type", Rec."Payment Category");
                                if lvPaySubType.FindFirst() then
                                    Rec.Validate("Pay. Subcategory", lvPaySubType.Code);
                            end;
                        if Rec."Pay. Subcategory" <> '' then begin
                            lvPaySubType.SetRange("Payment Type", Rec."Payment Category");
                            lvPaySubType.SetRange(Code, Rec."Payment Category");
                            if lvPaySubType.FindFirst() then
                                gvEditWorkPlan := lvPaySubType."Requires WorkPlan"
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Pay. Subcategory"; Rec."Pay. Subcategory")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        PaymentLine: Record "Payment Requisition Line";
                        Txt001: Label 'Are you sure you would like to the change the Payment Sub Category ?, it will clear the Payee No, Payee Name and delete the Lines';
                    begin
                        if (xRec."Pay. Subcategory" <> '') AND (xRec."Pay. Subcategory" <> Rec."Pay. Subcategory") then begin
                            if not Confirm(Txt001, false) then begin
                                Rec."Pay. Subcategory" := xRec."Pay. Subcategory";
                                exit
                            end;
                            Clear(Rec."Payee No");
                            Clear(Rec."Payee Name");
                            Clear(Rec."WorkPlan No");
                            Clear(Rec."Budget Code");
                            Clear(Rec."Global Dimension 2 Code");
                            PaymentLine.SetRange("Document No", Rec."No.");
                            if PaymentLine.FindFirst() then
                                PaymentLine.DeleteAll();

                            Rec.ClearAppliedVendEntries();

                        end;
                        CurrPage.Update();
                    end;
                }
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                    Editable = gvEditWorkPlan;
                    trigger OnValidate()
                    var
                        PaymentLine: Record "Payment Requisition Line";
                        Txt001: Label 'Are you sure you would like to the change the Work Plan ?, it will clear the Budget , Fundsource and delete the Lines';
                    begin
                        if (xRec."WorkPlan No" <> '') AND (xRec."WorkPlan No" <> Rec."WorkPlan No") then begin
                            if not Confirm(Txt001, false) then begin
                                Rec."WorkPlan No" := xRec."WorkPlan No";
                                exit
                            end;
                            PaymentLine.SetRange("Document No", Rec."No.");
                            if PaymentLine.FindFirst() then
                                PaymentLine.DeleteAll(true);
                        end;
                    end;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Payee No ?, it will clear the Payee Name and delete the Lines';
                        PaymentLine: Record "Payment Requisition Line";
                    begin
                        if (xRec."Payee No" <> '') AND (xRec."Payee No" <> Rec."Payee No") then begin
                            if not Confirm(Txt001, false) then begin
                                Rec."Payee No" := xRec."Payee No";
                                exit
                            end;
                            PaymentLine.SetRange("Document No", Rec."No.");
                            if PaymentLine.FindFirst() then
                                PaymentLine.DeleteAll(true);

                            Rec.ClearAppliedVendEntries();

                            if Rec."Payee Type" IN [Rec."Payee Type"::Bank, Rec."Payee Type"::Vendor] then
                                InitFirstLine();

                        end
                        else
                            if Rec."Payee Type" IN [Rec."Payee Type"::Bank, Rec."Payee Type"::Vendor] then
                                InitFirstLine();
                        CurrPage.Update();
                        if Rec."Payee No" <> '' then
                            EditPayeeName := false;
                    end;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    // Editable = Rec."Payee No" = '';
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the purchase document.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Mode Of Payment"; Rec."Mode Of Payment")
                {
                    ApplicationArea = all;
                    Visible = ApprovedStatusVisibility;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                    Editable = gvApproved;
                    Visible = ApprovedStatusVisibility;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Ext Document No"; Rec."Ext Document No")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Gen. Batch Name"; Rec."Gen. Batch Name")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Prepared By Name"; Rec."Prepared By Name")
                {
                    ApplicationArea = All;
                    Visible = ApprovedStatusVisibility;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("PV No."; Rec."PV No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ApprovedStatusVisibility;
                }

            }
            group(Lines)
            {
                part("Payment Lines"; "Payment Req. Subform")
                {
                    ApplicationArea = All;
                    SubPageLink = "Document Type" = field("Document Type"), "Document No" = field("No."), "WorkPlan No" = field("WorkPlan No"), "Budget Code" = field("Budget Code");
                }
            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Navigation)
        {
            action(PostDoc)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                // Visible = (Rec.Status = Rec.Status::Approved) and (not IsTrasnferToJournal);
                Visible = gvApproved and IsTrasnferToJournal;


                trigger OnAction()
                begin
                    Rec.PostPayment();
                end;
            }

            action(Transfer_Doc)
            {
                ApplicationArea = All;
                Caption = 'Transfer to Journal';
                Image = PostOrder;
                // Visible = (Rec.Status = Rec.Status::Approved) and IsTrasnferToJournal;
                Visible = gvApproved and IsTrasnferToJournal;

                trigger OnAction()
                begin
                    Rec.PostPaymentForTransferToJournal(Rec."No.");
                end;
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                // Enabled = Rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to payment documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Custom";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef, true);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
            action("Relating Attachments")
            {
                ApplicationArea = All;
                Caption = 'Related Document Attachments';
                Image = Attachments;
                ToolTip = 'Shows attachments relating to the supplier payment requisition';
                Visible = gvVendor;
                // Visible = Rec."Payee Type" = Rec."Payee Type"::Vendor;
                trigger OnAction()
                var
                    lvVendorLedgerEntry: Record "Vendor Ledger Entry";
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
                    lvVendorLedgerEntry.Reset();
                    lvVendorLedgerEntry.SetCurrentKey("Applies-to ID");
                    lvVendorLedgerEntry.SetRange("Applies-to ID", Rec."No.");
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
                end;
            }
            action(Comments)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = Comment;
                ToolTip = 'View comments related to this document.';

                trigger OnAction()
                var
                    ApprovalCommentLine: Record "Approval Comment Line";
                begin
                    ApprovalCommentLine.SetRange("Table ID", Database::"Payment Requisition Header");
                    ApprovalCommentLine.SetRange("Record ID to Approve", Rec.RecordId);
                    Page.run(Page::"Approval Comments", ApprovalCommentLine);
                end;
            }


        }
        area(Processing)
        {
            group(Approval)
            {
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.ApproveRecordRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.RejectRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the requested changes to the substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.DelegateRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action("Send Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Visible = gvOpen;
                    // Visible = (Rec.Status = Rec.Status::Open);

                    trigger OnAction()
                    begin
                        SendPaymentApprovalRequest(Rec, Subsciber.GetSenderUserID(''));
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = CanCancelApprovalForRecord;
                    // Visible = (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::"Pending Approval");
                    Enabled = CanCancelApprovalForRecord;

                    trigger OnAction()
                    begin
                        CancelPaymentApprovalRequest(Rec);
                    end;
                }

                action("Approval History")
                {
                    ApplicationArea = All;
                    Image = History;

                    RunObject = page "Approval Entries";
                    RunPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                }

                action("Archive Document")
                {
                    ApplicationArea = All;
                    Image = Archive;
                    Visible = gvApproved or gvApproved;
                    // Visible = (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::Open);
                    trigger OnAction()
                    var
                        Txt001: Label 'Are you really sure you would like to archive this requisition ?';
                    begin
                        if not Confirm(Txt001, false) then
                            exit;
                        Rec.ArchivePayment(Rec);
                    end;
                }
                action("Print PR")
                {
                    ApplicationArea = All;
                    Caption = 'Print Payment Requisition';
                    Image = Print;
                    Visible = false;
                    trigger OnAction()
                    var
                    begin
                        printPaymentRequisition(Rec);
                    end;
                }
                action("Print Activity Advance Report")
                {
                    ApplicationArea = All;
                    Caption = 'Print Activity Advance';
                    Image = Print;
                    Visible = false;
                    trigger OnAction()
                    var
                        lvPaymentReqHeader: Record "Payment Requisition Header";
                        lvActivityAdvanceForm: Report "Activity Advance Request";
                    begin
                        lvPaymentReqHeader.SetRange("No.", Rec."No.");
                        lvActivityAdvanceForm.SetTableView(lvPaymentReqHeader);
                        lvActivityAdvanceForm.RunModal();
                        Clear(lvActivityAdvanceForm);
                    end;
                }
                action("Print PV")
                {
                    ApplicationArea = All;
                    Caption = 'Print Payment Voucher';
                    Image = Print;
                    trigger OnAction()
                    var
                    begin
                        printPaymentVoucher(Rec);
                    end;
                }

            }
        }

    }

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        gvEditPayeeNo: Boolean;
        gvEditWorkPlan: Boolean;
        gvDate: Date;
        PurchOrder: Page "Purchase Order";
        EditPayeeName: Boolean;
        EditCostcenter: Boolean;
        StatusOpenVisibility: Boolean;
        ApprovedStatusVisibility: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        IsTrasnferToJournal: Boolean;
        Subsciber: Codeunit Subscriber;
        gvOpen: Boolean;
        gvPending: Boolean;
        gvApproved: Boolean;
        gvVendor: Boolean;

    procedure CheckApprovalActionControls()
    begin
        CanCancelApprovalForRecord := Subsciber.CanCancelApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExistForCurrUser := Subsciber.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;

    trigger OnAfterGetCurrRecord()
    var
        PaySubType: Record "Payment Subcategory";
    begin
        CheckApprovalActionControls();

        PaySubType.SetRange(Code, Rec."Pay. Subcategory");
        PaySubType.SetRange("Payment Type", Rec."Payment Category");
        if PaySubType.FindFirst() then
            gvEditWorkPlan := PaySubType."Requires WorkPlan";
    end;


    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        lvUserSetup: Record "User Setup";
    begin
        GenReqSetup.Get();
        EditPayeeName := true;

        lvUserSetup.Reset();
        lvUserSetup.SetRange("User ID", UserId);
        if lvUserSetup.FindFirst() then
            EditCostcenter := lvUserSetup."Edit Cost Center on Reqs";

        StatusOpenVisibility := Rec.Status = Rec.Status::Open;
        ApprovedStatusVisibility := Rec.Status = Rec.Status::Approved;


        IsTrasnferToJournal := GenReqSetup."Auto Transfer Approved Pay Req";
        if Rec.Status = Rec.Status::Open then gvOpen := true else gvopen := false;
        if Rec.Status = Rec.Status::"Pending Approval" then gvPending := true else gvPending := false;
        if Rec.Status = Rec.Status::Approved then gvApproved := true else gvApproved := false;
        if Rec."Payee Type" = Rec."Payee Type"::Vendor then gvVendor := true else gvVendor := false;


    end;

    trigger OnNewRecord(BelowXRec: Boolean)
    var
    begin
        Rec."Document Type" := Rec."Document Type"::"Payment Requisition";
    end;

    local procedure InitFirstLine()
    var
        PaymentLine: Record "Payment Requisition Line";
        PaymentLine2: Record "Payment Requisition Line";
        VendorRec: Record Vendor;
    begin
        PaymentLine2.SetRange("Document No", Rec."No.");
        if PaymentLine2.FindFirst() then
            PaymentLine2.DeleteAll();

        PaymentLine.Init();
        PaymentLine."Document No" := Rec."No.";
        PaymentLine."Document Type" := Rec."Document Type";
        PaymentLine."Line No" := 10000;
        PaymentLine."Payee Type" := Rec."Payee Type";
        if Rec."Payee Type" = Rec."Payee Type"::Bank then
            PaymentLine."Account Type" := PaymentLine."Account Type"::"Bank Account";

        if Rec."Payee Type" = Rec."Payee Type"::Imprest then begin
            Rec.TestField("WorkPlan No");
            PaymentLine."Account Type" := PaymentLine."Account Type"::Customer;
            PaymentLine.Validate("WorkPlan No", Rec."WorkPlan No");
            PaymentLine."Budget Code" := Rec."Budget Code";
        end;

        if Rec."Payee Type" = Rec."Payee Type"::Vendor then begin
            PaymentLine."Account Type" := PaymentLine."Account Type"::Vendor;
            VendorRec.GET(Rec."Payee No");
            PaymentLine."WHT Code" := VendorRec."WHT Posting Group";
        end;

        PaymentLine.Validate("Account No", Rec."Payee No");
        PaymentLine."Account Name" := Rec."Payee Name";
        PaymentLine.Description := Rec.Purpose;
        PaymentLine.Quantity := 1;
        PaymentLine.Insert(true);

    end;

    procedure SendPaymentApprovalRequest(var PaymentHeader: Record "Payment Requisition Header"; SenderUserID: Code[50])
    var
        RecRef: RecordRef;
    begin
        PaymentHeader.TestField("Payee Name");
        PaymentHeader.CalcFields("Total Amount");
        if PaymentHeader."Total Amount" = 0 then
            Error('There must be at least one non-zero Line');
        if PaymentHeader."Payee Type" = PaymentHeader."Payee Type"::Imprest then begin
            PaymentHeader.TESTFIELD("Requisitioned By");
            PaymentHeader.TESTFIELD("Global Dimension 1 Code");
            PaymentHeader.TestField("WorkPlan No");
            PaymentHeader.TestField("Budget Code");
        end;
        PaymentHeader.CheckForPaymentReqLinesMandatoryFields(PaymentHeader);
        if PaymentHeader.Purpose = '' then
            Error('Purpose must have a value');
        if GuiAllowed then
            if not Confirm('Are you sure you would like to send the Payment Requisition for approval ?', false) then
                exit;
        //Budget Check
        if Rec."WorkPlan No" <> '' then
            Rec.PRBudgetCheck(Rec);

        RecRef.GetTable(PaymentHeader);
        PaymentHeader.OnSendPaymentApprovalRequest(RecRef, SenderUserID);
        if PaymentHeader.Get(PaymentHeader."No.") then;
        CurrPage.Update(false);
        if GuiAllowed then
            Message('Payment Requisition %1 has been sent for approval.', PaymentHeader."No.");
    end;

    procedure CancelPaymentApprovalRequest(var PaymentHeader: Record "Payment Requisition Header")
    begin
        if GuiAllowed then
            if not Confirm('Are you really sure you would like to cancel this requisition approval ?', false) then
                exit;
        PaymentHeader.OnCancelPaymentApprovalRequest(PaymentHeader);
    end;

    trigger OnDeleteRecord(): Boolean
    var
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;

    procedure printPaymentRequisition(paymentReqHeader: Record "Payment Requisition Header")
    var
        lvPaymentReqHeader: Record "Payment Requisition Header";
        lvPaymentVoucherReport: Report "Payment Requisition";
    begin
        lvPaymentReqHeader.SetRange("No.", paymentReqHeader."No.");
        lvPaymentVoucherReport.SetTableView(lvPaymentReqHeader);
        lvPaymentVoucherReport.RunModal();
        Clear(lvPaymentVoucherReport);
    end;

    procedure printPaymentVoucher(paymentReqHeader: Record "Payment Requisition Header")
    var
        lvPaymentReqHeader: Record "Payment Requisition Header";
        lvPaymentVoucherReport: Report "Payment Voucher1";
    begin
        lvPaymentReqHeader.SetRange("No.", paymentReqHeader."No.");
        lvPaymentVoucherReport.SetTableView(lvPaymentReqHeader);
        lvPaymentVoucherReport.RunModal();
        Clear(lvPaymentVoucherReport);
    end;

}
