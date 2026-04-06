table 50208 "Approval Cue"
{
    Caption = 'Approval Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Pending Approvals"; Integer)
        {
            Caption = 'Pending Approval';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("User ID"),
                                                        Status = const(Open),
                                                        "Related to Change" = const(false),
                                                        "Document Type" = filter(Workplan | "Payment Requisition")));
        }
    }

    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }
}
