tableextension 50050 "G/L Account ExtV1" extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Unposted Expenditure"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Account No." = FIELD("No."),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             "Posting Date" = FIELD("Date Filter"),
            //                                             "Budget Name" = field("Budget Filter"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Unposted Expenditure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("No." = FIELD("No."),
            //                                             Status = filter("Pending Approval" | Released),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             "Budget Name" = field("Budget Filter"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Unconfirmed Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("No." = FIELD("No."),
            //                                             Status = filter(Open),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             "Budget Name" = field("Budget Filter"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Unconfirmed Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Pre-Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Purchase Requisition Line"."Outstanding Amount (LCY)" WHERE("No." = FIELD("No."),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             Status = filter(Approved | "Pending Approval"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Pre-Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Unconfirmed Pre-Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Purchase Requisition Line"."Outstanding Amount (LCY)" WHERE("No." = FIELD("No."),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             Status = filter(Open),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Unconfirmed Pre-Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Payment Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Payment Requisition Line"."Amount To Pay" WHERE("Account No" = FIELD("No."),
            //                                             Status = filter(Approved | "Pending Approval"),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Payment Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Unconfirmed Pay-Encumbrances"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = Sum("Payment Requisition Line"."Amount To Pay (LCY)" WHERE("Account No" = FIELD("No."),
            //                                             Status = filter(Open),
            //                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
            //                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
            //                                             "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Unconfirmed Pay-Encumbrances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Add to Work Plan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(50108; "Travel Expense Type"; Option)
        {
            OptionMembers = " ","Accomodation","Incidental/Other Expenses","Perdiem/Meal Allowance";
            OptionCaption = ' ,Accomodation,Incidentl/Other Expenses,Perdiem/Meal Allowance';
        }

    }

    var
        myInt: Record "G/L Budget Entry";

    [IntegrationEvent(false, false)]
    procedure OnSendGLAccountForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGLAccountApproval(var GLAccount: Record "G/L Account")
    begin
    end;
}