page 50313 "POS PIN Setup Dialog"
{
    PageType = StandardDialog;
    Caption = 'Set POS PIN';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(NewPin; NewPin)
                {
                    Caption = 'New PIN';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field(ConfirmPin; ConfirmPin)
                {
                    Caption = 'Confirm PIN';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    procedure GetNewPin(): Text
    begin
        exit(NewPin);
    end;

    procedure GetConfirmPin(): Text
    begin
        exit(ConfirmPin);
    end;

    var
        NewPin: Text[30];
        ConfirmPin: Text[30];
}
