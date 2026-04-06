page 50054 "Imprest Pending Accountability"
{
    PageType = List;
    CardPageId = "Payment Requisition Archive";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Req. Header Archive";
    SourceTableView = where("Payee Type" = filter(Imprest), Accounted = filter(false), Accountability = filter(false), Reversed = filter(false), Posted = filter(true));
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Not Accounted"; Rec."Amount Not Accounted")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("WorkPlan No"; Rec."WorkPlan No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Archive Date"; Rec."Archive Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
        area(FactBoxes)
        {

        }
    }


    var

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
            end
    end;
}