page 50039 "Detailed Work Plan Entry"
{
    PageType = Card;
    SourceTable = "WorkPlan Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    // ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = EditPage;
                field("Month 1"; Rec.Month1)
                {

                }
                field("Month 2"; Rec.Month2)
                {

                }
                field("Month 3"; Rec.Month3)
                {

                }
                field("Month 4"; Rec.Month4)
                {

                }
                field("Month 5"; Rec.Month5)
                {

                }
                field("Month 6"; Rec.Month6)
                {

                }
                field("Month 7"; Rec.Month7)
                {

                }
                field("Month 8"; Rec.Month8)
                {

                }
                field("Month 9"; Rec.Month9)
                {

                }
                field("Month 10"; Rec.Month10)
                {

                }
                field("Month 11"; Rec.Month11)
                {

                }
                field("Month 12"; Rec.Month12)
                {

                }
            }
        }
    }

    actions
    {
    }

    var
        gvWorkPlanEntry: Record "WorkPlan Line";
        EditPage: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        EditPage := TestStatusOpen();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //Rec.TestOpenHeader();
    end;

    procedure TestStatusOpen(): Boolean
    var
        WorkPlanHdr: Record "WorkPlan Header";
    begin
        if WorkPlanHdr.Get(Rec."WorkPlan No") AND (WorkPlanHdr.Status = WorkPlanHdr.Status::Open) then
            exit(true)
        else
            exit(false)
    end;
}

