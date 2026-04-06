page 50235 "Approval Delegation"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Approval Delegation";

    layout
    {
        area(Content)
        {
            repeater("Approval Delegation")
            {
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approval Document Type"; Rec."Approval Document Type")
                {
                    ApplicationArea = All;
                }
                field("Delegatee ID"; Rec."Delegatee ID")
                {
                    ApplicationArea = All;
                }
                field("Delegatee Name"; Rec."Delegatee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reason for Delegation"; Rec."Reason for Delegation")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }


    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        Usersetup: Record "User Setup";
    begin
        IF Usersetup.GET(Rec."User ID") THEN BEGIN
            Rec.FILTERGROUP(2);
            Filterstring := Rec.GETFILTERS;
            Rec.FILTERGROUP(0);
            IF STRLEN(Filterstring) = 0 THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETCURRENTKEY("User ID");
                Rec.SETRANGE(Rec."User ID", Usersetup."User ID");
                Rec.FILTERGROUP(0);
            END ELSE
                Rec.SETCURRENTKEY("User ID");
        END;
    end;
}