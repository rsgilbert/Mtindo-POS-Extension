pageextension 50039 "Purchase Order ExtV1" extends "Purchase Order"
{
    layout
    {
        // modify("Vendor Invoice No.")
        // {
        //     Editable = false;
        //     //trigger OnLookup(var Text: Text): Boolean
        //     trigger OnAssistEdit()
        //     begin
        //         //    Rec.LookupVendorInvoiceNo();
        //     end;
        // }



        modify("Posting Date")
        {
            Importance = Promoted;
            Visible = true;
        }
        // Add changes to page layout here
        addafter(Status)
        {
            field("Work Plan"; Rec."Work Plan")
            {
                ApplicationArea = All;
            }


        }
        // addbefore(PurchaseDocCheckFactbox)
        // {
        //     part(Control80; "Work Plan Line FactBox")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Provider = PurchLines;
        //         SubPageLink = "WorkPlan No" = field("Work Plan"), "Budget Code" = field("Budget Name"), "Entry No" = field("Work Plan Entry No.");
        //         UpdatePropagation = Both;
        //     }
        // }
    }

    actions
    {
        // Add changes to page actions here


        modify(Dimensions)
        {
            Visible = false;
        }

        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
        modify(Approve)
        {
            Visible = false;
        }
        modify(Reject)
        {
            Visible = false;
        }
        modify(Delegate)
        {
            Visible = false;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
                checkLinemandatoryFields(Rec);
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
                checkLinemandatoryFields(Rec);
            end;
        }
        modify(Release)
        {
            Visible = false;
        }
        modify("Archive Document")
        {
            trigger OnBeforeAction()
            var
                PurchaseLine: Record "Purchase Line";
                NxtEntryNo: Integer;
            begin

                PurchaseLine.SetRange("Document Type", Rec."Document Type");
                PurchaseLine.SetRange("Document No.", Rec."No.");
                if Purchaseline.findset() then
                    repeat
                        if PurchaseLine."Quantity Received" <> Purchaseline."Quantity Invoiced" then
                            Error('All received quantity must be invoiced for ' + Format(PurchaseLine."Document Type") +
                           ': ' + PurchaseLine."Document No." + ' Line No : ' + format(PurchaseLine."Line No."));
                    until Purchaseline.next() = 0;

            end;

            // trigger OnAfterAction()
            // var
            //     PurchaseLine: Record "Purchase Line";
            //     PurchaseReqHeader: Record "Purchase Requisition Header";
            //     NxtEntryNo: Integer;
            // begin
            //     PurchaseLine.reset();
            //     PurchaseLine.SetRange("Document Type", Rec."Document Type");
            //     PurchaseLine.SetRange("Document No.", Rec."No.");
            //     if Purchaseline.findset() then
            //         repeat
            //             PurchaseLine.Delete();
            //         until Purchaseline.next() = 0;
            //     Rec.Delete();
            // end;

        }


        addafter(CancelApprovalRequest)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Visible = Rec.Status = Rec.Status::Open;
                Enabled = Rec.Status = Rec.Status::Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Text001: Label 'Please specify the Vat Code in the lines for each line';
                    PurchLine: Record "Purchase Line";
                    RecRef: RecordRef;
                begin

                    checkLinemandatoryFields(Rec);
                    RecRef.GetTable(Rec);
                    IF Confirm('Are you really sure, you would like to send this order for approval ?', false) then
                        Rec.OnSendPurchaseApprovalRequest(RecRef, Subsciber.GetSenderUserID(''));
                end;
            }
            action("Cancel Approval Re&quest")
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Visible = Rec.Status = Rec.Status::"Pending Approval";
                Enabled = CanCancelApprovalForRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Open THEN
                        ERROR('The Order is already Open');
                    IF Confirm('Are you really sure, you would like to cancel this order approval ?', false) then
                        Rec.OnCancelPurchaseApprovalRequest(Rec);
                end;
            }

            action("Approval History")
            {
                ApplicationArea = All;
                Caption = 'Approval History';
                Image = History;
                RunObject = page "Approval Entries";
                RunPageLink = "Document Type" = const(Order), "Document No." = field("No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
            }
        }
        addafter(Approve)
        {
            action(Approve_Cust)
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve the requested changes.';
                Visible = OpenApprovalEntriesExistForCurrUser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Subsciber.ApproveRecordRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Reject_Cust)
            {
                ApplicationArea = Suite;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject the requested changes.';
                Visible = OpenApprovalEntriesExistForCurrUser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Subsciber.RejectRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Delegate_Cust)
            {
                ApplicationArea = Suite;
                Caption = 'Delegate';
                Image = Delegate;
                ToolTip = 'Delegate the requested changes to the substitute approver.';
                Visible = OpenApprovalEntriesExistForCurrUser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Subsciber.DelegateRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        EditProcurmentMethod();
        if Rec.Status = Rec.Status::"Pending Approval" then
            CurrPage.Editable := false;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Rec.TestField("Created from Requisition", false);
        Rec.TestField(Status, Rec.Status::Open);
    end;

    procedure EditProcurmentMethod()
    var
        myInt: Integer;
    begin
        if Rec.Status = Rec.Status::Released then begin
            HideSendCancel := false;
            Editfields := true;
        end
        else begin
            HideSendCancel := true;
            Editfields := false;
        end;
    end;

    var
        HideSendCancel: Boolean;
        EditPage: Boolean;
        Editfields: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        Subsciber: Codeunit Subscriber;

    procedure CheckApprovalActionControls()
    begin
        CanCancelApprovalForRecord := Subsciber.CanCancelApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExistForCurrUser := Subsciber.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckApprovalActionControls();
    end;

    procedure checkLinemandatoryFields(purchaseheader: record "Purchase Header")
    var
        Purchaseline: record "Purchase Line";
    begin
        purchaseheader.TestField("Shortcut Dimension 1 Code");
        //purchaseheader.TestField("Shortcut Dimension 2 Code");
        // purchaseheader.TestField("Ship-to Name");
        // purchaseheader.TestField("Ship-to City");
        // purchaseheader.TestField("Ship-to Address");
        // purchaseheader.TestField("Ship-to Contact");
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", purchaseheader."Document Type");
        PurchaseLine.SetRange("Document No.", purchaseheader."No.");
        if Purchaseline.findset() then
            repeat
                if PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" then begin
                    PurchaseLine.TestField(PurchaseLine."Depreciation Book Code");
                    PurchaseLine.TestField(PurchaseLine."FA Posting Type");
                end;
            until Purchaseline.next() = 0;



    end;
}