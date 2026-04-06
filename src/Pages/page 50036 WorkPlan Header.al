page 50036 "WorkPlan Header"
{
    PageType = Document;
    SourceTable = "WorkPlan Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = OpenStatusVisibility;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Requested By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Dimension?';
                        workplanLine: Record "WorkPlan Line";
                    begin
                        if (xRec."Shortcut Dimension 1 Code" <> '') AND (xRec."Shortcut Dimension 1 Code" <> Rec."Shortcut Dimension 1 Code") then begin
                            if not Confirm(Txt001, false) then begin
                                rec."Shortcut Dimension 1 Code" := xRec."Shortcut Dimension 1 Code";
                                exit
                            end
                            else begin
                                workplanLine.SetRange("WorkPlan No", Rec."No.");
                                if workplanLine.FindSet() then
                                    repeat
                                        workplanLine.Validate("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                                        workplanLine.Modify();
                                    until workplanLine.Next() = 0;
                                Message('Lines have been updated');
                            end;

                        end;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Txt001: Label 'Are you sure you would like to the change the Dimension?';
                        workplanLine: Record "WorkPlan Line";
                    begin
                        if (xRec."Shortcut Dimension 2 Code" <> '') AND (xRec."Shortcut Dimension 2 Code" <> Rec."Shortcut Dimension 2 Code") then begin
                            if not Confirm(Txt001, false) then begin
                                rec."Shortcut Dimension 2 Code" := xRec."Shortcut Dimension 2 Code";
                                exit
                            end
                            else begin
                                workplanLine.SetRange("WorkPlan No", Rec."No.");
                                if workplanLine.FindSet() then
                                    repeat
                                        workplanLine.Validate("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                                        workplanLine.Modify();
                                    until workplanLine.Next() = 0;
                                Message('Lines have been updated');
                            end;

                        end;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Transferred To Budget"; Rec."Transferred To Budget")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        workplanLine: Record "WorkPlan Line";
                        Txt001: Label 'Are you sure you would like to the change the Budget Code ?';
                    begin
                        if (xRec."Budget Code" <> '') AND (xRec."Budget Code" <> Rec."Budget Code") then
                            if not Confirm(Txt001, false) then begin
                                Rec."Budget Code" := xRec."Budget Code";
                                exit
                            end
                            else begin
                                workplanLine.SetRange("WorkPlan No", Rec."No.");
                                if workplanLine.FindSet() then
                                    repeat
                                        workplanLine.Validate("Budget Code", Rec."Budget Code");
                                        workplanLine.Modify();
                                    until workplanLine.Next() = 0;
                                Message('Lines have been updated');
                            end;

                    end;
                }
                field("Creation Date"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the purchase document.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Date Created" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Date Created")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            group(Lines)
            {
                part("WorkPlan Lines"; "WorkPlan Lines")
                {
                    Editable = OpenStatusVisibility;
                    ApplicationArea = All;
                    SubPageLink = "WorkPlan No" = FIELD("No."), "Budget Code" = field("Budget Code");
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
                    Image = Insert;
                    // Visible = Rec.Status = Rec.Status::Open;

                    trigger OnAction()
                    var
                        lvGLaccount: Record "G/L Account";
                        lvWorkPlanLine: Record "WorkPlan Line";
                        lvWorkPlanLineRec: Record "WorkPlan Line";
                        LineNo: Integer;
                    begin
                        Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("Budget Code");
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
                                lvWorkPlanLineRec."Account Name" := lvGLaccount.Name;
                                lvWorkPlanLineRec."Charge Account" := lvGLaccount."No.";
                                lvWorkPlanLineRec.Validate("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                                // lvWorkPlanLineRec.Validate("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                                lvWorkPlanLineRec.Insert(true);
                            until lvGLaccount.Next() = 0;
                        Message('Lines inserted Successfully');
                        CurrPage.Update();
                    end;
                }
            }

            group(Approval)
            {
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.ApproveRecordRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.RejectRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the requested changes to the substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Subsciber.DelegateRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close();
                    end;
                }
                action("Send Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Visible = OpenStatusVisibility;

                    trigger OnAction()
                    var
                    begin
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TestField("Budget Code");
                        if Rec.WorkPlanLinesExist() then
                            if Confirm('Are you sure you would like to send the workplan for approval ?', false) then
                                Rec.OnSendWorkplanApprovalRequest(Rec, Subsciber.GetSenderUserID(''));
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    // Visible = Rec.Status = Rec.Status::"Pending Approval";
                    //Enabled = CanCancelApprovalForRecord;

                    trigger OnAction()
                    begin
                        if Rec.Status IN [Rec.Status::Open, Rec.Status::Rejected] then
                            error('You can only cancel an approved or a pending work plan, the current work plan is %1', Format(rec.Status));
                        if Confirm('Are you really sure you would like to cancel this workplan approval ?', false) then
                            Rec.OnCancelWorkplanApprovalRequest(Rec);
                    end;
                }
                // action("Reopen Workplan")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Cancel Approval Re&quest';
                //     Image = CancelApprovalRequest;
                //     // Visible = (Rec.Status = Rec.Status::Approved) and (Rec."Transferred To Budget" = false);

                //     trigger OnAction()
                //     begin
                //         if Confirm('Are you really sure you would like to reopen this workplan?', false) then
                //             Rec.OnCancelWorkplanApprovalRequest(Rec);
                //     end;
                // }

                action("Approval History")
                {
                    ApplicationArea = All;
                    Image = History;

                    RunObject = page "Approval Entries";
                    RunPageLink = "Document Type" = filter(Workplan), "Document No." = field("No.");
                }

                action("Archive Document")
                {
                    ApplicationArea = All;
                    Image = Archive;
                    // Enabled = Rec.Status = Rec.Status::Open;

                    trigger OnAction()
                    begin
                        if Confirm('Are you really sure you would like to archive this work plan ? After archival it will nolonger be accessible for processing', false) then
                            Rec.ArchiveWorkPlan();
                    end;
                }
                action("Transfer To Budget")
                {
                    ApplicationArea = All;
                    Image = TransferFunds;
                    Visible = false;
                    trigger OnAction()
                    begin
                        if Confirm('Are you really sure you would like to Transfer this work plan to the Budget ? After its transfer it will nolonger be available for Amendments', false) then
                            Rec.TransferToBudget();
                    end;
                }
            }
            group("Create/Import Excel")
            {
                action(ExportToExcel)
                {
                    Caption = 'Export to Excel';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                    begin
                        ExportWorkPlan2(Rec);
                    end;
                }
                action("&Import")
                {
                    Caption = '&Import';
                    Image = ImportExcel;
                    ApplicationArea = All;
                    ToolTip = 'Import data from excel.';
                    Visible = OpenStatusVisibility;

                    trigger OnAction()
                    var
                    begin
                        ClearWorkPlanLines();
                        ReadExcelSheet();
                        ImportExcelData2();
                    end;
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Custom";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef, true);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = Comment;
                    ToolTip = 'View comments related to this document.';

                    trigger OnAction()
                    var
                        ApprovalCommentLine: Record "Approval Comment Line";
                    begin
                        ApprovalCommentLine.SetRange("Table ID", Database::"WorkPlan Header");
                        ApprovalCommentLine.SetRange("Record ID to Approve", Rec.RecordId);
                        Page.run(Page::"Approval Comments", ApprovalCommentLine);
                    end;
                }
            }
        }

    }

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Subsciber: Codeunit Subscriber;
        ExcelImportSucess: Label 'Excel is successfully imported.';
        OpenStatusVisibility: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ChangeExchangeRate: Page "Change Exchange Rate";

    trigger OnOpenPage()
    var
        GenReqSetup: Record "Gen. Requisition Setup";
    begin
        GenReqSetup.Get();
        if GenReqSetup.getDefaultCostCenter() <> '' then begin
            Rec.FilterGroup(10);
            Rec.FilterGroup(0);
        end;
        if Rec.Status = Rec.Status::Open then
            OpenStatusVisibility := true;
    end;

    procedure CheckApprovalActionControls()
    begin
        OpenApprovalEntriesExistForCurrUser := Subsciber.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckApprovalActionControls();
    end;

    local procedure ExportWorkPlan(var WorkPlanRec: Record "WorkPlan Header")
    var
        WorkPlanLineRec: Record "WorkPlan Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
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
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 1 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 2 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 3 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Quarter 4 Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Budget Activity Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        WorkPlanLineRec.SetRange("WorkPlan No", WorkPlanRec."No.");
        if WorkPlanLineRec.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Budget Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 1 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 2 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 3 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Quarter 4 Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
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
        Rec.TestField(Status, Rec.Status::Open);
        WkpLine.SetRange("WorkPlan No", Rec."No.");
        if WkpLine.FindFirst() then
            WkpLine.DeleteAll();
    end;

    local procedure ReadExcelSheet()
    var
        // TempBlob: Codeunit "Temp Blob";
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
        FileName: Text[100];
        SheetName: Text[250];
        NoFileFoundMsg: Label 'No File Found';

    begin
        FileName := FileMgt.BLOBImport(TempBlob, FromFile);
        if FileName <> '' then begin
            TempBlob.Blob.CreateInStream(IStream);
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
        lvGLAccount: Record "G/L Account";
        RowNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
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
            Evaluate(WorkPlanRec."Account Name", GetValueAtCell(RowNo, 5));
            Evaluate(WorkPlanRec.Description, GetValueAtCell(RowNo, 6));
            WorkPlanRec.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 7));
            WorkPlanRec.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 8));
            WorkPlanRec.Validate("WorkPlan Dimension 1 Code", GetValueAtCell(RowNo, 9));
            WorkPlanRec.Validate("WorkPlan Dimension 2 Code", GetValueAtCell(RowNo, 10));
            Evaluate(WorkPlanRec."Quarter 1 Amount", GetValueAtCell(RowNo, 11));
            Evaluate(WorkPlanRec."Quarter 2 Amount", GetValueAtCell(RowNo, 12));
            Evaluate(WorkPlanRec."Quarter 3 Amount", GetValueAtCell(RowNo, 13));
            Evaluate(WorkPlanRec."Quarter 4 Amount", GetValueAtCell(RowNo, 14));
            Evaluate(WorkPlanRec."Budget Activity Type", GetValueAtCell(RowNo, 15));
            WorkPlanRec."Annual Amount" := WorkPlanRec."Quarter 1 Amount" + WorkPlanRec."Quarter 2 Amount" + WorkPlanRec."Quarter 3 Amount" + WorkPlanRec."Quarter 4 Amount";
            WorkPlanRec."Charge Account" := WorkPlanRec."Account No";
            if lvGLAccount.Get(WorkPlanRec."Account No") then
                WorkPlanRec."Account Name" := lvGLAccount.Name;
            WorkPlanRec.Validate("Account Type");
            WorkPlanRec.Validate("Account No");
            WorkPlanRec.Insert();

        end;
        Message(ExcelImportSucess);
    end;

    procedure ExportWorkPlan2(var WorkPlanRec: Record "WorkPlan Header")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        WorkPlanLineRec: Record "WorkPlan Line";
        WorkPlanLbl: Label 'Work Plan Entries';
        ExcelFileName: Label 'WorkPlanEntries_%1_%2';
    begin
        WorkPlanLineRec.SetRange("WorkPlan No", WorkPlanRec."No.");
        if WorkPlanLineRec.FindSet() then begin
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan No"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Budget Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account No"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Account Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Global Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("WorkPlan Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption("Budget Activity Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month1), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month2), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month3), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month4), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month5), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month6), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month7), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month8), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month9), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month10), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month11), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(WorkPlanLineRec.FieldCaption(Month12), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Budget Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."WorkPlan Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec."Budget Activity Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month4, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month5, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month6, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month7, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month8, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month9, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month10, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month11, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(WorkPlanLineRec.Month12, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            until WorkPlanLineRec.Next() = 0;
            TempExcelBuffer.CreateNewBook(WorkPlanLbl);
            TempExcelBuffer.WriteSheet(WorkPlanLbl, CompanyName, UserId);
            TempExcelBuffer.CloseBook();
            TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
            TempExcelBuffer.OpenExcel();
        end;
    end;

    procedure ImportExcelData2()
    var
        WorkPlanRec: Record "WorkPlan Line";
        WorkPlanLineRec: Record "WorkPlan Line";
        lvGLAccount: Record "G/L Account";
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
            // Skip 5 since it will be populated through a validation Evaluate(WorkPlanRec."Account Name", GetValueAtCell(RowNo, 5));
            WorkPlanRec.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 6));
            WorkPlanRec.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 7));
            WorkPlanRec.Validate("WorkPlan Dimension 1 Code", GetValueAtCell(RowNo, 8));
            WorkPlanRec.Validate("WorkPlan Dimension 2 Code", GetValueAtCell(RowNo, 9));
            Evaluate(WorkPlanRec.Description, CopyStr((GetValueAtCell(RowNo, 10)), 1, 100));
            Evaluate(WorkPlanRec."Budget Activity Type", GetValueAtCell(RowNo, 11));
            Evaluate(WorkPlanRec.Month1, GetValueAtCell(RowNo, 12));
            Evaluate(WorkPlanRec.Month2, GetValueAtCell(RowNo, 13));
            Evaluate(WorkPlanRec.Month3, GetValueAtCell(RowNo, 14));
            Evaluate(WorkPlanRec.Month4, GetValueAtCell(RowNo, 15));
            Evaluate(WorkPlanRec.Month5, GetValueAtCell(RowNo, 16));
            Evaluate(WorkPlanRec.Month6, GetValueAtCell(RowNo, 17));
            Evaluate(WorkPlanRec.Month7, GetValueAtCell(RowNo, 18));
            Evaluate(WorkPlanRec.Month8, GetValueAtCell(RowNo, 19));
            Evaluate(WorkPlanRec.Month9, GetValueAtCell(RowNo, 20));
            Evaluate(WorkPlanRec.Month10, GetValueAtCell(RowNo, 21));
            Evaluate(WorkPlanRec.Month11, GetValueAtCell(RowNo, 22));
            Evaluate(WorkPlanRec.Month12, GetValueAtCell(RowNo, 23));
            WorkPlanRec."Annual Amount" := WorkPlanRec.Month1 + WorkPlanRec.Month2 + WorkPlanRec.Month3 + WorkPlanRec.Month4 + WorkPlanRec.Month5 + WorkPlanRec.Month6 + WorkPlanRec.Month7 + WorkPlanRec.Month8 + WorkPlanRec.Month9 + WorkPlanRec.Month10 + WorkPlanRec.Month11 + WorkPlanRec.Month12;
            WorkPlanRec."Charge Account" := WorkPlanRec."Account No";
            if lvGLAccount.Get(WorkPlanRec."Account No") then
                WorkPlanRec."Account Name" := lvGLAccount.Name;
            //WorkPlanRec."Procurement Entry" := lvGLAccount."Procurement Account";

            WorkPlanRec.Validate("Account Type");
            WorkPlanRec.Validate("Account No");
            WorkPlanRec.Insert();
            WorkPlanRec.Validate("Month1");
            WorkPlanRec.Validate("Month2");
            WorkPlanRec.Validate("Month3");
            WorkPlanRec.Validate("Month4");
            WorkPlanRec.Validate("Month5");
            WorkPlanRec.Validate("Month6");
            WorkPlanRec.Validate("Month7");
            WorkPlanRec.Validate("Month8");
            WorkPlanRec.Validate("Month9");
            WorkPlanRec.Validate("Month10");
            WorkPlanRec.Validate("Month11");
            WorkPlanRec.Validate("Month12");
            WorkPlanRec.Modify();

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

