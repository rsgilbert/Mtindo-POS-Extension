page 50086 "Document Attachment Custom"
{
    Caption = 'Attached Documents';
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Document Attachment";
    SourceTableView = SORTING(ID, "Table ID");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the filename of the attachment.';

                    trigger OnDrillDown()
                    var
                        Selection: Integer;
                    begin
                        if Rec."Document Reference ID".HasValue() then
                            ExportFile(true)
                        else
                            if not IsOfficeAddin or not EmailHasAttachments then
                                InitiateUploadFile(true)
                            else begin
                                Selection := StrMenu(MenuOptionsTxt, 1, SelectInstructionTxt);
                                case
                                    Selection of
                                    1:
                                        InitiateAttachFromEmail();
                                    2:
                                        InitiateUploadFile(true);
                                end;
                            end;
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the attachment is.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
                field("Document Flow Purchase"; Rec."Document Flow Purchase")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(9);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = PurchaseDocumentFlow;
                }
                field("Document Flow Sales"; Rec."Document Flow Sales")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(11);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = SalesDocumentFlow;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenInOneDrive)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open in OneDrive';
                ToolTip = 'Copy the file to your Business Central folder in OneDrive and open it in a new window so you can manage or share the file.', Comment = 'OneDrive should not be translated';
                Image = Cloud;
                Visible = ShareOptionsEnabled;
                Scope = Repeater;
                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    DocumentServiceMgt: Codeunit "Document Service Management";
                    FileName: Text;
                    FileExtension: Text;
                begin
                    FileName := FileManagement.StripNotsupportChrInFileName(Rec."File Name");
                    FileExtension := StrSubstNo(FileExtensionLbl, Rec."File Extension");

                    // DocumentServiceMgt.OpenInOneDriveFromMedia(FileName, FileExtension, Rec."Document Reference ID".MediaId());
                end;
            }
            action(ShareWithOneDrive)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Share';
                ToolTip = 'Copy the file to your Business Central folder in OneDrive and share the file. You can also see who it''s already shared with.', Comment = 'OneDrive should not be translated';
                Image = Share;
                Visible = ShareOptionsEnabled;
                Scope = Repeater;
                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    DocumentServiceMgt: Codeunit "Document Service Management";
                    FileName: Text;
                    FileExtension: Text;
                begin
                    FileName := FileManagement.StripNotsupportChrInFileName(Rec."File Name");
                    FileExtension := StrSubstNo(FileExtensionLbl, Rec."File Extension");

                    // DocumentServiceMgt.ShareWithOneDriveFromMedia(FileName, FileExtension, Rec."Document Reference ID".MediaId());
                end;
            }
            action(Preview)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                Enabled = DowbloadEnabled;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                    if Rec."File Name" <> '' then
                        ExportFile(true);
                end;
            }
            action(AttachFromEmail)
            {
                ApplicationArea = All;
                Caption = 'Attach from email';
                Image = Email;
                Enabled = EmailHasAttachments;
                Scope = Page;
                ToolTip = 'Attach files directly from email.';
                Visible = IsOfficeAddin;

                trigger OnAction()
                begin
                    InitiateAttachFromEmail();
                end;
            }
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload file';
                Image = Document;
                Enabled = true;
                Scope = Page;
                ToolTip = 'Upload file';
                Visible = IsOfficeAddin;

                trigger OnAction()
                begin
                    InitiateUploadFile(true);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        FlowFieldsEditable := true;
        IsOfficeAddin := OfficeMgmt.IsAvailable();

        // if IsOfficeAddin then
        //     EmailHasAttachments := OfficeHostMgmt.EmailHasAttachments()
        // else
        EmailHasAttachments := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
    //  DocumentSharing: Codeunit "Document Sharing";
    begin
        if OfficeMgmt.IsAvailable() or OfficeMgmt.IsPopOut() then
            ShareOptionsEnabled := false
        else
            ShareOptionsEnabled := True;
        //ShareOptionsEnabled := (Rec."Document Reference ID".HasValue()) and (DocumentSharing.ShareEnabled());

        DowbloadEnabled := Rec."Document Reference ID".HasValue();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."File Name" := SelectFileTxt;
    end;

    var
        OfficeMgmt: Codeunit "Office Management";
        OfficeHostMgmt: Codeunit "Office Host Management";
        SalesDocumentFlow: Boolean;
        FileExtensionLbl: Label '.%1', Locked = true;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        ImportTxt: Label 'Attach a document.';
        SelectFileTxt: Label 'Attach File(s)...';
        PurchaseDocumentFlow: Boolean;
        ShareOptionsEnabled: Boolean;
        DowbloadEnabled: Boolean;
        FlowToPurchTxt: Label 'Flow to Purch. Trx';
        FlowToSalesTxt: Label 'Flow to Sales Trx';
        FlowFieldsEditable: Boolean;
        EmailHasAttachments: Boolean;
        IsOfficeAddin: Boolean;
        MenuOptionsTxt: Label 'Attach from email,Upload file', Comment = 'Comma seperated phrases must be translated seperately.';
        SelectInstructionTxt: Label 'Choose the files to attach.';

    var
        FromRecRef: RecordRef;

    local procedure InitiateAttachFromEmail()
    begin
        //OfficeMgmt.InitiateSendToAttachments(FromRecRef);
        CurrPage.Update(true);
    end;

    local procedure InitiateUploadFile(IsCustom: Boolean)
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Record TempBlob;
        FileName: Text;
    begin
        ImportWithFilter(TempBlob, FileName);
        if FileName <> '' then
            DocumentAttachment.SaveAttachment(FromRecRef, FileName, TempBlob, IsCustom);
        CurrPage.Update(true);
    end;

    local procedure GetCaptionClass(FieldNo: Integer): Text
    begin
        if SalesDocumentFlow and PurchaseDocumentFlow then
            case FieldNo of
                9:
                    exit(FlowToPurchTxt);
                11:
                    exit(FlowToSalesTxt);
            end;
    end;

    procedure ExportFile(ShowFileDialog: Boolean): Text
    var
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        if Rec.ID = 0 then
            exit;
        // Ensure document has value in DB
        if not Rec."Document Reference ID".HasValue() then
            exit;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.Blob.CreateOutStream(DocumentStream);
        Rec."Document Reference ID".ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    procedure OpenForRecRef(RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    //VATRepConfigType: Enum "VAT Report Configuration";
    begin
        Rec.Reset();

        FromRecRef := RecRef;

        Rec.SetRange("Table ID", RecRef.Number);

        if RecRef.Number = DATABASE::Item then begin
            SalesDocumentFlow := true;
            PurchaseDocumentFlow := true;
        end;

        case RecRef.Number of
            DATABASE::Customer,
          DATABASE::"Sales Header",
          DATABASE::"Sales Line",
          DATABASE::"Sales Invoice Header",
          DATABASE::"Sales Invoice Line",
          DATABASE::"Sales Cr.Memo Header",
          DATABASE::"Sales Cr.Memo Line":
                SalesDocumentFlow := true;
            DATABASE::Vendor,
          DATABASE::"Purchase Header",
          DATABASE::"Purchase Line",
          DATABASE::"Purch. Inv. Header",
          DATABASE::"Purch. Inv. Line",
          DATABASE::"Purch. Cr. Memo Hdr.",
          DATABASE::"Purch. Cr. Memo Line":
                PurchaseDocumentFlow := true;
        end;

        case RecRef.Number of
            DATABASE::Customer,
            DATABASE::Vendor,
            DATABASE::Item,
            DATABASE::Employee,
            DATABASE::"Fixed Asset",
            DATABASE::Job,
            DATABASE::Resource,
            DATABASE::"VAT Report Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Header",
            DATABASE::"Sales Line",
            DATABASE::"Purchase Header",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    Rec.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Rec.SetRange("Line No.", LineNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Header",
            DATABASE::"Sales Cr.Memo Header",
            DATABASE::"Purch. Inv. Header",
            DATABASE::"Purch. Cr. Memo Hdr.":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Line",
            DATABASE::"Sales Cr.Memo Line",
            DATABASE::"Purch. Inv. Line",
            DATABASE::"Purch. Cr. Memo Line":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Rec.SetRange("Line No.", LineNo);

                    FlowFieldsEditable := false;
                end;
        end;

        // if RecRef.Number = Database::"VAT Report Header" then begin
        //     FieldRef := RecRef.Field(2);
        //     VATRepConfigType := FieldRef.Value;
        //     Rec.SetRange("VAT Report Config. Code", VATRepConfigType);
        // end;

        OnAfterOpenForRecRef(Rec, RecRef, FlowFieldsEditable);
    end;

    procedure OpenForRecRef(RecRef: RecordRef; IsCustom: boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Enum "Attachment Document Type"; // Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Purchase Requisition";
        LineNo: Integer;
    begin
        Rec.Reset;

        FromRecRef := RecRef;

        Rec.SetRange("Table ID", RecRef.Number);


        case RecRef.Number of
            DATABASE::"WorkPlan Header":
                begin
                    //Rec.SetRange("Document Type", DocType::"Work Plan");
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Payment Requisition Header":
                begin
                    FieldRef := RecRef.Field(8);
                    DocType := FieldRef.Value;
                    Rec.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Accountability Header":
                begin
                    Rec.SetRange("Document Type", DocType::Accountability);
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Bank Acc. Reconciliation":
                begin
                    Rec.SetRange("Document Type", DocType::"Bank Reconciliation");
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Dimension Value":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FieldRef := RecRef.Field(9);
                    LineNo := FieldRef.Value;
                    Rec.SetRange("Line No.", LineNo);
                end;
        end;

        OnAfterOpenForRecRef(Rec, RecRef, FlowFieldsEditable);
    end;

    local procedure ImportWithFilter(var TempBlob: Record TempBlob; var FileName: Text)
    var
        FileManagement: Codeunit "File Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeImportWithFilter(TempBlob, FileName, IsHandled, FromRecRef);
        if IsHandled then
            exit;

        FileName := FileManagement.BLOBImportWithFilter(
            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeImportWithFilter(var TempBlob: Record TempBlob; var FileName: Text; var IsHandled: Boolean; RecRef: RecordRef)
    begin
    end;
}

