page 50031 "Gen. Requisition Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Requisition Setup";
    Caption = 'General Requisition Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Auto Inventory Posting"; rec."Auto Inventory Posting")
                {
                    ApplicationArea = All;
                }
                field("Send Notification"; Rec."Send Notification")
                {
                    ApplicationArea = All;
                }
                field("Send Vend Notification"; Rec."Send Vend Notification")
                {
                    ApplicationArea = All;
                }
                field("Auto Archive Pay. Req"; Rec."Auto Archive Pay. Req")
                {
                    ApplicationArea = All;
                }
                field("Auto Archive Purch. Req"; Rec."Auto Archive Purch. Req")
                {
                    ApplicationArea = All;
                }
                field("Archive Store Requisition"; Rec."Archive Store Requisition")
                {
                    ApplicationArea = All;
                }
                field("Request Nos."; Rec."Request Nos.")
                {
                    ApplicationArea = All;
                }
                field("Auto Send App Req For Purc Req"; Rec."Auto Send App Req For Purc Req")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable if purchase requisitions should be automatically sent for approval if converted from a request';
                }
                field("Auto Send App Req For Pay Req"; Rec."Auto Send App Req For Pay Req")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable if payment requisitions should be automatically sent for approval if converted from a request';
                }
                field("Enable stores Req Approvals"; Rec."Enable stores Req Approvals")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable if stores requisition require approval before the issue is posted or a transfer order is generated.';
                }

            }
            group("Work Plan")
            {
                field("Work Plan Nos."; Rec."Work Plan Nos.")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Archive Nos."; Rec."Work Plan Archive Nos.")
                {
                    ApplicationArea = All;
                }
                field("Budget Reallocation No."; Rec."Budget Reallocation No.")
                {
                    ApplicationArea = All;
                }
                field("Budget Realloc. Archive No."; Rec."Budget Realloc. Archive No.")
                {
                    ApplicationArea = All;
                    Caption = 'Budget Reallocation Archive No.';
                }
            }
            group("Purchase Requisition")
            {
                field("Purchase Requisition Nos."; Rec."Purchase Requisition Nos.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Req. Archive Nos."; Rec."Purchase Req. Archive Nos.")
                {
                    ApplicationArea = All;
                }
                field("Procurement Email"; Rec."Procurement Email")
                {
                    ApplicationArea = All;
                }
                field("Proc. Team Email For Requests"; Rec."Proc. Team Email For Requests")
                {
                    ApplicationArea = All;
                }
                field("Purchase Req Due Date formula"; Rec."Purchase Req Due Date formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the date formula that will be used to calculate the overdue date of a purchase requisition after it has been approved.';
                }

            }
            group("Stores Requisition")
            {
                field("Store Requisition Nos"; Rec."Store Requisition Nos")
                {
                    ApplicationArea = All;
                }
                field("Validity Date Formula"; Rec."Validity Date Formula")
                {
                    ApplicationArea = All;
                }
                field("Store Req Item Jnl Template"; Rec."Store Req Item Jnl Template")
                {
                    ApplicationArea = All;
                }
                field("Store Req Item Jnl Batch"; Rec."Store Req Item Jnl Batch")
                {
                    ApplicationArea = All;
                }
            }
            group("Payment Requisition")
            {
                field("Payment Requisition Nos."; Rec."Payment Requisition Nos.")
                {
                    ApplicationArea = All;
                }
                field("Payment Voucher Nos."; Rec."Payment Voucher Nos.")
                {
                    ApplicationArea = All;
                }
                field("Payment Req. Archive Nos."; Rec."Payment Req. Archive Nos.")
                {
                    ApplicationArea = All;
                }
                field("Bank Transfer Nos."; Rec."Bank Transfer Nos.")
                {
                    ApplicationArea = All;
                }
                field("Accountability Nos."; Rec."Accountability Nos.")
                {
                    ApplicationArea = All;
                }
                field("Travel Request Nos."; Rec."Travel Request Nos.")
                {
                    ApplicationArea = All;
                }
                field("Requisition Journal Template"; Rec."Requisition Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Req Journal Batch"; Rec."Req Journal Batch")
                {
                    ApplicationArea = All;
                }

                field("Auto Transfer Approved Pay Req"; Rec."Auto Transfer Approved Pay Req")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Approved Payment Requisition To Journal';
                }

            }
            group(Dimensions)
            {
                field("Work Plan Dimension 1 Code"; Rec."Work Plan Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Dimension 2 Code"; Rec."Work Plan Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Dimension 3 Code"; Rec."Work Plan Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Dimension 4 Code"; Rec."Work Plan Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Dimension 5 Code"; Rec."Work Plan Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Work Plan Dimension 6 Code"; Rec."Work Plan Dimension 6 Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {

    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;

    var
        myInt: Integer;
}