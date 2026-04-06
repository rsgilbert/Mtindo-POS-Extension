page 50306 "POS Approval Dialog"
{
    PageType = StandardDialog;
    Caption = 'POS Approval';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(SupervisorUserId; SupervisorUserId)
                {
                    Caption = 'Supervisor User ID';
                    ApplicationArea = All;
                }
                field(ApprovalPin; ApprovalPin)
                {
                    Caption = 'Approval PIN';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field(Reason; Reason)
                {
                    Caption = 'Reason';
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure GetSupervisorUserId(): Code[50]
    begin
        exit(SupervisorUserId);
    end;

    procedure GetApprovalPin(): Code[20]
    begin
        exit(ApprovalPin);
    end;

    procedure GetReason(): Text[100]
    begin
        exit(Reason);
    end;

    var
        SupervisorUserId: Code[50];
        ApprovalPin: Code[20];
        Reason: Text[100];
}
