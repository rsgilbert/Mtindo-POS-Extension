page 50318 "POS Supervisor Cue Part"
{
    Caption = 'POS Supervisor Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "POS Supervisor Cue";

    layout
    {
        area(Content)
        {
            cuegroup("My Session")
            {
                Caption = 'My Session';

                field("Open Sessions"; Rec."Open Sessions")
                {
                    ApplicationArea = All;
                    Caption = 'Open Session';
                    DrillDownPageId = "POS Sessions";
                    ToolTip = 'Shows whether you have an active POS session.';
                }
                field("Pending Transactions"; Rec."Pending Transactions")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Transactions';
                    DrillDownPageId = "POS Transactions";
                    ToolTip = 'Shows the number of open or suspended transactions.';
                }
            }
            cuegroup("Today's Activity")
            {
                Caption = 'Today''s Activity';

                field("Today's Sales"; Rec."Today's Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    DrillDownPageId = "POS Posted Receipts";
                    ToolTip = 'Shows the number of sales posted today.';
                }
                field("Today's Returns"; Rec."Today's Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Returns';
                    DrillDownPageId = "POS Posted Returns";
                    ToolTip = 'Shows the number of returns posted today.';
                }
                field("Today's Revenue"; Rec."Today's Revenue")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Revenue';
                    ToolTip = 'Shows the total revenue from today''s posted sales.';
                }
            }
            cuegroup("Supervisor Overview")
            {
                Caption = 'Supervisor Overview';

                field("Pending Return Approvals"; Rec."Pending Return Approvals")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Return Approvals';
                    DrillDownPageId = "POS Transactions";
                    ToolTip = 'Shows returns awaiting supervisor approval.';
                }
                field("Sessions With Variance"; Rec."Sessions With Variance")
                {
                    ApplicationArea = All;
                    Caption = 'Sessions With Variance';
                    DrillDownPageId = "POS Sessions";
                    ToolTip = 'Shows closed sessions where cash variance was not zero.';
                }
                field("All Open Sessions"; Rec."All Open Sessions")
                {
                    ApplicationArea = All;
                    Caption = 'All Open Sessions';
                    DrillDownPageId = "POS Sessions";
                    ToolTip = 'Shows all currently open sessions across all cashiers.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        Rec.SetFilter("User ID Filter", UserId);
        Rec.SetFilter("Date Filter", '%1', Today);
    end;

    trigger OnAfterGetCurrRecord()
    var
        POSTransHeader: Record "POS Transaction Header";
        POSTransLine: Record "POS Transaction Line";
        TotalRevenue: Decimal;
    begin
        TotalRevenue := 0;
        POSTransHeader.SetRange("Cashier User ID", UserId);
        POSTransHeader.SetRange("Transaction Type", POSTransHeader."Transaction Type"::Sale);
        POSTransHeader.SetRange(Status, POSTransHeader.Status::Posted);
        POSTransHeader.SetRange("Posting Date", Today);
        if POSTransHeader.FindSet() then
            repeat
                POSTransLine.SetRange("Document No.", POSTransHeader."No.");
                POSTransLine.CalcSums("Line Total");
                TotalRevenue += POSTransLine."Line Total";
            until POSTransHeader.Next() = 0;
        Rec."Today's Revenue" := TotalRevenue;
    end;
}
