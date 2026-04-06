page 50305 "POS Sessions"
{
    PageType = List;
    SourceTable = "POS Session";
    Caption = 'POS Sessions';
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("POS Store Code"; Rec."POS Store Code")
                {
                    ApplicationArea = All;
                }
                field("POS Terminal Code"; Rec."POS Terminal Code")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Opened At"; Rec."Opened At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Opening Float"; Rec."Opening Float")
                {
                    ApplicationArea = All;
                }
                field("Expected Cash"; Rec."Expected Cash")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Counted Cash"; Rec."Counted Cash")
                {
                    ApplicationArea = All;
                }
                field("Cash Variance"; Rec."Cash Variance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Variance Reason"; Rec."Variance Reason")
                {
                    ApplicationArea = All;
                }
                field("Closed At"; Rec."Closed At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Refresh Expected Cash")
            {
                Caption = 'Refresh Expected Cash';
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.EnsureSessionAccess(Rec);
                    POSManagement.RefreshSessionCash(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Close Session")
            {
                Caption = 'Close Session';
                ApplicationArea = All;
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                begin
                    POSManagement.EnsureSessionAccess(Rec);
                    POSManagement.CloseSession(Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Print Session Summary")
            {
                Caption = 'Print Session Summary';
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                var
                    POSManagement: Codeunit "POS Management";
                    POSSession: Record "POS Session";
                begin
                    POSManagement.EnsureSessionAccess(Rec);
                    POSSession.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"POS Session Summary", true, false, POSSession);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        POSManagement: Codeunit "POS Management";
    begin
        POSManagement.ApplySessionVisibilityFilter(Rec);
    end;
}
