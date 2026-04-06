page 50234 "Requisition Approval Comments"
{
    Caption = 'Approval Comments';
    PageType = Worksheet;
    DataCaptionFields = "Document Type", "Document No.";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    SourceTable = "Approval Comment Line";
    layout
    {
        area(content)
        {
            field(DocNo; DocNo)
            {
                CaptionClass = FORMAT(DocType);
                Editable = false;
                ApplicationArea = All;
            }
            repeater(General)
            {
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Date and Time"; Rec."Date and Time")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Table ID" := NewTableId;
        Rec."Document Type" := NewDocumentType;
        Rec."Document No." := NewDocumentNo;
    end;

    var
        NewTableId: Integer;
        NewDocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        NewDocumentNo: Code[20];
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        DocNo: Code[20];

    procedure SetUpLine(TableId: Integer; DocumentType: option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; DocumentNo: Code[20])
    begin
        NewTableId := TableId;
        NewDocumentType := DocumentType;
        NewDocumentNo := DocumentNo;
    end;

    procedure Setfilters(TableId: Integer; DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition"; DocumentNo: Code[20])
    begin
        IF TableId <> 0 THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETCURRENTKEY("Table ID", "Document Type", "Document No.");
            Rec.SETRANGE("Table ID", TableId);
            Rec.SETRANGE("Document Type", DocumentType);
            IF DocumentNo <> '' THEN
                Rec.SETRANGE("Document No.", DocumentNo);
            Rec.FILTERGROUP(0);
        END;

        DocType := DocumentType;
        DocNo := DocumentNo;
    end;
}

