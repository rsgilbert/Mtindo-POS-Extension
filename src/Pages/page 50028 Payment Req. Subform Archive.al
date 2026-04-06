page 50028 "Payment Req. Subform Archive"
{
    PageType = ListPart;
    SourceTable = "Payment Req Line Archive";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WorkPlan Entry No"; Rec."WorkPlan Entry No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount';
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount (LCY)';
                    Editable = false;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount paid for the advance';
                }
                field("Amount Paid (LCY)"; Rec."Amount Paid (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount paid (LCY) for the advance';
                }
                field("Amount to Convert"; Rec."Amount to Convert")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount to Account"; Rec."Amount to Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the amount to account.';
                    Visible = ShowImprestFields;
                }
                field("Amount to Account (LCY)"; Rec."Amount to Account (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount to account in LCY.';
                    Visible = ShowImprestFields;
                }
                field("Amount Accounted"; Rec."Amount Accounted")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount accounted.';
                    Visible = ShowImprestFields;
                }
                field("Amount Accounted (LCY)"; Rec."Amount Accounted (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount accounted in LCY.';
                    Visible = ShowImprestFields;
                }
                field("WHT Code"; Rec."WHT Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    // Visible = Rec."Payee Type" = Rec."Payee Type"::Vendor;
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
                action("Accountability Specifications")
                {
                    ApplicationArea = All;
                    Caption = 'Accountability Specifications';
                    Image = SpecialOrder;
                    ToolTip = 'Accountability Specifications';
                    trigger OnAction()
                    var
                        ArchivedPmtArchivLine: Record "Payment Req Line Archive";
                        AccSpec: Record "Accountability Specifications";
                        AccSpecification: Page "Accountability Specifications";
                    begin
                        ArchivedPmtArchivLine.Reset();
                        CurrPage.SetSelectionFilter(ArchivedPmtArchivLine);
                        if ArchivedPmtArchivLine.FindFirst() then begin
                            AccSpec.Reset();
                            AccSpec.setRange("Archive No.", ArchivedPmtArchivLine."Archive No");
                            AccSpec.setRange("Document No", ArchivedPmtArchivLine."Document No");
                            AccSpec.setRange("Originating Line No", ArchivedPmtArchivLine."Line No");
                            AccSpecification.SetTableView(AccSpec);
                            AccSpecification.RunModal();
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);

        if Rec."Payee Type" = Rec."Payee Type"::Imprest then
            ShowImprestFields := true
        else
            ShowImprestFields := false;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        PaymentHdr: Record "Payment Requisition Header";
        ShortcutDimCode: array[8] of Code[20];
        EditAmountRate: Boolean;
        ShowImprestFields: Boolean;

}