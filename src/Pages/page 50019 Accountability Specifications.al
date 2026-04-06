page 50019 "Accountability Specifications"
{
    Caption = 'Accountability Specifications';
    SourceTable = "Accountability Specifications";
    PageType = List;
    // UsageCategory = Lists;
    // ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Account Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Accountability Option"; Rec."Accountability Option")
                {
                    Caption = 'Accountability Options';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        if Rec."Accountability Option" = Rec."Accountability Option"::Return then
                            BankAccountAddition := true
                        else
                            BankAccountAddition := false;
                    end;

                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                    ApplicationArea = All;
                    Editable = BankAccountAddition;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    Caption = 'Bank Account Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Accountability Description';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount to account for';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        if Rec."Accountability Option" = Rec."Accountability Option"::Return then
            BankAccountAddition := true
        else
            BankAccountAddition := false;

    end;

    var
        BankAccountAddition: Boolean;






}

