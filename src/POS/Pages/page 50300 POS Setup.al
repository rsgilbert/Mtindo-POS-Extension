page 50300 "POS Setup"
{
    PageType = Card;
    Caption = 'POS Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POS Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Default Walk-In Customer No."; Rec."Default Walk-In Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Session Variance Threshold"; Rec."Session Variance Threshold")
                {
                    ApplicationArea = All;
                }
                field("Allow Receipt Reprint"; Rec."Allow Receipt Reprint")
                {
                    ApplicationArea = All;
                }
                field("Require Return Approval"; Rec."Require Return Approval")
                {
                    ApplicationArea = All;
                }
                field("Require Price Override"; Rec."Require Price Override")
                {
                    ApplicationArea = All;
                }
                field("Require Discount Approval"; Rec."Require Discount Approval")
                {
                    ApplicationArea = All;
                }
                field("Auto Post Settlement"; Rec."Auto Post Settlement")
                {
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                field("POS Store Nos."; Rec."POS Store Nos.")
                {
                    ApplicationArea = All;
                }
                field("POS Terminal Nos."; Rec."POS Terminal Nos.")
                {
                    ApplicationArea = All;
                }
                field("POS Session Nos."; Rec."POS Session Nos.")
                {
                    ApplicationArea = All;
                }
                field("POS Receipt Nos."; Rec."POS Receipt Nos.")
                {
                    ApplicationArea = All;
                }
                field("POS Return Nos."; Rec."POS Return Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(Settlement)
            {
                field("Settlement Jnl. Template"; Rec."Settlement Jnl. Template")
                {
                    ApplicationArea = All;
                }
                field("Settlement Jnl. Batch"; Rec."Settlement Jnl. Batch")
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
            action("Tender Setup")
            {
                Caption = 'Tender Setup';
                ApplicationArea = All;
                Image = Setup;
                RunObject = Page "POS Tender Setup";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get('POS') then begin
            Rec.Init();
            Rec."Primary Key" := 'POS';
            Rec.Insert(true);
        end;
    end;
}
