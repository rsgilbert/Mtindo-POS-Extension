tableextension 50201 "Approval Comment Line Ext." extends "Approval Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50185; "New Comment"; Boolean)
        {

        }
    }
    trigger OnAfterInsert()
    var
        ApprovalEntry: Record "Approval Entry";
        DocType: option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Workplan,"Payment Requisition","Bank Transfer","Petty Cash","Payment Voucher","Journal Voucher","Purchase Requisition","Travel Requests","Stores Requisition","Stores Return",Accountability,"Bank Reconciliation","Budget Reallocation","G/L Account","Budget Addition";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        case Rec."Table ID" of
            Database::Vendor:
                begin
                    RecRef := Rec."Record ID to Approve".GetRecord();
                    FieldRef := RecRef.Field(1);
                    //  Rec."Document Type" := Rec."Document Type"::"Vendor Record";
                    Rec."Document No." := FieldRef.Value;
                    Rec."New Comment" := true;
                    Rec.Modify();
                end;
            Database::"G/L Account":
                begin
                    RecRef := Rec."Record ID to Approve".GetRecord();
                    FieldRef := RecRef.Field(1);
                    // Rec."Document Type" := Rec."Document Type"::"G/l Account Record";
                    Rec."Document No." := FieldRef.Value;
                    Rec."New Comment" := true;
                    Rec.Modify();
                end;
            Database::"Bank Account":
                begin
                    RecRef := Rec."Record ID to Approve".GetRecord();
                    FieldRef := RecRef.Field(1);
                    //Rec."Document Type" := Rec."Document Type"::"Bank Account Record";
                    Rec."Document No." := FieldRef.Value;
                    Rec."New Comment" := true;
                    Rec.Modify();
                end;
        // Database::"Purchase Requisition Header":
        //     begin
        //         RecRef := Rec."Record ID to Approve".GetRecord();
        //         FieldRef := RecRef.Field(1);
        //         Rec."Document Type" := FieldRef.Value;
        //         FieldRef := RecRef.Field(2);
        //         Rec."Document No." := FieldRef.Value;
        //         Rec."New Comment" := true;
        //         Rec.Modify();
        //     end;
        end;
        ApprovalEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
        ApprovalEntry.SetRange("Approver ID", Rec."User ID");
        if ApprovalEntry.FindFirst() then begin
            Rec."Document Type" := ApprovalEntry."Document Type";
            Rec."Document No." := ApprovalEntry."Document No.";
            Rec."Table ID" := ApprovalEntry."Table ID";
            Rec."New Comment" := true;
            Rec.Modify();
        end;

    end;

}