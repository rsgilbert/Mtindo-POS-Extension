pageextension 50202 "Requests to Approve Ext." extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
        modify(ToApprove)
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        movebefore(Amount; "Currency Code")
        addbefore(ToApprove)
        {
            field(Overdue; Overdue)
            {
                Caption = 'Overdue';
                Editable = false;
                OptionCaption = 'Yes';
                ToolTip = 'Overdue Entry';
                Style = Attention;
                StyleExpr = OverdueStyle;
                ApplicationArea = All;
            }
            field("Document Type"; Rec."Document Type")
            {
                ApplicationArea = All;
                Style = Attention;
                StyleExpr = OverdueStyle;
            }
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = All;
                Style = Attention;
                StyleExpr = OverdueStyle;
            }
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
                Style = Attention;
                StyleExpr = OverdueStyle;
            }
        }
        addafter("Amount (LCY)")
        {
            field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
            {
                ApplicationArea = All;
            }
            field("Requested By"; Rec."Requested By")
            {
                ApplicationArea = All;
            }
            field("Payee Name"; Rec."Payee Name")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Approve)
        {
            Visible = false;
        }
        modify(Reject)
        {
            Visible = false;
        }
        modify(Delegate)
        {
            Visible = false;
        }
        modify(Comments)
        {
            Visible = false;
        }
        addbefore(Approve)
        {
            action(Approve_Cust)
            {
                ApplicationArea = All;
                Caption = '&Approve';
                Image = Approve;

                trigger OnAction()
                var
                    Txt001: Label 'Are you really sure, you would like to approve this entry';
                    ApprovalEntry: Record "Approval Entry";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    IF NOT Confirm(Txt001, false) then
                        exit;
                    IF ApprovalEntry.FIND('-') THEN
                        REPEAT
                            ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
                        UNTIL ApprovalEntry.NEXT = 0;
                end;
            }
            action(Reject_Cust)
            {
                ApplicationArea = All;
                Caption = '&Reject';
                Image = Reject;

                trigger OnAction()
                var
                    Txt001: Label 'Are you really sure, you would like to reject this entry';
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalSetup: Record "Req Approval Setup";
                    ApprovalComment: Page "Requisition Approval Comments";
                    CommentRec: Record "Approval Comment Line";
                    ApprovalMgt: Codeunit "Approval Management";
                    RecRef: RecordRef;
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    IF ApprovalEntry.FIND('-') THEN
                        REPEAT
                            IF NOT Confirm(Txt001, false) then
                                exit;

                            IF NOT ApprovalSetup.GET THEN
                                ERROR(Text004);
                            IF ApprovalSetup."Request Rejection Comment" = TRUE THEN BEGIN

                                RecRef.GetTable(ApprovalEntry);
                                ApprovalMgt.ShowApprovalComments(RecRef, 'Rejection');
                            END ELSE BEGIN
                                CLEAR(ApprovalComment);
                                ApprovalMgt.RejectApprovalRequest(ApprovalEntry, '');
                            END;
                        UNTIL ApprovalEntry.NEXT = 0;
                end;
            }
            action(Delegate_Cust)
            {
                ApplicationArea = All;
                Caption = '&Delegate';
                Image = Delegate;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                begin
                    IF not Confirm('Are you really sure, you would like to delegate the approval of this request ?', false) then
                        exit;
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    IF ApprovalEntry.FIND('-') THEN
                        REPEAT
                            ApprovalMgt.DelegateApprovalRequests(ApprovalEntry);
                        UNTIL ApprovalEntry.NEXT = 0;
                end;
            }
            action(Comments_Cust)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = ViewComments;

                trigger OnAction()
                var
                    ApprovalComments: Page "Requisition Approval Comments";
                begin
                    ApprovalComments.Setfilters(Rec."Table ID", Rec."Document Type", Rec."Document No.");
                    ApprovalComments.SetUpLine(Rec."Table ID", Rec."Document Type", Rec."Document No.");
                    ApprovalComments.RUN;
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
                    DocAttachment: Record "Document Attachment";
                    RecRef: RecordRef;
                    DocType: Option;
                    DocNo: Code[20];
                    TableID: Integer;
                    FieldRef: FieldRef;
                begin
                    RecRef.GetTable(Rec);
                    FieldRef := RecRef.Field(1);
                    TableID := FieldRef.Value;
                    FieldRef := RecRef.Field(2);
                    DocType := FieldRef.Value;
                    FieldRef := RecRef.Field(3);
                    DocNo := FieldRef.Value;
                    DocAttachment.SetRange("Table ID", TableID);
                    DocAttachment.SetRange("Document Type", DocType);
                    DocAttachment.SetRange("No.", DocNo);
                    DocumentAttachmentDetails.SetTableView(DocAttachment);
                    DocumentAttachmentDetails.RunModal();
                end;
            }

        }

    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

    end;

    var
        myInt: Integer;
        ApprovalMgt: Codeunit "Approval Management";
        Text001: Label 'You can only delegate open approval entries.';
        Text002: Label 'The selected approval(s) have been delegated. ';
        Text004: Label 'Approval Setup not found.';
        Overdue: Option Yes," ";
        OverdueStyle: Boolean;

    trigger OnAfterGetRecord()
    var
    begin
        Overdue := Overdue::" ";
        IF FormatField(Rec) THEN
            Overdue := Overdue::Yes
        else
            Overdue := Overdue::" ";
    end;

    procedure FormatField(Rec: Record "Approval Entry") OK: Boolean
    begin
        IF (Rec.Status IN [Rec.Status::Created, Rec.Status::Open]) THEN BEGIN
            IF (Rec."Due Date" < TODAY) THEN begin
                OverdueStyle := true;
                EXIT(TRUE)
            end
            ELSE begin
                OverdueStyle := false;
                EXIT(FALSE);
            end
        END;
    end;
}