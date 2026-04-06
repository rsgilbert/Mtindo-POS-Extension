page 50040 "Approved WorkPlan"
{
    PageType = Document;
    SourceTable = "WorkPlan Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transferred To Budget"; Rec."Transferred To Budget")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Creation Date"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
            group(Lines)
            {
                part("WorkPlan Lines"; "WorkPlan Lines")
                {
                    Editable = TogleEditability;
                    ApplicationArea = All;
                    SubPageLink = "WorkPlan No" = FIELD("No.");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            group("G/L Accounts")
            {
                action("Insert G/L Accounts")
                {
                    Caption = 'Insert G/L Accounts';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Insert;
                    Visible = false;

                    trigger OnAction()
                    var
                        lvGLaccount: Record "G/L Account";
                        lvWorkPlanLine: Record "WorkPlan Line";
                        lvWorkPlanLineRec: Record "WorkPlan Line";
                        LineNo: Integer;
                    begin
                        ClearWorkPlanLines();
                        lvGLaccount.SetRange("Account Type", lvGLaccount."Account Type"::Posting);
                        lvGLaccount.SetRange("Add to Work Plan", true);
                        if lvGLaccount.FindSet() then
                            repeat
                                lvWorkPlanLine.SetRange("WorkPlan No", Rec."No.");
                                lvWorkPlanLine.SetRange("Budget Code", Rec."Budget Code");
                                if lvWorkPlanLine.FindLast() then
                                    LineNo := lvWorkPlanLine."Entry No" + 10000
                                else
                                    LineNo := 10000;

                                lvWorkPlanLineRec.Init();
                                lvWorkPlanLineRec."Entry No" := LineNo;
                                lvWorkPlanLineRec."WorkPlan No" := Rec."No.";
                                lvWorkPlanLineRec."Budget Code" := Rec."Budget Code";
                                lvWorkPlanLineRec."Account Type" := lvWorkPlanLineRec."Account Type"::"G/L Account";
                                lvWorkPlanLineRec."Account No" := lvGLaccount."No.";
                                lvWorkPlanLineRec."Charge Account" := lvGLaccount."No.";
                                lvWorkPlanLineRec.Validate("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                                lvWorkPlanLineRec.Validate("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                                lvWorkPlanLineRec.Insert(true);
                            until lvGLaccount.Next() = 0;
                        Message('Lines inserted Successfully');
                        CurrPage.Update();
                    end;
                }
            }

            group(Approval)
            {
                action("Reopen Approved Workplan")
                {
                    ApplicationArea = All;
                    Caption = 'Reopen Approved Workplan';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    // Visible = (Rec."Transferred To Budget" = false);
                    Visible = gvTransfered;


                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        Rec.TestField("Transferred To Budget", false);
                        if GuiAllowed then
                            if Confirm('Are you really sure you would like to reopen the approved workplan? Please note that the approval entries will be cancelled.', false) then
                                Rec.OnCancelWorkplanApprovalRequest(Rec);
                    end;
                }

                action("Transfer To Budget")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = TransferFunds;

                    trigger OnAction()
                    begin
                        Rec.TestField("Transferred To Budget", false);
                        if Confirm('Are you really sure you would like to Transfer this work plan to the Budget ? After its transfer it will nolonger be available for Amendments', false) then
                            Rec.TransferToBudget();
                    end;
                }
                action("Approval History")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = History;
                    RunObject = page "Approval Entries";
                    RunPageLink = "Document Type" = filter(Workplan), "Document No." = field("No.");
                }
                action("Archive Document")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Archive;

                    trigger OnAction()
                    begin
                        if Confirm('Are you really sure you would like to archive this work plan ? After archival it will nolonger be accessible for processing', false) then
                            Rec.ArchiveWorkPlan();
                    end;
                }
            }
            group("Create/Import Excel")
            {
                action(ExportToExcel)
                {
                    Caption = 'Export to Excel';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Export;
                    //Visible = false;

                    trigger OnAction()
                    var
                    begin
                        ExportWorkPlan(Rec);
                    end;
                }
                action("&Import")
                {
                    Caption = '&Import';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    ToolTip = 'Import data from excel.';
                    Visible = false;

                    trigger OnAction()
                    var
                    begin
                        ClearWorkPlanLines();
                        ReadExcelSheet();
                        ImportExcelData();
                    end;
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Custom";
                        DocAttachment: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef, true);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
            }
        }
    }

    var
        BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        TogleEditability: Boolean;
        gvTransfered: Boolean;

    trigger OnOpenPage()
    var
    begin
        if Rec.Status = Rec.Status::Open then
            TogleEditability := true;
        if Rec."Transferred To Budget" = false then gvTransfered := false else gvTransfered := true;
    end;

    local procedure ExportWorkPlan(var WorkPlanRec: Record "WorkPlan Header")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        WorkPlanLineRec: Record "WorkPlan Line";
        WorkPlanLbl: Label 'Work Plan Entries';
        ExcelFileName: Label 'WorkPlanEntries_%1_%2';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan No"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Budget Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account No"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 3 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 4 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 5 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 6 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 1 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 2 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 3 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 4 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Output), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Targets), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Budget Activity Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        WorkPlanLineRec.SetRange("WorkPlan No", WorkPlanRec."No.");
        if WorkPlanLineRec.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Budget Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 3 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 4 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 5 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 6 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 1 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 2 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 3 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 4 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Output, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Targets, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Budget Activity Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until WorkPlanLineRec.Next() = 0;
        TempExcelBuffer.CreateNewBook(WorkPlanLbl);
        TempExcelBuffer.WriteSheet(WorkPlanLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

    local procedure ClearWorkPlanLines()
    var
        WkpLine: Record "WorkPlan Line";
    begin
        WkpLine.SetRange("WorkPlan No", Rec."No.");
        if WkpLine.FindFirst() then
            WkpLine.DeleteAll();
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];

    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        WorkPlanRec: Record "WorkPlan Line";
        WorkPlanLineRec: Record "WorkPlan Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        WorkPlanRec.Reset();
        if WorkPlanRec.FindLast() then
            LineNo := WorkPlanRec."Entry No";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            WorkPlanRec.Init();
            WorkPlanRec."Entry No" := LineNo;
            Evaluate(WorkPlanRec."WorkPlan No", GetValueAtCell(RowNo, 1));
            Evaluate(WorkPlanRec."Budget Code", GetValueAtCell(RowNo, 2));
            Evaluate(WorkPlanRec."Account Type", GetValueAtCell(RowNo, 3));
            Evaluate(WorkPlanRec."Account No", GetValueAtCell(RowNo, 4));
            Evaluate(WorkPlanRec.Description, GetValueAtCell(RowNo, 5));
            WorkPlanRec.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 6));
            WorkPlanRec.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 7));
            WorkPlanRec.Validate("WorkPlan Dimension 1 Code", GetValueAtCell(RowNo, 8));
            WorkPlanRec.Validate("WorkPlan Dimension 2 Code", GetValueAtCell(RowNo, 9));
            WorkPlanRec.Validate("WorkPlan Dimension 3 Code", GetValueAtCell(RowNo, 10));
            WorkPlanRec.Validate("WorkPlan Dimension 4 Code", GetValueAtCell(RowNo, 11));
            WorkPlanRec.Validate("WorkPlan Dimension 5 Code", GetValueAtCell(RowNo, 12));
            WorkPlanRec.Validate("WorkPlan Dimension 6 Code", GetValueAtCell(RowNo, 13));
            Evaluate(WorkPlanRec."Quarter 1 Amount", GetValueAtCell(RowNo, 14));
            Evaluate(WorkPlanRec."Quarter 2 Amount", GetValueAtCell(RowNo, 15));
            Evaluate(WorkPlanRec."Quarter 3 Amount", GetValueAtCell(RowNo, 16));
            Evaluate(WorkPlanRec."Quarter 4 Amount", GetValueAtCell(RowNo, 17));
            Evaluate(WorkPlanRec.Output, GetValueAtCell(RowNo, 18));
            Evaluate(WorkPlanRec.Targets, GetValueAtCell(RowNo, 19));
            Evaluate(WorkPlanRec."Budget Activity Type", GetValueAtCell(RowNo, 20));
            WorkPlanRec."Annual Amount" := WorkPlanRec."Quarter 1 Amount" + WorkPlanRec."Quarter 2 Amount" + WorkPlanRec."Quarter 3 Amount" + WorkPlanRec."Quarter 4 Amount";
            WorkPlanRec."Charge Account" := WorkPlanRec."Account No";
            WorkPlanRec.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}

