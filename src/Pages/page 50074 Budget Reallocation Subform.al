page 50074 "Budget Reallocation Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Budget Realloc. Lines";
    SourceTableView = WHERE("Document Type" = FILTER("Budget Reallocation"));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Available Amount";
                field("Budget Revision Type"; Rec."Budget Revision Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the Budget revision type relating to the Budget revision type. The options are Budget Reallocation and Budget cut.';
                }
                field("Workplan No."; Rec."Workplan No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;

                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Workplan Entry No."; Rec."Workplan Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Available Amount"; Rec."Available Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension Code 1"; Rec."Global Dimension Code 1")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Value Name 1"; Rec."Dimension Value Name 1")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension Code 2"; Rec."Global Dimension Code 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Value Name 2"; Rec."Dimension Value Name 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WorkPlan Dimension 1 Code"; Rec."WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Value Name 3"; Rec."Dimension Value Name 3")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("WorkPlan Dimension 2 Code"; Rec."WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Value Name 4"; Rec."Dimension Value Name 4")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 3 Code"; Rec."WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Value Name 5"; Rec."Dimension Value Name 5")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 4 Code"; Rec."WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 5 Code"; Rec."WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("WorkPlan Dimension 6 Code"; Rec."WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("New Workplan No."; Rec."New Workplan No.")
                {
                    ApplicationArea = All;
                    Visible = ShowBudgetReallocField;
                    Editable = ShowBudgetReallocField;
                }
                field("New G/L Account"; Rec."New G/L Account")
                {
                    ApplicationArea = All;
                    Visible = ShowBudgetReallocField;
                    Editable = ShowBudgetReallocField;
                }
                field("New Global Dimension Code 1"; Rec."New Global Dimension Code 1")
                {
                    ApplicationArea = All;
                    // Editable = false;
                    Visible = ShowBudgetReallocField;
                }
                field("New Dimension Value Name 1"; Rec."New Dimension Value Name 1")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowBudgetReallocField;
                }
                field("New Global Dimension Code 2"; Rec."New Global Dimension Code 2")
                {
                    ApplicationArea = All;
                    // Editable = false;
                    Visible = ShowBudgetReallocField;
                }
                field("New Dimension Value Name 2"; Rec."New Dimension Value Name 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowBudgetReallocField;
                }
                field("New WorkPlan Dimension 1 Code"; Rec."New WorkPlan Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = ShowBudgetReallocField;
                    // Editable = ShowBudgetReallocField;
                }
                field("New Dimension Value Name 3"; Rec."New Dimension Value Name 3")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("New WorkPlan Dimension 2 Code"; Rec."New WorkPlan Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = ShowBudgetReallocField;
                    // Editable = ShowBudgetReallocField;
                }
                field("New Dimension Value Name 4"; Rec."New Dimension Value Name 4")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("New WorkPlan Dimension 3 Code"; Rec."New WorkPlan Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    // Editable = ShowBudgetReallocField;
                }
                field("New WorkPlan Dimension 4 Code"; Rec."New WorkPlan Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    // Editable = ShowBudgetReallocField;
                }
                field("New WorkPlan Dimension 5 Code"; Rec."New WorkPlan Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New WorkPlan Dimension 6 Code"; Rec."New WorkPlan Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New Dimension Set ID"; Rec."New Dimension Set ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("New Activity Description"; Rec."New Activity Description")
                {
                    ApplicationArea = All;
                    Visible = ShowBudgetReallocField;
                    Editable = ShowBudgetReallocField;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Allocations")
            {
                ApplicationArea = All;
                Image = GetEntries;
                RunObject = page "Budget Reallocation Amounts";
                RunPageLink = "Document No" = field("Document No"), "Entry No" = field("Entry No");
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Custom";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef, true);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
            group(Dimenions)
            {
                action("From Work Plan")
                {
                    Caption = 'Old Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("To Work Plan")
                {
                    Caption = 'New Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnAction()
                    begin
                        //ShowDimensions_New();
                    end;
                }
            }
        }
    }

    var
        ShowBudgetReallocField: Boolean;

    trigger OnDeleteRecord(): Boolean
    var
        BudgetRellocationHr: Record "Budget Realloc. Header";
    begin
        if BudgetRellocationHr.Get(Rec."Document Type", Rec."Document No") then
            BudgetRellocationHr.TestField(Status, BudgetRellocationHr.Status::Open);
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Budget Revision Type" = Rec."Budget Revision Type"::"Budget Reallocation" then
            ShowBudgetReallocField := true
        else
            ShowBudgetReallocField := false;
    end;
}