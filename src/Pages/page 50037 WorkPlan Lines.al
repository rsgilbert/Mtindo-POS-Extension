page 50037 "WorkPlan Lines"
{
    PageType = ListPart;
    SourceTable = "WorkPlan Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                //Editable = false;
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Activity Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Activity Description';
                }
                field("Activity Description Details"; Rec."Activity Description Details")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    // Editable = false;
                }
                field("WorkPlan Dimension 1 Code"; Rec."WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = WorkplanDim1;
                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = WorkplanDim2;
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

                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                    Caption = 'Output Description';
                    Visible = false;
                }
                field(Input; Rec.Input)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Targets; Rec.Targets)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 1 Amount"; Rec."Quarter 1 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 2 Amount"; Rec."Quarter 2 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 3 Amount"; Rec."Quarter 3 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quarter 4 Amount"; Rec."Quarter 4 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Month1"; Rec."Month1")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month1 LCY"; Rec."MonthLCY1")
                {
                    Caption = 'Month 1 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month2"; Rec."Month2")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month2 LCY"; Rec."MonthLCY2")
                {
                    Caption = 'Month 2 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month3"; Rec."Month3")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month3 LCY"; Rec."MonthLCY3")
                {
                    Caption = 'Month 3 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month4"; Rec."Month4")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month4 LCY"; Rec."MonthLCY4")
                {
                    Caption = 'Month 4 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month5"; Rec."Month5")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month5 LCY"; Rec."MonthLCY5")
                {
                    Caption = 'Month 5 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month6"; Rec."Month6")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month6 LCY"; Rec."MonthLCY6")
                {
                    Caption = 'Month 6 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month7"; Rec."Month7")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month7 LCY"; Rec."MonthLCY7")
                {
                    Caption = 'Month 7 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month8"; Rec."Month8")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month8 LCY"; Rec."MonthLCY8")
                {
                    Caption = 'Month 8 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month9"; Rec."Month9")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month9 LCY"; Rec."MonthLCY9")
                {
                    Caption = 'Month 9 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month10"; Rec."Month10")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month10 LCY"; Rec."MonthLCY10")
                {
                    Caption = 'Month 10 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month11"; Rec."Month11")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month11 LCY"; Rec."MonthLCY11")
                {
                    Caption = 'Month 11 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month12"; Rec."Month12")
                {
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }
                field("Month12 LCY"; Rec."MonthLCY12")
                {
                    Caption = 'Month 12 (LCY)';
                    ApplicationArea = All;
                    visible = viewperiodfields;
                }

                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Annual Amount LCY"; Rec."Annual Amount LCY")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Activity Type"; Rec."Budget Activity Type")
                {
                    ApplicationArea = All;
                }

                field(Encumbrances; Rec.Encumbrances)
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                // field("Pre-Encumbrances"; Rec."Pre-Encumbrances")
                // {
                //     ApplicationArea = All;
                // }
                field("Payment Req. Pre-Encumbrances"; Rec."Payment Req. Pre-Encumbrances")
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field("General Journals"; Rec."General Journals")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    DrillDownPageId = "General Journal Lines";
                    visible = viewFlowFields;
                }
                field(Advances; Rec.Advances)
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field(Accountabilities; Rec.Accountabilities)
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field(Actuals; Rec.Actuals)
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field("Journal Actuals"; Rec."Journal Actuals")
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field("Actual Invoices"; Rec."Actual Invoices")
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field("Credit Memos"; Rec."Credit Memos")
                {
                    ApplicationArea = All;
                    visible = viewFlowFields;
                }
                field("Reallocated Amount"; Rec."Reallocated Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    visible = viewFlowFields;
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

                action("More Details")
                {
                    Image = GetEntries;
                    RunObject = page "Detailed Work Plan Entry";
                    RunPageLink = "WorkPlan No" = field("WorkPlan No"), "Entry No" = field("Entry No");
                    ApplicationArea = All;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as Cost Center, Fund Source, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    var
                        WorkplanHeader: Record "WorkPlan Header";
                    begin
                        if WorkplanHeader.Get(Rec."WorkPlan No") then
                            if WorkplanHeader.Status = WorkplanHeader.Status::Open then
                                Rec.ShowDimensions()
                            else
                                Rec.ViewDimensions();
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
        lvworkplanheader: Record "WorkPlan Header";
    begin
        Clear(BudgetVsActual);
        Clear(gvVariance);
        Rec.CalcFields(Actuals, "Journal Actuals", Encumbrances, "Payment Req. Pre-Encumbrances", "Actual Invoices", Advances, "Credit Memos", Accountabilities, "General Journals");
        BudgetVsActual := Rec."Annual Amount LCY" - (Rec."Actual Invoices" - Rec."Credit Memos") - Rec.Actuals - Rec."Journal Actuals";
        gvVariance := Rec."Annual Amount LCY" - Rec.Encumbrances - Rec."Payment Req. Pre-Encumbrances" - Rec.Actuals - Rec."Reallocated Amount" - (Rec."Actual Invoices" - Rec."Credit Memos") - Rec.Advances - Rec.Accountabilities - Rec."Journal Actuals" - Rec."General Journals";

        viewFlowFields := false;
        viewPeriodFields := true;
        lvworkplanheader.Reset();
        lvworkplanheader.SetRange(lvworkplanheader."No.", Rec."WorkPlan No");
        lvworkplanheader.SetRange(lvworkplanheader."Status", lvworkplanheader."Status"::Approved);
        if lvworkplanheader.FindFirst() then begin
            viewFlowFields := true;
            viewPeriodFields := false
        end else begin
            viewFlowFields := false;
            viewPeriodFields := true;
        end;
    end;


    var
        viewPeriodFields: Boolean;
        viewFlowFields: Boolean;
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