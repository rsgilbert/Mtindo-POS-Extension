page 50308 "POS Transaction Card"
{
    PageType = Document;
    SourceTable = "POS Transaction Header";
    Caption = 'POS Transaction';
    UsageCategory = None;
    InsertAllowed = true;

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
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("POS Session No."; Rec."POS Session No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("POS Store Code"; Rec."POS Store Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("POS Terminal Code"; Rec."POS Terminal Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cashier User ID"; Rec."Cashier User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Walk-In Customer"; Rec."Walk-In Customer")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Receipt No."; Rec."Original Receipt No.")
                {
                    ApplicationArea = All;
                    Visible = IsReturnTransaction;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Totals)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tendered Amount"; Rec."Tendered Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Settlement Status"; Rec."Settlement Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Settled At"; Rec."Settled At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Settlement Error"; Rec."Settlement Error")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }
            }
            group(Lines)
            {
                part(POSTransactionLines; "POS Transaction Lines")
                {
                    ApplicationArea = All;
                    SubPageLink = "Document No." = field("No.");
                }
            }
            group(Payments)
            {
                part(POSPayments; "POS Payments")
                {
                    ApplicationArea = All;
                    SubPageLink = "Document No." = field("No.");
                }
            }
            group(Approval)
            {
                Visible = IsReturnTransaction;

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved At"; Rec."Approved At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Reason"; Rec."Approval Reason")
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
            action(Dimensions)
            {
                Caption = 'Dimensions';
                ApplicationArea = All;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Alt+D';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                    CurrPage.Update(false);
                end;
            }
            action("Refresh Totals")
            {
                Caption = 'Refresh Totals';
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                begin
                    Rec.UpdateCalculatedAmounts();
                    CurrPage.Update(false);
                end;
            }
            action("Suspend")
            {
                Caption = 'Suspend';
                ApplicationArea = All;
                Image = Pause;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSManagement.SuspendTransaction(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Resume")
            {
                Caption = 'Resume';
                ApplicationArea = All;
                Image = ReOpen;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSManagement.ResumeTransaction(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Validate Transaction")
            {
                Caption = 'Validate Transaction';
                ApplicationArea = All;
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSManagement.ValidateTransaction(Rec);
                    Message('Transaction %1 passed the current POS validation checks.', Rec."No.");
                end;
            }
            action("Load Return Lines")
            {
                Caption = 'Load Return Lines';
                ApplicationArea = All;
                Image = GetLines;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSPosting: Codeunit "POS Posting";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSPosting.LoadReturnLines(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Approve Return")
            {
                Caption = 'Approve Return';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSPosting: Codeunit "POS Posting";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSPosting.ApproveReturn(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Post Transaction")
            {
                Caption = 'Post Transaction';
                ApplicationArea = All;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSPosting: Codeunit "POS Posting";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSPosting.PostTransaction(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Print Receipt")
            {
                Caption = 'Print Receipt';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.PrintReceipt(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Post Settlement")
            {
                Caption = 'Post Settlement';
                ApplicationArea = All;
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSSettlement: Codeunit "POS Settlement";
                begin
                    POSManagement.EnsureTransactionAccess(Rec);
                    POSSettlement.SettleTransaction(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        POSManagement: Codeunit "POS Management";
    begin
        POSManagement.EnsureTransactionAccess(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        IsReturnTransaction := Rec."Transaction Type" = Rec."Transaction Type"::Return;
    end;

    var
        IsReturnTransaction: Boolean;
}
