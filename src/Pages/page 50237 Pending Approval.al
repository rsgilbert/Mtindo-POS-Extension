page 50237 "Pending Approval"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Approval Entry";
    SourceTableView = where(Status = const(Open));
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Document)
            {
                action("Open Document")
                {
                    ApplicationArea = All;
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        OpenSelectedDocument();
                    end;
                }
            }
            group(Approval)
            {
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        ApproveCurrentEntry();
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;

                    trigger OnAction()
                    begin
                        RejectCurrentEntry();
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;

                    trigger OnAction()
                    begin
                        DelegateCurrentEntry();
                    end;
                }
                action("Approve Selected")
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve Selected';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        ApproveSelectedEntries();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(10);
        Rec.SetRange(Status, Rec.Status::Open);
        Rec.SetRange("Approver ID", UserId);
        Rec.SetRange("Related to Change", false);
        Rec.SetFilter("Document Type", '%1|%2', Rec."Document Type"::Workplan, Rec."Document Type"::"Payment Requisition");
        Rec.FilterGroup(0);
    end;

    local procedure OpenSelectedDocument()
    var
        PaymentRequisitionHeader: Record "Payment Requisition Header";
        WorkPlanHeader: Record "WorkPlan Header";
    begin
        case Rec."Table ID" of
            Database::"Payment Requisition Header":
                begin
                    PaymentRequisitionHeader.Get(Rec."Document No.");
                    Page.Run(Page::"Payment Requisition", PaymentRequisitionHeader);
                end;
            Database::"WorkPlan Header":
                begin
                    WorkPlanHeader.Get(Rec."Document No.");
                    Page.Run(Page::"WorkPlan Header", WorkPlanHeader);
                end;
            else
                Error('This approval entry is not supported on this page.');
        end;
    end;

    local procedure ApproveCurrentEntry()
    begin
        if Rec."Record ID to Approve" = BlankRecordId then
            Error('Record ID to approve is missing.');
        Subscriber.ApproveRecordRequest(Rec."Record ID to Approve");
        CurrPage.Update(false);
    end;

    local procedure RejectCurrentEntry()
    begin
        if Rec."Record ID to Approve" = BlankRecordId then
            Error('Record ID to approve is missing.');
        Subscriber.RejectRecordApprovalRequest(Rec."Record ID to Approve");
        CurrPage.Update(false);
    end;

    local procedure DelegateCurrentEntry()
    begin
        if Rec."Record ID to Approve" = BlankRecordId then
            Error('Record ID to approve is missing.');
        Subscriber.DelegateRecordApprovalRequest(Rec."Record ID to Approve");
        CurrPage.Update(false);
    end;

    local procedure ApproveSelectedEntries()
    var
        SelectedApprovalEntries: Record "Approval Entry";
        SelectedCount: Integer;
    begin
        CurrPage.SetSelectionFilter(SelectedApprovalEntries);
        SelectedApprovalEntries.SetRange(Status, SelectedApprovalEntries.Status::Open);
        SelectedApprovalEntries.SetRange("Approver ID", UserId);
        if SelectedApprovalEntries.IsEmpty() then
            exit;

        SelectedCount := SelectedApprovalEntries.Count;
        if not Confirm('Approve %1 selected approval request(s)?', false, SelectedCount) then
            exit;

        if SelectedApprovalEntries.FindSet() then
            repeat
                if SelectedApprovalEntries."Record ID to Approve" <> BlankRecordId then
                    Subscriber.ApproveRecordRequest(SelectedApprovalEntries."Record ID to Approve");
            until SelectedApprovalEntries.Next() = 0;

        CurrPage.Update(false);
    end;

    var
        Subscriber: Codeunit Subscriber;
        BlankRecordId: RecordId;
}
