page 50064 "Accountability Subform"
{
    PageType = ListPart;
    SourceTable = "Accountability Line";
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
                    Editable = GeneratedFromPr;
                    ToolTip = 'Specifies the Account type for the transaction. For the accountability, the acceptable values are G/L Account and Bank Account';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    Editable = GeneratedFromPr;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';
                }
                field("WorkPlan Entry No"; Rec."WorkPlan Entry No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the workplan entry number or Budget line related to the transaction.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account name that the entry on the journal line will be posted to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = GeneratedFromPr;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = EditAmountRate;
                    Visible = false;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Editable = EditAmountRate;
                    Visible = false;
                }
                field("Accountable Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = GeneratedFromPr;
                }
                field("Accountable Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount To Account"; Rec."Amount To Pay")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Amount To Account (LCY)"; Rec."Amount To Pay (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Applies-To-DocNo"; Rec."Applies-To-DocNo")
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
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
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
                action(Apply)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.ApplyCustEntries();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Rec.TestField("Generated From PR", false);
    end;

    trigger OnOpenPage()
    var
    begin
        if Rec."Generated From PR" = false then
            GeneratedFromPr := true
        else
            GeneratedFromPr := false;

    end;

    var
        PaymentHdr: Record "Accountability Header";
        ShortcutDimCode: array[8] of Code[20];
        EditAmountRate: Boolean;
        SalesStat: Page "Sales Statistics";
        GeneratedFromPr: Boolean;

    procedure TestPayeeType()
    var
        PayHeader: Record "Accountability Header";
    begin
        if PayHeader.Get(Rec."Document No") then begin
            if Rec."Account Type" = Rec."Account Type"::"Bank Account" then
                PayHeader.TestField("Payee Type", PayHeader."Payee Type"::Bank);

            if Rec."Account Type" = Rec."Account Type"::Vendor then
                PayHeader.TestField("Payee Type", PayHeader."Payee Type"::Vendor);

            if Rec."Account Type" = Rec."Account Type"::Customer then
                PayHeader.TestField("Payee Type", PayHeader."Payee Type"::Imprest);

            if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
                if (PayHeader."Payee Type" = PayHeader."Payee Type"::Customer) OR (PayHeader."Payee Type" = PayHeader."Payee Type"::Statutory) OR
                 (PayHeader."Payee Type" = PayHeader."Payee Type"::" ") OR (PayHeader."Payee Type" = PayHeader."Payee Type"::Employee) then
                    exit
                else
                    Error('Payment Category in the header must be for either Customer, Statutory or Direct');
            end;

        end;
    end;

}