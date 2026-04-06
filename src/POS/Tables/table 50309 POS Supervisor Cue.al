table 50309 "POS Supervisor Cue"
{
    Caption = 'POS Supervisor Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        // Cashier cues (supervisor sees their own shift too)
        field(2; "Open Sessions"; Integer)
        {
            Caption = 'Open Session';
            FieldClass = FlowField;
            CalcFormula = count("POS Session" where("User ID" = field("User ID Filter"), Status = const(Open)));
            Editable = false;
        }
        field(3; "Today's Sales"; Integer)
        {
            Caption = 'Today''s Sales';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where("Cashier User ID" = field("User ID Filter"), "Transaction Type" = const(Sale), Status = const(Posted), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(4; "Today's Returns"; Integer)
        {
            Caption = 'Today''s Returns';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where("Cashier User ID" = field("User ID Filter"), "Transaction Type" = const(Return), Status = const(Posted), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(5; "Pending Transactions"; Integer)
        {
            Caption = 'Pending Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where("Cashier User ID" = field("User ID Filter"), Status = filter(Open | Suspended)));
            Editable = false;
        }
        field(6; "Today's Revenue"; Decimal)
        {
            Caption = 'Today''s Revenue';
            AutoFormatType = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        // Supervisor-specific cues
        field(10; "Pending Return Approvals"; Integer)
        {
            Caption = 'Pending Return Approvals';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where("Transaction Type" = const(Return), Status = const("Pending Approval")));
            Editable = false;
        }
        field(11; "Sessions With Variance"; Integer)
        {
            Caption = 'Sessions With Variance';
            FieldClass = FlowField;
            CalcFormula = count("POS Session" where(Status = const(Closed), "Cash Variance" = filter(<> 0)));
            Editable = false;
        }
        field(12; "All Open Sessions"; Integer)
        {
            Caption = 'All Open Sessions';
            FieldClass = FlowField;
            CalcFormula = count("POS Session" where(Status = const(Open)));
            Editable = false;
        }
        field(100; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(101; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
