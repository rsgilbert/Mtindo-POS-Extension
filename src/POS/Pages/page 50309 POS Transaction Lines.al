page 50309 "POS Transaction Lines"
{
    PageType = ListPart;
    SourceTable = "POS Transaction Line";
    Caption = 'POS Transaction Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Barcode No."; Rec."Barcode No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Original Unit Price"; Rec."Original Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Original Line Discount %"; Rec."Original Line Discount %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Total"; Rec."Line Total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Override Reason"; Rec."Override Reason")
                {
                    ApplicationArea = All;
                }
                field("Override Approved"; Rec."Override Approved")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Price Override Approved By"; Rec."Price Override Approved By")
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
            action(Dimensions)
            {
                Caption = 'Dimensions';
                ApplicationArea = All;
                Image = Dimensions;
                ShortCutKey = 'Alt+D';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                    CurrPage.Update(false);
                end;
            }
            action(ApproveOverride)
            {
                Caption = 'Approve Override';
                ApplicationArea = All;
                Image = Approval;

                trigger OnAction()
                var
                    ApprovalDialog: Page "POS Approval Dialog";
                    POSSecurity: Codeunit "POS Security";
                    SupervisorUserId: Code[50];
                    ApprovalPin: Code[20];
                    ApprovalReason: Text[100];
                begin
                    if not Rec.RequiresOverrideApproval() then
                        Error('The current line does not contain a price or discount override.');

                    if ApprovalDialog.RunModal() <> Action::OK then
                        exit;

                    SupervisorUserId := ApprovalDialog.GetSupervisorUserId();
                    ApprovalPin := ApprovalDialog.GetApprovalPin();
                    ApprovalReason := ApprovalDialog.GetReason();

                    POSSecurity.ValidateSupervisorAuthorization(SupervisorUserId, ApprovalPin);
                    Rec.ApproveOverride(SupervisorUserId, ApprovalReason);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
