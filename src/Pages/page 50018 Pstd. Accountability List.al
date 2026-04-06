page 50018 "Pstd. Accountability List"
{
    PageType = List;
    CardPageId = "Pstd. Accountability Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Accountability Header";
    Caption = 'Posted Accountability List';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the document of the posted accountability.';
                }
                field("Requisitioned By"; Rec."Requisitioned By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee number of the requestor of the posted accountability.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the accountability was posted.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short description about the accountability.';
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee number of the staff that received the accountability funds.';

                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the employee name of the staff that received the accountability funds.';
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the workplan No. associated with the accountability.';
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the budget code linked to the accountability.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the accountability document.';

                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total, in the currency of the accountability, of the amounts on all the accountability lines';
                }
                field("Global Dim 1 Value"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the global dimension 1 value code related to the accountability.';
                }
                field("Global Dim 2 Value"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the global dimension 2 value code related to the accountability.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the posted accountability has been reversed.';
                }

            }
        }
        area(FactBoxes)
        {

        }
    }





    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
        lvUserSetup: Record "User Setup";
    begin
        lvUserSetup.Reset();
        lvUserSetup.SetRange("User ID", UserId);
        if lvUserSetup.FindFirst() then
            if not lvUserSetup."View All Accountabilities" then begin
                GenReqSetup.Get();
                if GenReqSetup.getDefaultCostCenter() <> '' then begin
                    Rec.FilterGroup(10);
                    Rec.SetFilter("Global Dimension 1 Code", GenReqSetup.getDefaultCostCenter());
                    Rec.FilterGroup(0);
                end
                else begin
                    Rec.FilterGroup(10);
                    REC.SetFilter("Created By", USERID);
                    Rec.FilterGroup(0);
                end;
            end;
    end;
}