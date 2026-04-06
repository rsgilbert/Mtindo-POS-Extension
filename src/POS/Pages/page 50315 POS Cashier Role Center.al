page 50315 "POS Cashier Role Center"
{
    Caption = 'POS Cashier';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part("POS Cashier Cue Part"; "POS Cashier Cue Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Session)
            {
                Caption = 'Session';

                action("POS Sessions")
                {
                    ApplicationArea = All;
                    Caption = 'My Sessions';
                    RunObject = page "POS Sessions";
                    ToolTip = 'View and manage your POS sessions.';
                }
            }
            group(Transactions)
            {
                Caption = 'Transactions';

                action("POS Transactions")
                {
                    ApplicationArea = All;
                    Caption = 'POS Transactions';
                    RunObject = page "POS Transactions";
                    ToolTip = 'View and manage your POS transactions.';
                }
                action("POS Posted Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Receipts';
                    RunObject = page "POS Posted Receipts";
                    ToolTip = 'View posted sales receipts.';
                }
                action("POS Posted Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Returns';
                    RunObject = page "POS Posted Returns";
                    ToolTip = 'View posted return transactions.';
                }
            }
        }
        area(Embedding)
        {
            action("Embedded POS Transactions")
            {
                ApplicationArea = All;
                Caption = 'POS Transactions';
                RunObject = page "POS Transactions";
                ToolTip = 'View and manage your POS transactions.';
            }
            action("Embedded POS Sessions")
            {
                ApplicationArea = All;
                Caption = 'POS Sessions';
                RunObject = page "POS Sessions";
                ToolTip = 'View and manage your POS sessions.';
            }
        }
        area(Processing)
        {
            action("New Sale")
            {
                ApplicationArea = All;
                Caption = 'New Sale';
                Image = NewSalesInvoice;
                RunObject = page "POS Transaction Card";
                RunPageMode = Create;
                ToolTip = 'Create a new POS sale transaction.';
            }
            action("New Return")
            {
                ApplicationArea = All;
                Caption = 'New Return';
                Image = ReturnOrder;
                RunObject = page "POS Transaction Card";
                RunPageMode = Create;
                RunPageLink = "Transaction Type" = const(Return);
                ToolTip = 'Create a new POS return transaction.';
            }
            action("Open Transactions")
            {
                ApplicationArea = All;
                Caption = 'Open Transactions';
                Image = DocumentsMaturity;
                RunObject = page "POS Transactions";
                ToolTip = 'View all open POS transactions.';
            }
            group(Reports)
            {
                Caption = 'Reports';

                action("POS Receipt")
                {
                    ApplicationArea = All;
                    Caption = 'Print Receipt';
                    RunObject = report "POS Receipt";
                    ToolTip = 'Print or reprint a POS receipt.';
                }
                action("POS Session Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Session Summary';
                    RunObject = report "POS Session Summary";
                    ToolTip = 'Print a session reconciliation summary.';
                }
            }
        }
    }
}
