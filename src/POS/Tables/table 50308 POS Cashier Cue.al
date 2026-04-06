table 50308 "POS Cashier Cue"
{
    Caption = 'POS Cashier Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
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
