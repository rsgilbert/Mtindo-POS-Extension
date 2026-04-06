page 50088 "Budget Control Setup"
{
    AdditionalSearchTerms = 'finance setup,general ledger setup,g/l setup';
    ApplicationArea = Basic, Suite;
    Caption = 'Budget Control Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Budget Control Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Budget Control Method"; Rec."Budget Control Method")
                {
                    ApplicationArea = All;
                }
                field("Activate Budget Control"; Rec."Activate Budget Control")
                {
                    ApplicationArea = All;
                }
            }
            group(Calculations)
            {
                Caption = 'Calculations';
                group("Amount To Sum")
                {
                    Caption = 'AMOUNTS TO SUM';
                    field("Original Budget"; Rec."Original Budget")
                    {
                        ApplicationArea = All;
                    }
                    field("Preliminary Budget"; Rec."Preliminary Budget")
                    {
                        ApplicationArea = All;
                    }
                    field("Budget Revision"; Rec."Budget Revision")
                    {
                        ApplicationArea = All;
                    }
                    field("Budget Transfers"; Rec."Budget Transfers")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Amount To Subtract")
                {
                    Caption = 'AMOUNTS TO SUBTRACT';
                    field("Actual Expenditure"; Rec."Actual Expenditure")
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider posted G/L entries during budget check';
                    }
                    field("Unposted Expenditure"; Rec."Unposted Expenditure")
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider journal entries during budget check';
                    }
                    field(Encumbrances; Rec.Encumbrances)
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider Released Purchase Orders/Invoices during budget check';
                    }
                    field("Unconfirmed Encumbrances"; Rec."Unconfirmed Encumbrances")
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider Open & Pending Purchase Orders/Invoices during budget check';
                    }
                    field("Pre-encumbrances"; Rec."Pre-encumbrances")
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider Released Purchase/Payment Requisitions during budget check';
                    }
                    field("Unconfirmed Pre-encumbrances"; Rec."Unconfirmed Pre-encumbrances")
                    {
                        ApplicationArea = All;
                        ToolTip = 'This will consider Open/Pending Purchase/Payment Requisitions during budget check';
                    }
                }
            }
            group(Control1900309501)
            {
                Caption = 'Budget Control Dimensions';
                Visible = false;
                field("Budget Dimension 1 Code"; Rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 1 Coded that is linked to the record or entry for Budget Checks';
                }
                field("Budget Dimension 2 Code"; Rec."Budget Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 2 Coded that is linked to the record or entry for Budget Checks';
                }
                field("Budget Dimension 3 Code"; Rec."Budget Dimension 3 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 3 Coded that is linked to the record or entry for Budget Checks';
                }
                field("Budget Dimension 4 Code"; Rec."Budget Dimension 4 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 4 Coded that is linked to the record or entry for Budget Checks';
                }
                field("Budget Dimension 5 Code"; Rec."Budget Dimension 5 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 5 Coded that is linked to the record or entry for Budget Checks';
                }
                field("Budget Dimension 6 Code"; Rec."Budget Dimension 6 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for a Budget dimension 6 Coded that is linked to the record or entry for Budget Checks';
                }
            }
        }
    }


    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
        myInt: Page "Chart of Accounts";
}