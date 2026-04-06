page 50063 "Accountability Card"
{
    PageType = Document;
    SourceTable = "Accountability Header";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requisitioned By"; Rec."Requisitioned By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Category"; Rec."Payment Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Payment Type ?, it will clear the Payment Sub Catergory, Payee No, Payee Name and delete the Lines';
                        PaymentLine: Record "Payment Requisition Line";
                        lvPayType: Record "Payment Type";
                        lvPaySubType: Record "Payment Subcategory";
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
                    end;
                }
                field("Pay. Subcategory"; Rec."Pay. Subcategory")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Payment Sub Category ?, it will clear the Payee No, Payee Name and delete the Lines';
                        PaymentLine: Record "Payment Requisition Line";
                        PaySubType: Record "Payment Subcategory";
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
                        if PaySubType.Get(Rec."Pay. Subcategory") then
                            if PaySubType."Requires WorkPlan" then
                                gvEditWorkPlan := true;
                        CurrPage.Update();
                    end;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Work Plan ?, it will clear the Budget , Fundsource and delete the Lines';
                        PaymentLine: Record "Payment Requisition Line";
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
                    Editable = false;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Payee No ?, it will clear the Payee Name and delete the Lines';
                        PaymentLine: Record "Payment Requisition Line";
                        PaymentLine2: Record "Payment Requisition Line";
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

                            if Rec."Payee Type" IN [Rec."Payee Type"::Bank, Rec."Payee Type"::Vendor, Rec."Payee Type"::Imprest] then
                                InitFirstLine();

                        end
                        else begin
                            if Rec."Payee Type" IN [Rec."Payee Type"::Bank, Rec."Payee Type"::Vendor, Rec."Payee Type"::Imprest] then begin
                                InitFirstLine();
                            end;
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
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
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }

            }
            group(Lines)
            {
                part("Accountability Lines"; "Accountability Subform")
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
            action("Approval History")
            {
                ApplicationArea = All;
                Image = History;

                RunObject = page "Approval Entries";
                RunPageLink = "Document Type" = const(Accountability), "Document No." = field("No.");
            }


            action(PostDoc)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.PostAccountability();
                end;
            }

            action("Undo Accountability")
            {
                Caption = 'Undo Accountability';
                ToolTip = 'Reverse the created accountability. In case there is an error with the created accountability, reverse the entire document and create a new accountability document.';
                Image = ReverseLines;
                // Visible = Rec.Status = Rec.Status::Open;
                Visible = gvOpen;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    if not confirm('Are you sure you would like to undo the created accountability?') then
                        exit;
                    Rec.UndoAccountability(Rec);
                end;
            }
        }
        area(Reporting)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;

                trigger OnAction()
                var
                    AccountabilityHeader: Record "Accountability Header";
                    AccountabilityRep: Report "Accountability Report";
                begin
                    AccountabilityHeader.SETRANGE("Document Type", Rec."Document Type");
                    AccountabilityHeader.SETRANGE("No.", Rec."No.");
                    AccountabilityRep.SETTABLEVIEW(AccountabilityHeader);
                    AccountabilityRep.RUNMODAL();
                end;
            }
            action("Archive Document")
            {
                ApplicationArea = All;
                Image = Archive;


                trigger OnAction()
                var
                    Txt001: Label 'Are you really sure you would like to archive this requisition ?';
                begin
                    if not Confirm(Txt001, false) then
                        exit;
                    Rec.ArchivePayment(Rec);
                end;
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = showDimension;
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to payment documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
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
                    ApprovalCommentLine.SetRange("Table ID", Database::"Accountability Header");
                    ApprovalCommentLine.SetRange("Record ID to Approve", Rec.RecordId);
                    Page.run(Page::"Approval Comments", ApprovalCommentLine);
                end;
            }

        }

        area(Processing)
        {

            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
                Image = Approve;
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
                // Visible = Rec.Status = Rec.Status::Open;
                Visible = gvOpen;

                trigger OnAction()
                begin
                    SendApprovalRequest(Rec, Subsciber.GetSenderUserID(''));
                end;
            }
            action("Cancel Approval Re&quest")
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                // Visible = Rec.Status = Rec.Status::"Pending Approval";
                Visible = gvPending;
                Enabled = CanCancelApprovalForRecord;
                trigger OnAction()
                begin
                    CancelApprovalRequest(Rec);
                end;
            }




        }
    }

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        gvEditPayeeNo: Boolean;
        gvEditWorkPlan: Boolean;
        gvDate: Date;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        Subsciber: Codeunit Subscriber;
        gvOpen: Boolean;
        gvApproved: Boolean;
        showDimension: Boolean;

        gvPending: Boolean;


    trigger OnOpenPage()
    var
        PaySubType: Record "Payment Subcategory";
    begin
        if PaySubType.Get(Rec."Pay. Subcategory") then
            if PaySubType."Requires WorkPlan" then
                gvEditWorkPlan := true;
        if Rec.Status = Rec.Status::Open then gvOpen := true else gvOpen := false;
        // if Rec.Status = Rec.Status::Approved then gvApproved := true else gvApproved := false;
        if Rec.Status = Rec.Status::"Pending Approval" then gvPending := true else gvPending := false;
        if Rec."No." <> '' then showDimension := true else showDimension := false;
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

    procedure SendApprovalRequest(var AccHeader: Record "Accountability Header"; senderUserID: Code[50])
    var
        RecRef: RecordRef;
    begin
        AccHeader.CalcFields("Total Amount");
        if AccHeader."Total Amount" = 0 then
            Error('There must be at least one non-zero Line');
        AccHeader.CheckForAccountabilityLinesMandatoryFields(AccHeader);
        if AccHeader.Purpose = '' then
            Error('Purpose must have a value');
        // AccHeader.CheckBankAccountLineAmount(AccHeader);
        if Confirm('Are you sure you would like to send this Accountability for approval?', false) then begin
            RecRef.GetTable(AccHeader);
            AccHeader.OnSendAccountabilityApprovalRequest(RecRef, senderUserID);
        end;
        CurrPage.Close();
    end;

    procedure CancelApprovalRequest(var AccHeader: Record "Accountability Header")
    begin
        AccHeader.OnCancelAccountabilityApprovalRequest(AccHeader);
    end;

    procedure CheckApprovalActionControls()
    begin
        CanCancelApprovalForRecord := Subsciber.CanCancelApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExistForCurrUser := Subsciber.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckApprovalActionControls();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Error('Accountability records cannot be deleted. Please Archive the record.');
    end;
}