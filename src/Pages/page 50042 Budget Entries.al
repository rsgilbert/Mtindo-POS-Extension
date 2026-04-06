page 50042 "Budget Entries"
{
    PageType = Worksheet;
    SourceTable = "WorkPlan Line";
    AutoSplitKey = false;
    DelayedInsert = false;
    MultipleNewLines = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 1 Code"; Rec."WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 3 Code"; Rec."WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("WorkPlan Dimension 4 Code"; Rec."WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension Value Name 1"; Rec."Dimension Value Name 1")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Name 2"; Rec."Dimension Value Name 2")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Name 3"; Rec."Dimension Value Name 3")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Name 4"; Rec."Dimension Value Name 4")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Name 5"; Rec."Dimension Value Name 5")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                }

                field(Encumbrances; Rec.Encumbrances)
                {
                    ApplicationArea = All;
                }
                // field("Pre-Encumbrances"; Rec."Pre-Encumbrances")
                // {
                //     ApplicationArea = All;
                // }
                field("Payment Req. Pre-Encumbrances"; Rec."Payment Req. Pre-Encumbrances")
                {
                    ApplicationArea = All;
                }
                field(Advances; Rec.Advances)
                {
                    ApplicationArea = All;
                }
                field(Accountabilities; Rec.Accountabilities)
                {
                    ApplicationArea = All;
                }
                field(Actuals; Rec.Actuals)
                {
                    ApplicationArea = All;
                }
                field("Actual Invoices"; Rec."Actual Invoices")
                {
                    ApplicationArea = All;
                }
                field("Credit Memos"; Rec."Credit Memos")
                {
                    ApplicationArea = All;
                }
                field("Reallocated Amount"; Rec."Reallocated Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Vs Actual"; BudgetVsActual)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Variance; gvVariance)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Related)
            {
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as Cost Center, Fund Source, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
            }

        }
    }

    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
    begin
        GenReqSetup.Get();
        WorkplanDim1 := GenReqSetup."Work Plan Dimension 1 Code" <> '';
        WorkplanDim2 := GenReqSetup."Work Plan Dimension 2 Code" <> '';
        WorkplanDim3 := GenReqSetup."Work Plan Dimension 3 Code" <> '';
        WorkplanDim4 := GenReqSetup."Work Plan Dimension 4 Code" <> '';
        WorkplanDim5 := GenReqSetup."Work Plan Dimension 5 Code" <> '';
        WorkplanDim6 := GenReqSetup."Work Plan Dimension 6 Code" <> '';
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(BudgetVsActual);
        Clear(gvVariance);
        Rec.CalcFields(Actuals, "Journal Actuals", Encumbrances, "Payment Req. Pre-Encumbrances", "Actual Invoices", Advances, "Credit Memos", Accountabilities);
        BudgetVsActual := Rec."Annual Amount" - (Rec."Actual Invoices" - Rec."Credit Memos") - Rec.Actuals - Rec."Journal Actuals";
        gvVariance := Rec."Annual Amount" - Rec.Encumbrances - Rec."Payment Req. Pre-Encumbrances" - Rec.Actuals - Rec."Reallocated Amount" - (Rec."Actual Invoices" - Rec."Credit Memos") - Rec.Advances - Rec.Accountabilities - Rec."Journal Actuals";
    end;


    var
        myInt: Integer;
        BudgetVsActual: Decimal;
        gvVariance: Decimal;
        WorkplanDim1: Boolean;
        WorkplanDim2: Boolean;
        WorkplanDim3: Boolean;
        WorkplanDim4: Boolean;
        WorkplanDim5: Boolean;
        WorkplanDim6: Boolean;

}