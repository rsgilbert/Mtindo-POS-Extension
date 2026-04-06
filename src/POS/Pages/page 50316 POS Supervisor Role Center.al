page 50316 "POS Supervisor Role Center"
{
    Caption = 'POS Supervisor';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part("POS Supervisor Cue Part"; "POS Supervisor Cue Part")
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
                action("All POS Sessions")
                {
                    ApplicationArea = All;
                    Caption = 'All Sessions';
                    RunObject = page "POS Sessions";
                    ToolTip = 'View all POS sessions across all cashiers.';
                }
            }
            group(Transactions)
            {
                Caption = 'Transactions';

                action("POS Transactions")
                {
                    ApplicationArea = All;
                    Caption = 'My Transactions';
                    RunObject = page "POS Transactions";
                    ToolTip = 'View and manage your own POS transactions.';
                }
                action("All POS Transactions")
                {
                    ApplicationArea = All;
                    Caption = 'All Transactions';
                    RunObject = page "POS Transactions";
                    ToolTip = 'View all POS transactions across all cashiers.';
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
            group(Administration)
            {
                Caption = 'Administration';

                action("POS Stores")
                {
                    ApplicationArea = All;
                    Caption = 'Stores';
                    RunObject = page "POS Stores";
                    ToolTip = 'View and manage POS stores.';
                }
                action("POS Terminals")
                {
                    ApplicationArea = All;
                    Caption = 'Terminals';
                    RunObject = page "POS Terminals";
                    ToolTip = 'View and manage POS terminals.';
                }
                action("POS Setup")
                {
                    ApplicationArea = All;
                    Caption = 'POS Setup';
                    RunObject = page "POS Setup";
                    ToolTip = 'Configure POS module settings.';
                }
                action("POS Tender Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Tender Setup';
                    RunObject = page "POS Tender Setup";
                    ToolTip = 'Configure payment methods and settlement accounts.';
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
                ToolTip = 'View and manage POS transactions.';
            }
            action("Embedded POS Sessions")
            {
                ApplicationArea = All;
                Caption = 'POS Sessions';
                RunObject = page "POS Sessions";
                ToolTip = 'View and manage POS sessions.';
            }
        }
        area(Processing)
        {
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
