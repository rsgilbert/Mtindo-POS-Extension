table 50046 "Accountability Specifications"
{
    LookupPageId = "Accountability Specifications";
    DrillDownPageId = "Accountability Specifications";
    DataCaptionFields = "Document No", "Originating Line No", "Entry No";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Document No"; Code[20])
        {
            TableRelation = "Payment Req. Header Archive"."No.";
            Caption = 'Document No';
            Editable = false;
        }
        field(3; "Originating Line No"; Integer)
        {
            Editable = false;
        }
        field(4; "Accountability Option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Accountability,Return;
            OptionCaption = ', Accountability,Return';
        }
        field(5; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin
                BankAccount.Reset();
                BankAccount.Get("Bank Account No.");
                "Bank Account Name" := BankAccount.Name;
            end;
        }
        field(6; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            var
                PaytReqLine: Record "Payment Req Line Archive";
                AccSpecifications: Record "Accountability Specifications";
                specificationTotal: Decimal;
            begin
                AccSpecifications.Reset();
                AccSpecifications.setRange("Archive No.", "Archive No.");
                AccSpecifications.setRange("Document No", "Document No");
                AccSpecifications.setRange("Originating Line No", "Originating Line No");
                AccSpecifications.setfilter("Entry No", '<>%1', "Entry No");
                if AccSpecifications.FindSet() then begin
                    AccSpecifications.CalcSums(Amount);
                    specificationTotal := AccSpecifications.Amount;
                end;

                PaytReqLine.Reset();
                PaytReqLine.SetRange("Archive No", "Archive No.");
                PaytReqLine.SetRange("Document No", "Document No");
                PaytReqLine.SetRange("Document Type", PaytReqLine."Document Type"::"Payment Requisition");
                PaytReqLine.setRange("Line No", "Originating Line No");
                if PaytReqLine.FindFirst() then
                    if (specificationTotal + Amount) > (PaytReqLine."Amount Paid" - PaytReqLine."Amount Accounted") then
                        Error('Specification amount should be less or equal to the Amount Accounted on the advance')
            end;
        }
        field(8; "Account Name"; Text[100])
        {
        }
        field(9; Description; Text[100])
        {
        }
        field(10; "Archive No."; Code[20])
        {

        }




    }

    keys
    {
        key(Key1; "Entry No", "Archive No.", "Document No", "Originating Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        PaytArchiveLine: Record "Payment Req Line Archive";
    begin
        PaytArchiveLine.Reset();
        PaytArchiveLine.SetRange("Document Type", PaytArchiveLine."Document Type"::"Payment Requisition");
        PaytArchiveLine.SetRange("Document No", "Document No");
        PaytArchiveLine.SetRange("Line No", "Originating Line No");
        if PaytArchiveLine.FindFirst() then
            Rec."Account Name" := PaytArchiveLine."Account Name";
    end;
}

