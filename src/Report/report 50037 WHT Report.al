report 50037 "WHT Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/rdl/WHTReport.rdl';
    Caption = 'WHT Report';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(Logo; CompanyInformation.Picture)
            {
            }
            column(GLAcc_No; "No.")
            {
            }
            column(ReportTitleLbl; ReportTitleLbl) { }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Business Unit Code" = FIELD("Business Unit Filter");
                DataItemLinkReference = "G/L Account";
                DataItemTableView = SORTING("G/L Account No.", "Posting Date") where(Reversed = filter(false));
                RequestFilterFields = "Posting Date";
                column(VendorName; getVendorName)
                {
                }
                column(TIN; VendorTIN)
                {
                }
                column(DocumentType_GLEntry; "Document Type")
                {
                }
                column(Global_Dimension_1_Code_GLEntry; "Global Dimension 1 Code") { }
                column(GlobalDimension2Code_GLEntry; "Global Dimension 2 Code")
                {
                }
                // column(ShortcutDimension4Code_GLEntry; "Shortcut Dimension 3 Code")
                // {
                // }
                column(Amount_GLEntry; Amount)
                {
                }
                column(PostingDate_GLEntry; Format("Posting Date"))
                {
                }
                column(Invoice_Date; Format(getpostingdate))
                {

                }
                column(Invoice_No; getDocumentNo)
                {

                }
                column(InvoiceAmount; InvoiceAmount) { }
                column(Description_Supplies; getDescription)
                {

                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(ExtDocNo_GLEntry; "External Document No.")
                {
                    IncludeCaption = true;
                }
                column(Description_GLEntry; Description)
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                column(GlobalDim1Name; gvGlobalDim1Name) { }
                column(GlobalDim2Name; gvGlobalDim2Name) { }

                trigger OnAfterGetRecord()
                var
                    DetailedVenderLedgeEntry2: Record "Detailed Vendor Ledg. Entry";
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    VendorLedgerEntry2: Record "Vendor Ledger Entry";
                    VendorLedgerEntryF: Record "Vendor Ledger Entry";
                    VendorLedgerEntryF2: Record "Vendor Ledger Entry";
                    Vendor: Record Vendor;
                    GenLedgerSetup: Record "General Ledger Setup";
                begin
                    CLEAR(getpostingdate);
                    CLEAR(getDocumentNo);
                    CLEAR(getDescription);
                    CLEAR(getAdditionalBase);
                    CLEAR(InvoiceAmount);
                    CLEAR(getVendorName);
                    CLEAR(VendorTIN);

                    VendorLedgerEntry.SetRange("Document No.", "Document No.");
                    VendorLedgerEntry.SetRange("Posting Date", "Posting Date");
                    VendorLedgerEntry.SetRange(Open, false);
                    if VendorLedgerEntry.FindFirst() then begin
                        VendorLedgerEntry2.SetCurrentKey("Closed by Entry No.");
                        VendorLedgerEntry2.SetRange("Closed by Entry No.", VendorLedgerEntry."Entry No.");
                        if VendorLedgerEntry2.FindFirst() then begin
                            getpostingdate := VendorLedgerEntry2."Posting Date";
                            getDocumentNo := VendorLedgerEntry2."Document No.";
                            getDescription := VendorLedgerEntry2.Description;
                            VendorLedgerEntry2.CALCFIELDS(Amount, "Amount (LCY)");
                            InvoiceAmount := VendorLedgerEntry2."Amount (LCY)";
                            getAdditionalBase := VendorLedgerEntry2.Amount;
                            IF Vendor.GET(VendorLedgerEntry2."Vendor No.") THEN begin
                                getVendorName := Vendor.Name;
                                VendorTIN := Vendor."VAT Registration No.";
                            end;
                        end;
                    end;
                    if getDocumentNo = '' then begin
                        VendorLedgerEntryF.Reset();
                        VendorLedgerEntryF.SetRange("Document No.", "Document No.");
                        VendorLedgerEntryF.SetRange("Posting Date", "Posting Date");
                        //VendorLedgerEntry.SetRange(Open, false);
                        if VendorLedgerEntryF.FindFirst() then begin
                            DetailedVenderLedgeEntry2.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
                            DetailedVenderLedgeEntry2.SetRange("Vendor Ledger Entry No.", VendorLedgerEntryF."Entry No.");
                            DetailedVenderLedgeEntry2.SetRange("Document Type", VendorLedgerEntryF."Document Type"::Payment);
                            if DetailedVenderLedgeEntry2.FindFirst() then begin
                                getpostingdate := VendorLedgerEntryF."Posting Date";
                                getDocumentNo := VendorLedgerEntryF."Document No.";
                                "Document No." := DetailedVenderLedgeEntry2."Document No.";
                                getDescription := VendorLedgerEntryF.Description;
                                //DetailedVenderLedgeEntry2.CALCFIELDS(Amount, "Amount (LCY)");
                                InvoiceAmount := VendorLedgerEntryF."Amount (LCY)";
                                getAdditionalBase := DetailedVenderLedgeEntry2."Amount (LCY)";
                                IF Vendor.GET(VendorLedgerEntryF."Vendor No.") THEN begin
                                    getVendorName := Vendor.Name;
                                    VendorTIN := Vendor."VAT Registration No.";
                                end;
                            end;
                        end;
                    end;

                    if getDocumentNo = '' then
                        getDocumentNo := "G/L Entry"."Document No.";

                    if getDescription = '' then
                        getDescription := "G/L Entry".Description;

                    if getPostingDate = 0D then
                        getPostingDate := "G/L Entry"."Posting Date";
                    //Get Dimension names
                    Clear(gvGlobalDim1Name);
                    Clear(gvGlobalDim2Name);
                    GenLedgerSetup.Get();
                    DimensionValues.Reset();
                    DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 1 Code");
                    DimensionValues.SetRange(Code, "G/L Entry"."Global Dimension 1 Code");
                    if DimensionValues.FindFirst() then
                        gvGlobalDim1Name := DimensionValues.Name;

                    DimensionValues.Reset();
                    DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 2 Code");
                    DimensionValues.SetRange(Code, "G/L Entry"."Global Dimension 2 Code");
                    if DimensionValues.FindFirst() then
                        gvGlobalDim2Name := DimensionValues.Name;

                end;

                trigger OnPreDataItem()
                begin
                    if "G/L Entry".GetFilter("G/L Account No.") = '' then
                        // "G/L Entry".SETFILTER("G/L Account No.", '%1|%2', WHTVATAccount, WHTAccount);
                        "G/L Entry".SETFILTER("G/L Account No.", '%1', WHTAccount);

                    "G/L Entry".SetFilter("Credit Amount", '<>%1', 0);
                end;
            }

            trigger OnPreDataItem()
            begin
                //GLSetup.GET;
                "G/L Account".SETFILTER("No.", '%1|%2', WHTVATAccount, WHTAccount);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Visible = false;
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date when you want the report to start.';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date when you want the report to end.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters();
        GLDateFilter := "G/L Account".GetFilter("Date Filter");
        CompanyInformation.Get();
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

        lvWHTPostingGroup.Reset();
        lvWHTPostingGroup.SetFilter("WHT On VAT %", '<>%1', 0);
        if lvWHTPostingGroup.FindFirst() then
            WHTVATAccount := lvWHTPostingGroup."WHT On VAT Account No.";

        lvWHTPostingGroup.Reset();
        lvWHTPostingGroup.SetFilter("WHT %", '<>%1', 0);
        if lvWHTPostingGroup.FindFirst() then
            WHTAccount := lvWHTPostingGroup."Payable WHT Account Code";
    end;

    var
        GLDateFilter: Text;
        CompanyInformation: Record "Company Information";
        DimensionValues: Record "Dimension Value";
        lvWHTPostingGroup: Record "WHT Posting Groups";
        GLFilter: Text;
        StartDate: Date;
        EndDate: Date;
        getPostingDate: Date;
        getDocumentNo: Code[20];
        getDescription: Text[100];
        getAdditionalBase: Decimal;
        InvoiceAmount: Decimal;
        getVendorName: Text;
        VendorTIN: Text;
        gvGlobalDim1Name: Text;
        gvGlobalDim2Name: Text;
        WHTVATAccount: Code[20];
        WHTAccount: Code[20];
        ReportTitleLbl: Label 'WHT Report';

}