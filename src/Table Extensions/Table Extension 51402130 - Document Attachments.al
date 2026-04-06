tableextension 50202 MyExtension extends "Document Attachment"
{
    fields
    {
        // Add changes to table fields here
    }

    var
        FileManagement: Codeunit "File Management";
        IncomingFileName: Text;

        NoDocumentAttachedErr: Label 'Please attach a document first.';
        EmptyFileNameErr: Label 'Please choose a file to attach.';
        NoContentErr: Label 'The selected file has no content. Please choose another file.';
        DuplicateErr: Label 'This file is already attached to the document. Please choose another file.';



    procedure SaveAttachment(RecRef: RecordRef; FileName: Text; TempBlob: Record TempBlob; IsCustom: Boolean)
    var
        DocStream: InStream;
    begin
        OnBeforeSaveAttachment(Rec, RecRef, FileName, TempBlob);

        if FileName = '' then
            Error(EmptyFileNameErr);
        // Validate file/media is not empty
        if not TempBlob.Blob.HasValue() then
            Error(NoContentErr);

        TempBlob.Blob.CreateInStream(DocStream);
        InsertAttachment(DocStream, RecRef, FileName, IsCustom);
    end;

    local procedure InsertAttachment(DocStream: InStream; RecRef: RecordRef; FileName: Text; IsCustom: Boolean)
    begin
        IncomingFileName := FileName;

        Validate("File Extension", FileManagement.GetExtension(IncomingFileName));
        Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(IncomingFileName), 1, MaxStrLen("File Name")));

        // IMPORTSTREAM(stream,description, mime-type,filename)
        // description and mime-type are set empty and will be automatically set by platform code from the stream
        "Document Reference ID".ImportStream(DocStream, '');
        if not "Document Reference ID".HasValue() then
            Error(NoDocumentAttachedErr);

        InitFieldsFromRecRef(RecRef, IsCustom);

        OnBeforeInsertAttachment(Rec, RecRef);
        Insert(true);
    end;

    procedure InitFieldsFromRecRef(RecRef: RecordRef; IsCustom: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Enum "Approval Document Type";
        LineNo: Integer;
    begin
        Validate("Table ID", RecRef.Number);

        case RecRef.Number of
            DATABASE::Customer,
            DATABASE::Vendor,
            DATABASE::Item,
            DATABASE::Employee,
            DATABASE::"Fixed Asset",
            DATABASE::Resource,
            DATABASE::Job,
            DATABASE::"VAT Report Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Payment Requisition Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);

                    FieldRef := RecRef.Field(8);
                    DocType := FieldRef.Value;
                    Validate("Document Type", DocType);

                end;
            Database::"Accountability Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);

                    FieldRef := RecRef.Field(8);
                    DocType := FieldRef.Value;
                    Validate("Document Type", DocType);
                end;
        end;

        case RecRef.Number of
            DATABASE::"WorkPlan Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);
                    Validate("Document Type", DocType::Workplan);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Validate("Line No.", LineNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Dimension Value":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);

                    FieldRef := RecRef.Field(9);
                    LineNo := FieldRef.Value;
                    Validate("Line No.", LineNo);
                end;
        end
    end;

    //[Scope()]
    procedure SaveAttachment_C(RecRef: RecordRef; FileName: Text; TempBlob: Record TempBlob)
    var
        DocStream: InStream;
    begin
        OnBeforeSaveAttachment(Rec, RecRef, FileName, TempBlob);

        if FileName = '' then
            Error(EmptyFileNameErr);
        // Validate file/media is not empty
        if not TempBlob.Blob.HasValue() then
            Error(NoContentErr);

        TempBlob.Blob.CreateInStream(DocStream);
        //InsertAttachment(DocStream, RecRef, FileName);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; FileName: Text; var TempBlob: Record TempBlob)
    begin
    end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    // begin
    // end;

}