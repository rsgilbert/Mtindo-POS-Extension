page 50057 "Payment Voucher Card"
{
    Caption = 'Payment Voucher Card';
    PageType = Document;
    SourceTable = "Payment Requisition Header";
    Editable = false;
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
                    Visible = false;
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
                }
                field("Pay. Subcategory"; Rec."Pay. Subcategory")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("WorkPlan No"; Rec."WorkPlan No")
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
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Visible = TogglePostVisibility;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("PV Status"; Rec."PV Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ext Document No"; Rec."Ext Document No")
                {
                    ApplicationArea = All;
                    Visible = TogglePostVisibility;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                    Visible = TogglePostVisibility;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }

            }
            group(Lines)
            {
                part("Payment Lines"; "Payment Subform")
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
        area(Processing)
        {
            group(Approval)
            {
                action("Cancel Payment")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Payment';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                }
                action("Approval History")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = History;
                }
                action("Print")
                {
                    ApplicationArea = All;
                    Caption = 'Print Requisition';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                }

                action("PrintPV")
                {
                    ApplicationArea = All;
                    Caption = 'Print Voucher';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                }

                action(MakePV)
                {
                    ApplicationArea = All;
                    Caption = 'Process Payment Voucher';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Visible = false;

                }
                action(PostDoc)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Visible = TogglePostVisibility;
                    trigger OnAction()
                    var
                        Txt001: Label 'Are you really sure you would like to post this requisition ?';
                    begin
                        if not Confirm(Txt001, false) then
                            exit;
                        Rec.PostPayment();
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
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
                    Promoted = true;
                    PromotedCategory = Report;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        DocAttachment: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        DocAttachment.SetRange("No.", Rec."No.");
                        DocAttachment.SetRange("Document Type", Rec."Document Type");
                        DocumentAttachmentDetails.SetTableView(DocAttachment);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View comments related to this document.';

                    trigger OnAction()
                    var
                        myInt: Integer;
                        ApprovalCommentLine: Record "Approval Comment Line";
                    begin
                        ApprovalCommentLine.SetRange("Table ID", Database::"Payment Requisition Header");
                        ApprovalCommentLine.SetRange("Record ID to Approve", Rec.RecordId);
                        Page.run(Page::"Approval Comments", ApprovalCommentLine);
                    end;
                }

            }

        }
    }

    var
        TogglePostVisibility: Boolean;
        TogglePvVisibility: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec."PV Status" = Rec."PV Status"::Approved then
            TogglePostVisibility := true;

        if (Rec.Status = Rec.Status::Approved) AND (Rec.Processed = false) then
            TogglePvVisibility := true;
    end;
}