pageextension 50059 "Bank Account Card Ext." extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Blocked)
        {

        }
        addafter(Blocked)
        {
            // field(Status; Rec."Status")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field("Bank Type"; Rec."Bank Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addbefore("Ledger E&ntries")
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
                    // Subsciber.ApproveRecordRequest(Rec.RecordId);
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
                    //Subsciber.RejectRecordApprovalRequest(Rec.RecordId);
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
                    //  Subsciber.DelegateRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Comment)
            {
                ApplicationArea = Suite;
                Caption = 'Comments';
                Image = ViewComments;
                ToolTip = 'View or add comments for the record.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action("Send Approval Request")
            {
                // Visible = (ShowApprovalActions and (Rec."Status" = Rec."Status"::Open));
                // ApplicationArea = All;
                // Image = SendApprovalRequest;
                // trigger OnAction()
                // begin
                //     SendApprovalRequest(Rec);
                // end;
            }
            action("Cancel Approval Request")
            {
                // Visible = (ShowApprovalActions and (Rec."Status" = Rec."Status"::"Pending Approval"));
                // ApplicationArea = All;
                // Image = CancelApprovalRequest;
                // Enabled = CanCancelApprovalForRecord;
                // trigger OnAction()
                // begin
                //     CancelApprovalRequest(Rec);
                // end;
            }
            action("ReOpen Record")
            {
                // Visible = (ShowApprovalActions and (Rec."Status" = Rec."Status"::Approved));
                // ApplicationArea = All;
                // Image = ReOpen;
                // trigger OnAction()
                // begin
                //     ReOpenBankAccountRecord(Rec);
                // end;
            }
            // action("Approval History")
            // {
            //     Visible = ShowApprovalActions;
            //     ApplicationArea = All;
            //     Image = History;
            //     RunObject = Page "Approval Entries";
            //     RunPageLink = "Document Type" = filter("Bank Account Record"), "Document No." = field("No.");
            // }
        }
        // addbefore(Category_Category4)
        // {
        //     group(Approvals)
        //     {
        //         actionref(SendApproval; "Send Approval Request") { }
        //         actionref(CancelApproval; "Cancel Approval Request") { }
        //         actionref(ApprovalHistory; "Approval History") { }
        //         actionref(ReOpenRecord; "ReOpen Record") { }
        //     }
        // }
        // addbefore(Category_Process)
        // {
        //     actionref(Approve_Promoted; Approve) { }
        //     actionref(Reject_Promoted; Reject) { }
        //     actionref(Delegate_Promoted; delegate) { }
        // }
    }

    var
        myInt: Integer;
        gvGLSetup: Record "General Ledger Setup";
        ShowApprovalActions: Boolean;
        ShowRecordOpen: Boolean;
        ShowRecordPending: Boolean;
        ShowRecordApproved: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
    // Subsciber: Codeunit Subscriber;

    procedure SendApprovalRequest(var BankAccount: Record "Bank Account")
    var
        RecRef: RecordRef;
    begin
        // Rec.TestField("Status", Rec."Status"::Open);
        if not ShowApprovalActions then
            exit;
        if GuiAllowed then
            if not Confirm('Are you sure you would like to send this record for Approval?') then
                exit;
        RecRef.GetTable(BankAccount);
        BankAccount.OnSendBankAccountForApproval(RecRef);
        CurrPage.Update();
    end;

    procedure CancelApprovalRequest(var BankAccount: Record "Bank Account")
    begin
        // Rec.TestField("Status", Rec."Status"::"Pending Approval");
        if not ShowApprovalActions then
            exit;
        if GuiAllowed then
            if not Confirm('Are you sure you would like to cancel the approval request for this record?') then
                exit;
        BankAccount.OnCancelBankAccountApproval(BankAccount);
        CurrPage.Update();
    end;

    procedure ReOpenBankAccountRecord(var BankAccount: Record "Bank Account")
    begin
        // Rec.TestField("Status", Rec."Status"::Approved);
        if not ShowApprovalActions then
            exit;
        if GuiAllowed then
            if not Confirm('Are you sure you would like to reopen the approved record? Note that the already approved entries will be canceled.') then
                exit;
        BankAccount.OnCancelBankAccountApproval(BankAccount);
        CurrPage.Update();
    end;

    // procedure CheckApprovalActionControls()
    // begin
    //     CanCancelApprovalForRecord := Subsciber.CanCancelApprovalForRecord(Rec.RecordId);
    //     OpenApprovalEntriesExistForCurrUser := Subsciber.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    // end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     CheckApprovalActionControls();
    // end;

    // trigger OnOpenPage()
    // begin
    //     if gvGLSetup.Get() then
    //         ShowApprovalActions := gvGLSetup."Enable G/l Acc. Rec. App.";
    // end;
}