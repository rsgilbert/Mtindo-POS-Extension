page 50240 "Pending Approval Cue"
{
    PageType = CardPart;
    SourceTable = "Approval Cue";
    RefreshOnActivate = true;
    Caption = 'Approvals';

    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Pending Approval";
                    ToolTip = 'Shows documents pending your approval.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get(UserId) then begin
            Rec.Init();
            Rec."User ID" := UserId;
            Rec.Insert();
        end;
        Rec.Get(UserId);
    end;
}
