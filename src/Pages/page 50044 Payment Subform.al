page 50044 "Payment Subform"
{
    Caption = 'Payment Subform';
    PageType = ListPart;
    SourceTable = "Payment Requisition Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field("WorkPlan Entry No"; Rec."WorkPlan Entry No")
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Editable = EditFields;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amount To Pay"; Rec."Amount To Pay")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Text001: Label 'Amount to pay cannot exceed Amount %1 ';
                    begin
                        if Rec."Amount To Pay" > Rec.Amount then
                            Error(Text001, Rec.Amount);
                    end;
                }
                field("Amount To Pay (LCY)"; Rec."Amount To Pay (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WHT Code"; Rec."WHT Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("WHT on VAT Amount"; Rec."WHT on VAT Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
            group(Deductions)
            {
                //Visible = showDeductions;
                Editable = false;

                field(gvWHTTotal; gvWHTTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Total WHT';
                }
                field(gvWHTonVATTotal; gvWHTonVATTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Total WHT on VAT';
                }
                field(gvVATTotal; gvVATTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Total on VAT';
                }
                field(gvGrossAmount; gvGrossAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Gross Amount';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Related)
            {
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, Cost Center, or Fund Source, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action(Apply)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;

                    trigger OnAction()
                    begin
                        Rec.ApplyVendEntries();
                    end;
                }

                action("Vend Detail Trial Bal")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor - Detail Trial Balance';
                    Image = Report;

                    trigger OnAction()
                    var
                        myInt: Integer;
                        VendorDetailTrialBal: Report "Vendor - Detail Trial Balance";
                        Vendor: Record Vendor;
                    begin
                        Vendor.Reset();
                        IF Rec."Account Type" = Rec."Account Type"::Vendor then begin
                            Vendor.SetRange("No.", Rec."Account No");
                            VendorDetailTrialBal.SetTableView(Vendor);
                            VendorDetailTrialBal.RunModal();
                            clear(VendorDetailTrialBal);
                            Clear(Vendor);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        if Rec."Account Type" = Rec."Account Type"::Vendor then
            EditAmountRate := false
        else
            EditAmountRate := true;
        ControlEditability();
        CalculateDeductions(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
        ControlEditability();
    end;

    var
        PaymentHdr: Record "Payment Requisition Header";
        ShortcutDimCode: array[8] of Code[20];
        EditAmountRate: Boolean;
        EditFields: Boolean;
        gvWHTTotal: Decimal;
        gvWHTonVATTotal: Decimal;
        gvVATTotal: Decimal;
        gvGrossAmount: Decimal;

    procedure ControlEditability()
    var
        Payheader: Record "Payment Requisition Header";
    begin
        if Payheader.Get(Rec."Document No") then begin
            if Payheader.Status = Payheader.Status::Open then
                EditFields := true;
        end;
    end;

    local procedure CalculateDeductions(PaymentReqLine: Record "Payment Requisition Line")
    var
        myInt: Integer;
        lvVendorLedgerEntry: Record "Vendor Ledger Entry";
        PaymentRequisitionLine2: Record "Payment Requisition Line";
        lvPurchInvHeader: Record "Purch. Inv. Header";
    begin
        gvGrossAmount := 0;
        gvVATTotal := 0;
        gvWHTonVATTotal := 0;
        gvWHTTotal := 0;
        PaymentRequisitionLine2.Reset();
        PaymentRequisitionLine2.SetRange("Document Type", PaymentReqLine."Document Type");
        PaymentRequisitionLine2.SetRange("Document No", PaymentReqLine."Document No");
        PaymentRequisitionLine2.SetRange("Account Type", PaymentRequisitionLine2."Account Type"::Vendor);
        if PaymentRequisitionLine2.FindSet() then
            repeat
                gvWHTTotal += PaymentRequisitionLine2."WHT Amount";
                gvWHTonVATTotal += PaymentRequisitionLine2."WHT on VAT Amount";
                gvGrossAmount := PaymentRequisitionLine2.Rate;
            until PaymentRequisitionLine2.Next() = 0;

        lvVendorLedgerEntry.Reset();
        lvVendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
        lvVendorLedgerEntry.SetRange("Vendor No.", PaymentReqLine."Account No");
        lvVendorLedgerEntry.SetRange("Applies-to ID", PaymentReqLine."Document No");
        if lvVendorLedgerEntry.FindSet() then
            repeat
                lvPurchInvHeader.Reset();
                lvPurchInvHeader.SetRange("No.", lvVendorLedgerEntry."Document No.");
                if lvPurchInvHeader.FindFirst() then begin
                    lvPurchInvHeader.CalcFields("Amount Including VAT", Amount);
                    gvVATTotal += (lvPurchInvHeader."Amount Including VAT" - lvPurchInvHeader.Amount);
                end;
            until lvVendorLedgerEntry.Next() = 0;
    end;

}