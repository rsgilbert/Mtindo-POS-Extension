page 50233 "Requisition Approval Setup"
{
    Caption = 'Requisition Approval Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Req Approval Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Due Date Formula"; Rec."Due Date Formula")
                {
                    ApplicationArea = All;
                }
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = All;
                }
                field("Request Rejection Comment"; Rec."Request Rejection Comment")
                {
                    ApplicationArea = All;
                }
                field("Departmental Level Approval"; Rec."Departmental Level Approval")
                {
                    ApplicationArea = All;
                }
                field("Approval Dimension Code"; Rec."Approval Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Approval Link"; Rec."Approval Link")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Approval Link Portal"; Rec."Approval Link Portal")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }

            }
            group(Notification)
            {
                Caption = 'Notification';
                group("Notify User about:")
                {
                    Caption = 'Notify User about:';
                    field(Approvals; Rec.Approvals)
                    {
                        ApplicationArea = All;
                    }
                    field(Cancellations; Rec.Cancellations)
                    {
                        ApplicationArea = All;
                    }
                    field(Rejections; Rec.Rejections)
                    {
                        ApplicationArea = All;
                    }
                    field(Delegations; Rec.Delegations)
                    {
                        ApplicationArea = All;
                    }
                }
                group("Overdue Approvals")
                {
                    Caption = 'Overdue Approvals';
                    field("Last Run Date"; Rec."Last Run Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {


        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        IF NOT Rec.get() THEN BEGIN
            Rec.init();
            Rec.insert();
        END;
    end;

    var
        //ApprMgtNotification: Codeunit "Req Approvals Mgt Notification";
        OverdueTemplateExists: Boolean;
        Text002: Label 'Do you want to replace the existing template %1 %2?';
        Text003: Label 'Do you want to delete the template %1?';
        AppTemplateExists: Boolean;
        Text004: Label 'Do you want to run the overdue check by the %1?';
}

