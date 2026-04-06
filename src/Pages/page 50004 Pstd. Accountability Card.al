page 50004 "Pstd. Accountability Card"
{
    PageType = Document;
    SourceTable = "Posted Accountability Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    Caption = 'Posted Accountability Card';

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
                    ToolTip = 'Specifies the document of the posted accountability.';
                }
                field("Requisitioned By"; Rec."Requisitioned By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee number of the requestor of the posted accountability.';
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the workplan No. associated with the accountability.';
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee number of the staff that received the accountability funds.';

                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee name of the staff that received the accountability funds.';
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the budget code linked to the accountability.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the accountability document.';

                }
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the global dimension 1 value code related to the accountability.';
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the global dimension 2 value code related to the accountability.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the accountability was posted.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short description about the accountability.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, , or approved to the next stage of processing.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total, in the currency of the accountability, of the amounts on all the accountability lines';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the posted accountability has been reversed.';
                }

            }
            group(Lines)
            {
                part("Accountability Lines"; "Pstd. Accountability Subform")
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
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
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
                action("Customer Legder Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Ledger Entries';
                    Image = LedgerEntries;
                    ToolTip = 'View the ledger entries related to this record.';
                    RunObject = page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = field("Payee No"), "Document No." = field("No.");
                    RunPageMode = View;
                }
                action("Reverse Accountability")
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Accountability';
                    Image = ReverseLines;
                    ToolTip = 'Reverse an erroneous accountability. This action reverses all lines related to this accountability.';
                    // Visible = ReverseAccountability;
                    trigger OnAction()
                    begin
                        if Rec.Reversed then
                            Error('Accountability %1 has already been reversed');

                        Rec.CheckIfAccountabilityIsApplied(Rec);

                        if not Confirm('Are you sure you would like to reverse this accountability?') then
                            exit;

                        Rec.ReverseAccountability(Rec);
                        Rec.ResetAccountability(Rec);

                        if Rec.Reversed then
                            Message('Accountability %1 has been reversed successfully.', Rec."No.");
                    end;
                }
            }
        }
        // area(Promoted)
        // {
        //     actionref(Dimensions_Promoted; Dimensions) { }
        //     actionref(DocAttachment_Promoted; DocAttach) { }
        //     actionref(Comments_Promoted; Comments) { }
        //     actionref(CustomerLedgerEntries_Promoted; "Customer Legder Entries") { }
        //     actionref(ReverseAccountability_Promoted; "Reverse Accountability") { }
        // }
    }

    var
        lvUserSetup: Record "User Setup";
        RevAccountability: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        lvUserSetup.Reset();
        lvUserSetup.SetRange("User ID", UserId);
        if lvUserSetup.FindFirst() then
            if lvUserSetup."Reverse Accountability" then
                RevAccountability := true
            else
                RevAccountability := false
        else
            RevAccountability := false;
    end;

}