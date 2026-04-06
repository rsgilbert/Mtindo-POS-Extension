pageextension 50033 "G/L Budget Name Ext" extends "G/L Budget Names"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Budget Start Date"; Rec."Budget Start Date")
            {
                ApplicationArea = All;
            }
            field("Budget End Date"; Rec."Budget End Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(EditBudget)
        {


            action("Budget Performance")
            {
                ApplicationArea = All;
                Image = CopyBudget;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                RunObject = page "Budget Monitor";
                RunPageLink = "Budget Filter" = field(Name);
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Page "Purchase Order Subform";

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        GenReqSetup: Record "Gen. Requisition Setup";
    begin
        GenReqSetup.Get();
        GenReqSetup.TestField("Work Plan Dimension 1 Code");
        GenReqSetup.TestField("Work Plan Dimension 2 Code");
        //GenReqSetup.TestField("Work Plan Dimension 3 Code");
        //GenReqSetup.TestField("Work Plan Dimension 4 Code");
        Rec."Budget Dimension 1 Code" := GenReqSetup."Work Plan Dimension 1 Code";
        Rec."Budget Dimension 2 Code" := GenReqSetup."Work Plan Dimension 2 Code";
        //Rec."Budget Dimension 3 Code" := GenReqSetup."Work Plan Dimension 3 Code";
        //Rec."Budget Dimension 4 Code" := GenReqSetup."Work Plan Dimension 4 Code";
    end;
}