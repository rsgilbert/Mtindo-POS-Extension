page 50307 "POS Transactions"
{
    PageType = List;
    SourceTable = "POS Transaction Header";
    Caption = 'POS Transactions';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "POS Transaction Card";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("POS Session No."; Rec."POS Session No.")
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
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Tendered Amount"; Rec."Tendered Amount")
                {
                    ApplicationArea = All;
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                    ApplicationArea = All;
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                }
                field("Settlement Status"; Rec."Settlement Status")
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
            action("New Sale")
            {
                Caption = 'New Sale';
                ApplicationArea = All;
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSTransactionHeader: Record "POS Transaction Header";
                begin
                    POSManagement.CreateTransaction(POSTransactionHeader."Transaction Type"::Sale, POSTransactionHeader);
                    Page.Run(Page::"POS Transaction Card", POSTransactionHeader);
                end;
            }
            action("New Return")
            {
                Caption = 'New Return';
                ApplicationArea = All;
                Image = ReturnOrder;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSTransactionHeader: Record "POS Transaction Header";
                begin
                    POSManagement.CreateTransaction(POSTransactionHeader."Transaction Type"::Return, POSTransactionHeader);
                    Page.Run(Page::"POS Transaction Card", POSTransactionHeader);
                end;
            }
            action("Suspend Transaction")
            {
                Caption = 'Suspend Transaction';
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
            action("Resume Transaction")
            {
                Caption = 'Resume Transaction';
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
        POSManagement.ApplyTransactionVisibilityFilter(Rec);
    end;
}
