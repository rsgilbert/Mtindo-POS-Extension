table 50200 "Departmental User Setup"
{
    Caption = 'Departmental User Setup';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            var
            begin
            end;
        }
        field(3; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                IF "Approver ID" <> '' THEN BEGIN
                    NFLDeptAppr.SETRANGE("Approver ID", "Approver ID");
                    NFLDeptAppr.SETRANGE("Document Type", "Document Type");
                    NFLDeptAppr.SETRANGE("User ID", "User ID");
                    NFLDeptAppr.SETRANGE("Approval Dimension Code", "Approval Dimension Code");
                    IF NFLDeptAppr.FIND('-') THEN
                        ERROR(STRSUBSTNO(Text001, NFLDeptAppr."Approver ID"));
                END;
            end;
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";

            //OptionMembers = " ","Purchase Requisition","Purchase Order","Purchase Invoice","Prepayment Invoice","Payment Requisition","Store Requisition","Store Return","Bank Reconciliation",Payment,"Work Plan";

            trigger OnValidate()
            begin
                VALIDATE("Approver ID");
            end;
        }
        field(7; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            Editable = false;
        }
        field(8; "Approval Dimension Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,1,1';
            trigger OnLookup()
            var
                lvNFLApprovalSetup: Record "Req Approval Setup";
                lvDimValue: Record "Dimension Value";
                frmDimensionValueList: Page "Dimension Value List";
            begin
                CLEAR(frmDimensionValueList);

                lvNFLApprovalSetup.GET;
                lvNFLApprovalSetup.TESTFIELD("Approval Dimension Code");
                lvDimValue.SETFILTER("Dimension Code", lvNFLApprovalSetup."Approval Dimension Code");

                frmDimensionValueList.SETRECORD(lvDimValue);
                frmDimensionValueList.SETTABLEVIEW(lvDimValue);

                frmDimensionValueList.LOOKUPMODE(TRUE);
                IF frmDimensionValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    frmDimensionValueList.GETRECORD(lvDimValue);
                    "Approval Dimension Code" := lvDimValue.Code;
                END;

                CLEAR(frmDimensionValueList);

                VALIDATE("Approval Dimension Code");
            end;

            trigger OnValidate()
            begin
                IF "Approver ID" <> '' THEN BEGIN
                    NFLDeptAppr.SETRANGE("Approver ID", "Approver ID");
                    NFLDeptAppr.SETRANGE("Document Type", "Document Type");
                    NFLDeptAppr.SETRANGE("User ID", "User ID");
                    NFLDeptAppr.SETRANGE("Approval Dimension Code", "Approval Dimension Code");
                    IF NFLDeptAppr.FIND('-') THEN BEGIN
                        "Approval Dimension Code" := '';
                        COMMIT;
                        ERROR(STRSUBSTNO(Text001, NFLDeptAppr."Approver ID"));
                    END;
                END;
            end;
        }
        field(10; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                IF "Salespers./Purch. Code" <> '' THEN BEGIN
                    UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                    UserSetup.SETRANGE("Salespers./Purch. Code", "Salespers./Purch. Code");
                    IF UserSetup.FIND('-') THEN
                        ERROR(Text001, "Salespers./Purch. Code", UserSetup."User ID");
                END;
            end;
        }
        field(12; "Sales Amount Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Sales Amount Approval Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Sales Approval" AND ("Sales Amount Approval Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Sales Amount Approval Limit"), FIELDCAPTION("Unlimited Sales Approval"));
                IF "Sales Amount Approval Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(13; "Purchase Amount Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Purchase Amount Approval Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Purchase Approval" AND ("Purchase Amount Approval Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Purchase Amount Approval Limit"), FIELDCAPTION("Unlimited Purchase Approval"));
                IF "Purchase Amount Approval Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(14; "Unlimited Sales Approval"; Boolean)
        {
            Caption = 'Unlimited Sales Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Sales Approval" THEN
                    "Sales Amount Approval Limit" := 0;
            end;
        }
        field(15; "Unlimited Purchase Approval"; Boolean)
        {
            Caption = 'Unlimited Purchase Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Purchase Approval" THEN
                    "Purchase Amount Approval Limit" := 0;
            end;
        }
        field(16; Substitute; Code[20])
        {
            Caption = 'Substitute';
            TableRelation = "User Setup";
        }
        field(19; "Request Amount Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Request Amount Approval Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Request Approval" AND ("Request Amount Approval Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Request Amount Approval Limit"), FIELDCAPTION("Unlimited Request Approval"));
                IF "Request Amount Approval Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(20; "Unlimited Request Approval"; Boolean)
        {
            Caption = 'Unlimited Request Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Request Approval" THEN
                    "Request Amount Approval Limit" := 0;
            end;
        }
        field(21; "Payment Amount Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Payment Amount Approval Limit';

            trigger OnValidate()
            begin
                IF "Unlimited Payment Approval" AND ("Payment Amount Approval Limit" <> 0) THEN
                    ERROR(Text003, FIELDCAPTION("Payment Amount Approval Limit"), FIELDCAPTION("Unlimited Payment Approval"));
                IF "Payment Amount Approval Limit" < 0 THEN
                    ERROR(Text005);
            end;
        }
        field(22; "Unlimited Payment Approval"; Boolean)
        {
            Caption = 'Unlimited Payment Approval';

            trigger OnValidate()
            begin
                IF "Unlimited Payment Approval" THEN
                    "Payment Amount Approval Limit" := 0;
            end;
        }
    }

    keys
    {
        key(Key1; "User ID", "Approver ID", "Document Type", "Approval Dimension Code", "Sequence No.")
        {
        }
        key(Key2; "Sequence No.")
        {
        }
        key(Key3; "Salespers./Purch. Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Approver ID %1 is already a Departmental approver for this Document Type for this User ID';
        NFLDeptAppr: Record "Departmental User Setup";
        Text003: Label 'You cannot have both a %1 and %2. ';
        Text005: Label 'You cannot have approval limits less than zero.';
}

