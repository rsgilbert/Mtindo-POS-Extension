table 50202 "Requisition Approval Templates"
{
    Caption = 'Requisition Approval Templates';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(2; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
            TableRelation = "Requisition Approval Code".Code;

            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
                ApprCode.GET("Approval Code");
                ApprCode.TESTFIELD("Linked To Table No.");
                "Table ID" := ApprCode."Linked To Table No.";
            end;
        }
        field(3; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            OptionMembers = "Workflow User Group","Sales Pers./Purchaser","Approver";
            trigger OnValidate()
            var
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(5; "Limit Type"; option)
        {
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";

            Caption = 'Limit Type';

            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(6; "Additional Approvers"; Boolean)
        {

        }
        field(7; Enabled; Boolean)
        {
            Caption = 'Enabled';

            trigger OnValidate()
            var
                Salesheader: Record "Sales Header";
                //PurchaseHeader: Record "Purchase Requisition Header";
                ApprovalEntry: Record "Approval Entry";
                TempApprovalTemplate: Record "Requisition Approval Templates";
            begin
                IF (Enabled = FALSE) AND (xRec.Enabled = TRUE) THEN BEGIN
                    TempApprovalTemplate.SETRANGE("Approval Code", "Approval Code");
                    TempApprovalTemplate.SETRANGE("Document Type", "Document Type");
                    if not TempApprovalTemplate.FindFirst() then begin
                        CASE "Table ID" OF
                            DATABASE::"Sales Header":
                                begin
                                    Salesheader.SETCURRENTKEY("Document Type", Status);
                                    Salesheader.SETRANGE("Document Type", "Document Type");
                                    Salesheader.SETRANGE(Status, Salesheader.Status::"Pending Approval");
                                    IF Salesheader.FINDFIRST THEN BEGIN
                                        IF CONFIRM(Text006) THEN BEGIN
                                            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Sales Header");
                                            ApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                                            ApprovalEntry.SETFILTER(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            IF ApprovalEntry.FINDFIRST THEN
                                                ApprovalEntry.MODIFYALL(Status, ApprovalEntry.Status::Canceled);
                                        END;
                                        Salesheader.MODIFYALL(Status, Salesheader.Status::Open);
                                    END;
                                end;
                        // DATABASE::"Purchase Requisition Header":
                        //     BEGIN
                        //         // PurchaseHeader.SETCURRENTKEY("Document Type",Status); // To Review
                        //         // PurchaseHeader.SETRANGE("Document Type", Rec."Document Type");
                        //         // //PurchaseHeader.SETRANGE(Status,PurchaseHeader.Status::"Pending Approval"); // To Review
                        //         // IF PurchaseHeader.FINDFIRST THEN BEGIN
                        //         //     IF CONFIRM(Text006) THEN BEGIN
                        //         //         ApprovalEntry.SETRANGE("Table ID", DATABASE::"Purchase Requisition Header");
                        //         //         ApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                        //         //         ApprovalEntry.SETFILTER(
                        //         //           Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                        //         //         IF ApprovalEntry.FINDFIRST THEN
                        //         //             ApprovalEntry.MODIFYALL(Status, ApprovalEntry.Status::Cancelled);
                        //         //     END;
                        //         //     //PurchaseHeader.MODIFYALL(Status,Salesheader.Status::Open); // To Review
                        //         // END;
                        //     END;
                        END;
                    END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Approval Code", "Approval Type", "Document Type", "Limit Type")
        {
        }
        key(Key2; "Table ID", "Approval Type", Enabled)
        {
        }
        key(Key3; "Approval Code", "Approval Type", Enabled)
        {
        }
        key(Key4; Enabled)
        {
        }
        key(Key5; "Limit Type", "Document Type", "Approval Type", Enabled)
        {
        }
        key(Key6; "Table ID", "Document Type", Enabled)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin
        TestValidation;
    end;

    trigger OnRename()
    begin
        TestValidation;
        //RenameAddApprovers(Rec,xRec); // To Review
    end;

    var
        ApprCode: Record "Requisition Approval Code";
        Text006: Label 'Do you want to cancel all outstanding approvals? ';

    procedure TestValidation()
    var
        AppSetup: Record "Req Approval Setup";
    begin
        AppSetup.GET;
        // IF ("Table ID" = DATABASE::"Purchase Requisition Header") AND
        //    ("Limit Type" = "Limit Type"::"Credit Limits") THEN
        //     ERROR(STRSUBSTNO(Text001, FORMAT("Limit Type"), DATABASE::"Purchase Requisition Header"));

        // IF ("Table ID" <> DATABASE::"Purchase Requisition Header") AND
        //    ("Limit Type" = "Limit Type"::"Request Limits") THEN
        //     ERROR(STRSUBSTNO(Text002, FORMAT("Limit Type"), DATABASE::"Purchase Requisition Header"))
        // ELSE BEGIN
        //     IF ("Table ID" = DATABASE::"Purchase Requisition Header") AND
        //        ("Limit Type" = "Limit Type"::"Request Limits") AND
        //        ("Document Type" <> "Document Type"::"Store Requisition") THEN
        //         ERROR(STRSUBSTNO(Text004, FORMAT("Limit Type"), "Table ID"));
        // END;
    end;

    procedure RenameAddApprovers(Template: Record "Requisition Approval Templates"; xTemplate: Record "Requisition Approval Templates")
    var
    //AddApprovers: Record "NFL Additional Approvers";
    //RenamedAddApprovers: Record "NFL Additional Approvers";
    begin
        /* AddApprovers.SETRANGE("Approval Code", xTemplate."Approval Code");
        AddApprovers.SETRANGE("Approval Type", xTemplate."Approval Type");
        AddApprovers.SETRANGE("Document Type", xTemplate."Document Type");
        AddApprovers.SETRANGE("Limit Type", xTemplate."Limit Type");
        IF AddApprovers.FIND('-') THEN BEGIN
            REPEAT
                RenamedAddApprovers := AddApprovers;
                RenamedAddApprovers."Approval Code" := Template."Approval Code";
                RenamedAddApprovers."Approval Type" := Template."Approval Type";
                RenamedAddApprovers."Document Type" := Template."Document Type";
                RenamedAddApprovers."Limit Type" := Template."Limit Type";
                AddApprovers.DELETE;
                RenamedAddApprovers.INSERT;
            UNTIL AddApprovers.NEXT = 0;
        END; */
    end;
}

