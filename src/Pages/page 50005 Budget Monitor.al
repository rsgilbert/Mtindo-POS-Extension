page 50005 "Budget Monitor"
{
    PageType = List;
    SourceTable = "G/L Account";
    SourceTableView = sorting() where("Income/Balance" = filter("Income Statement"));
    Editable = false;
    MultipleNewLines = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posted Expenditure"; Rec."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unposted Expenditure"; Rec."Unposted Expenditure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Encumbrances; Rec.Encumbrances)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pre-Encumbrances"; Rec."Pre-Encumbrances")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Encumbrances"; Rec."Payment Encumbrances")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    var
        NoEmphasize: Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

}