page 50073 "Budget Reallocation"
{
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Budget Realloc. Header";
    SourceTableView = where("Document Type" = filter("Budget Reallocation"));
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
                    ToolTip = 'Specifies the document number for the Budget reallocation.';
                }
                field("Budget Revision Type"; Rec."Budget Revision Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budget revision type relating to the Budget revision type. The options are Budget Reallocation and Budget cut.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee that created the budget reallocation.';
                }
                field("Created By Name"; Rec."Created By Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee name that created the budget reallocation.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the global dimension 1 value code relating to the budget reallocation.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the global dimension 2 value code relating to the budget reallocation.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose for the budget reallocation.';
                }
                field("Reason for Reallocation"; Rec."Reason for Reallocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specified the additional reason for the reallocation';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The field indicates the approval status of the Budget reallocation. The Options are open, pending approval and approved';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date when the budget reallocation was created.';
                }
            }
            part("Budget Reallocation Subform"; "Budget Reallocation Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No" = field("No.");
                UpdatePropagation = Both;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval")
            {
                ApplicationArea = All;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                // Visible = Rec.Status = Rec.Status::Open;
                Visible = gvOpen;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    lvBudgetReallocLine: Record "Budget Realloc. Lines";
                begin
                    Rec.TESTfield("Global Dimension 1 Code");
                    Rec.Testfield(Purpose);

                    lvBudgetReallocLine.Reset();
                    lvBudgetReallocLine.SetRange("Document Type", rec."Document Type");
                    lvBudgetReallocLine.SetRange("Document No", Rec."No.");
                    if lvBudgetReallocLine.FindSet() then
                        repeat
                            lvBudgetReallocLine.TestField(Amount);
                            if lvBudgetReallocLine."Budget Revision Type" = lvBudgetReallocLine."Budget Revision Type"::"Budget Reallocation" then begin
                                lvBudgetReallocLine.TestField("New G/L Account");
                                lvBudgetReallocLine.TestField("New Activity Description");
                                lvBudgetReallocLine.TestField("New Workplan No.");
                            end;
                        until lvBudgetReallocLine.Next() = 0;

                    if Confirm('Are you sure you would like to send the Reallocation for approval?', false) then
                        Rec.OnSendBudgetReallocApprovalRequest(Rec, SubscriberCU.GetSenderUserID(''));
                end;
            }
            action("Cancel Approval Re&quest")
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                // Visible = Rec.Status = Rec.Status::"Pending Approval";
                // Enabled = Rec.Status = Rec.Status::"Pending Approval";
                Visible = gvpending;
                Enabled = gvpending;
                ToolTip = 'Cancel the approval request of the document.';
                trigger OnAction()
                begin
                    if Rec.Status IN [Rec.Status::Open, Rec.Status::Rejected] then
                        error('You can only cancel an approved or a pending Reallocation, the current Reallocation is %1', Format(rec.Status));
                    if Confirm('Are you really sure you would like to cancel this approval ?', false) then
                        Rec.OnCancelBudgetReallocApprovalRequest(Rec);
                end;
            }
            action("Reopen Budget Reallocation")
            {
                Image = ReOpen;
                ApplicationArea = All;
                // Visible = Rec.Status = Rec.Status::Approved;
                Visible = gvApproved;
                ToolTip = 'Reopen the approved the document.';
                trigger OnAction()
                begin
                    if GuiAllowed then
                        if not Confirm('Are you sure you would like to reopen the approved budget realocation? Please note that this action will cancel the approval requests.') then
                            exit;
                    Rec.OnCancelBudgetReallocApprovalRequest(Rec);
                end;
            }
            action("Approval History")
            {
                ApplicationArea = All;
                Image = History;
                RunObject = page "Approval Entries";
                ToolTip = 'Shows the approval entries relating to the document.';
                RunPageLink = "Document Type" = const("Budget Reallocation"), "Document No." = field("No.");
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
            action(Reallocate)
            {
                ApplicationArea = All;
                Caption = 'Reallocate';
                Image = Replan;
                ToolTip = 'This action performs the reallocation by affecting the involved workplans and budgets.';
                // Visible = Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Reallocation";
                Visible = gvBudRealloc;

                trigger OnAction()
                var
                    lvBudgetReallocationLine: Record "Budget Realloc. Lines";
                    lvWorkplanline: Record "WorkPlan Line";
                    lvCommitements: Decimal;
                    lvActuals: Decimal;
                begin
                    lvCommitements := 0;
                    lvActuals := 0;
                    If Rec.Status <> Rec.Status::Approved then
                        Error('Status must be Approved to proceed with Reallocation. The current status is %1', Rec.Status);
                    lvBudgetReallocationLine.Reset();
                    lvBudgetReallocationLine.SetRange("Document No", Rec."No.");
                    if lvBudgetReallocationLine.FindSet() then
                        repeat
                            if lvBudgetReallocationLine.Amount = 0 then
                                Error('Total amount for Budget Reallocation line %1 cannot be 0.', lvBudgetReallocationLine."Entry No");
                            lvWorkplanline.Reset();
                            lvWorkplanline.SetRange("WorkPlan No", lvBudgetReallocationLine."Workplan No.");
                            lvWorkplanline.SetRange("Entry No", lvBudgetReallocationLine."Workplan Entry No.");
                            if lvWorkplanline.FindFirst() then begin
                                lvWorkplanline.Calcfields(Actuals, Encumbrances, "Payment Req. Pre-Encumbrances", "Actual Invoices", Advances, "Credit Memos", Accountabilities);
                                lvActuals := (lvWorkplanline."Actual Invoices" - lvWorkplanline."Credit Memos") + lvWorkplanline.Actuals;
                                lvCommitements := lvWorkplanline.Encumbrances + lvWorkplanline."Payment Req. Pre-Encumbrances" + +lvWorkplanline."Reallocated Amount" + lvWorkplanline.Advances + lvWorkplanline.Accountabilities;
                                if lvBudgetReallocationLine.Amount > (lvWorkplanline."Annual Amount" - lvCommitements - lvActuals - lvWorkplanline."Reallocated Amount") then
                                    Error('The Amount on line %1, document No %2 is greater that the current available balance %3', lvBudgetReallocationLine."Entry No", lvBudgetReallocationLine."Document No", (lvWorkplanline."Annual Amount" - lvCommitements - lvactuals - lvWorkplanline."Reallocated Amount"));
                            end;
                        until lvBudgetReallocationLine.Next() = 0;
                    if Confirm('Are you sure you want to proceed with the Reallocation process?') then
                        Rec.Reallocate();
                end;
            }
            action("Update Budget")
            {
                ApplicationArea = All;
                Caption = 'Update Budget';
                Image = Replan;
                ToolTip = 'This action performs the budget cut updates by affecting the involved workplans and budgets.';
                // Visible = Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Cut";
                Visible = gvBudCut;

                trigger OnAction()
                var
                    lvBudgetReallocationLine: Record "Budget Realloc. Lines";
                    lvWorkplanline: Record "WorkPlan Line";
                    lvCommitements: Decimal;
                    lvActuals: Decimal;
                begin
                    lvCommitements := 0;
                    lvActuals := 0;
                    If Rec.Status <> Rec.Status::Approved then
                        Error('Status must be Approved to proceed with Reallocation. The current status is %1', Rec.Status);
                    lvBudgetReallocationLine.Reset();
                    lvBudgetReallocationLine.SetRange("Document No", Rec."No.");
                    if lvBudgetReallocationLine.FindSet() then
                        repeat
                            if lvBudgetReallocationLine.Amount = 0 then
                                Error('Total amount for Budget Reallocation line %1 cannot be 0.', lvBudgetReallocationLine."Entry No");
                            lvWorkplanline.Reset();
                            lvWorkplanline.SetRange("WorkPlan No", lvBudgetReallocationLine."Workplan No.");
                            lvWorkplanline.SetRange("Entry No", lvBudgetReallocationLine."Workplan Entry No.");
                            if lvWorkplanline.FindFirst() then begin
                                lvWorkplanline.Calcfields(Actuals, Encumbrances, "Payment Req. Pre-Encumbrances", "Actual Invoices", Advances, "Credit Memos", Accountabilities);
                                lvActuals := (lvWorkplanline."Actual Invoices" - lvWorkplanline."Credit Memos") + lvWorkplanline.Actuals;
                                lvCommitements := lvWorkplanline.Encumbrances + lvWorkplanline."Payment Req. Pre-Encumbrances" + +lvWorkplanline."Reallocated Amount" + lvWorkplanline.Advances + lvWorkplanline.Accountabilities;
                                if lvBudgetReallocationLine.Amount > (lvWorkplanline."Annual Amount" - lvCommitements - lvActuals - lvWorkplanline."Reallocated Amount") then
                                    Error('The Amount on line %1, document No %2 is greater that the current available balance %3', lvBudgetReallocationLine."Entry No", lvBudgetReallocationLine."Document No", (lvWorkplanline."Annual Amount" - lvCommitements - lvactuals - lvWorkplanline."Reallocated Amount"));
                            end;
                        until lvBudgetReallocationLine.Next() = 0;
                    if Confirm('Are you sure you want to proceed with this process?') then
                        Rec.TransferBudgetcutToBudget(Rec);
                end;
            }

            action(Archive)
            {
                ApplicationArea = All;
                Image = Archive;
                ToolTip = 'Manually archive the document.';
                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::"Pending Approval" then
                        Error('Status must be open or approved');
                    if confirm('Are you sure you would like to archive this document?') then
                        Rec.ArchiveDocument();
                end;

            }
        }
    }


    var
        SubscriberCU: Codeunit Subscriber;
        gvpageEditable: Boolean;
        gvBudCut: Boolean;
        gvBudRealloc: Boolean;
        gvOpen: Boolean;
        gvpending: Boolean;
        gvApproved: Boolean;

    trigger OnOpenPage()
    begin
        if (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::"Pending Approval") then
            gvpageEditable := false
        else
            gvpageEditable := true;

        if Rec.status = Rec.status::Approved then gvApproved := true else gvApproved := false;
        if Rec.status = Rec.status::Open then gvOpen := true else gvOpen := false;
        if Rec.status = Rec.status::"Pending Approval" then gvpending := true else gvpending := false;
        if Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Cut" then gvBudCut := true else gvBudCut := false;
        if Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Reallocation" then gvBudRealloc := true else gvBudRealloc := false;
        CurrPage.Editable := gvpageEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.Testfield(Status, Rec.Status::Open);
    end;

}