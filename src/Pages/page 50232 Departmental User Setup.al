page 50232 "Departmental User Setup"
{
    AutoSplitKey = true;
    Caption = 'Departmental User Setup';
    PageType = Card;
    SourceTable = "Departmental User Setup";
    SourceTableView = SORTING("Sequence No.");

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Approval Dimension Code"; Rec."Approval Dimension Code")
                {
                    ApplicationArea = All;
                    CaptionClass = ApprovalDimValueCaptionClass;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount Approval Limit"; Rec."Sales Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
                field("Purchase Amount Approval Limit"; Rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
                field("Unlimited Sales Approval"; Rec."Unlimited Sales Approval")
                {
                    ApplicationArea = All;
                }
                field("Unlimited Purchase Approval"; Rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = All;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                }
                field(Substitute; Rec.Substitute)
                {
                    ApplicationArea = All;
                }
                field("Request Amount Approval Limit"; Rec."Request Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
                field("Unlimited Request Approval"; Rec."Unlimited Request Approval")
                {
                    ApplicationArea = All;
                }
                field("Unlimited Payment Approval"; Rec."Unlimited Payment Approval")
                {
                    ApplicationArea = All;
                }
                field("Payment Amount Approval Limit"; Rec."Payment Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ApprovalDimValueCaptionClass := GetApprovalDimValueCaptionClass();
    end;

    local procedure GetApprovalDimValueCaptionClass(): Text
    var
        ReqApprovalSetup: Record "Req Approval Setup";
        GLSetup: Record "General Ledger Setup";
        ShortcutDimNo: Integer;
    begin
        if not ReqApprovalSetup.Get() then
            exit('');

        if ReqApprovalSetup."Approval Dimension Code" = '' then
            exit('');

        if not GLSetup.Get() then
            exit('');

        if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Global Dimension 1 Code" then
            ShortcutDimNo := 1
        else
            if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Global Dimension 2 Code" then
                ShortcutDimNo := 2
            else
                if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 3 Code" then
                    ShortcutDimNo := 3
                else
                    if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 4 Code" then
                        ShortcutDimNo := 4
                    else
                        if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 5 Code" then
                            ShortcutDimNo := 5
                        else
                            if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 6 Code" then
                                ShortcutDimNo := 6
                            else
                                if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 7 Code" then
                                    ShortcutDimNo := 7
                                else
                                    if ReqApprovalSetup."Approval Dimension Code" = GLSetup."Shortcut Dimension 8 Code" then
                                        ShortcutDimNo := 8;

        if ShortcutDimNo = 0 then
            exit('');

        exit(StrSubstNo('1,2,%1', ShortcutDimNo));
    end;

    var
        ApprovalDimValueCaptionClass: Text;

}

