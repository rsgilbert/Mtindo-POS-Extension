table 50306 "POS Payment Line"
{
    Caption = 'POS Payment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "POS Transaction Header"."No.";
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "POS Session No."; Code[20])
        {
            Caption = 'POS Session No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionMembers = Payment,Refund;
            DataClassification = ToBeClassified;
        }
        field(5; "Payment Method"; Option)
        {
            Caption = 'Payment Method';
            OptionMembers = Cash,Card,Mobile;
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Amount <= 0 then
                    Error('Amount must be greater than zero.');

                RefreshHeader();
            end;
        }
        field(7; "Reference No."; Code[50])
        {
            Caption = 'Reference No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                RefreshHeader();
            end;
        }
        field(8; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        POSHeader: Record "POS Transaction Header";
    begin
        POSHeader.Get("Document No.");
        "POS Session No." := POSHeader."POS Session No.";
        "Created By" := UserId;

        if POSHeader."Transaction Type" = POSHeader."Transaction Type"::Return then
            "Payment Type" := "Payment Type"::Refund
        else
            "Payment Type" := "Payment Type"::Payment;

        RefreshHeader();
    end;

    trigger OnModify()
    begin
        RefreshHeader();
    end;

    trigger OnDelete()
    begin
        RefreshHeader();
    end;

    procedure ValidateLine()
    begin
        if Amount <= 0 then
            Error('Amount must be greater than zero.');

        if ("Payment Method" in ["Payment Method"::Card, "Payment Method"::Mobile]) and ("Reference No." = '') then
            Error('Reference No. is mandatory for %1 payments.', Format("Payment Method"));
    end;

    local procedure RefreshHeader()
    var
        POSHeader: Record "POS Transaction Header";
    begin
        if POSHeader.Get("Document No.") then
            POSHeader.UpdateCalculatedAmounts();
    end;
}
