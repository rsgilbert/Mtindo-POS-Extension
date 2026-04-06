tableextension 50065 "User Setup ExtV1" extends "User Setup"
{
    fields
    {
        field(50092; Requestor; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; Delegatee; Boolean)
        {
            Caption = 'Delegatee';
        }
        field(50203; "Re-open LPO"; Boolean)
        {
            Caption = 'Reopen Purch. Order/Workplan';
        }
        field(50204; "Process Overdue Bank Rec"; Boolean)
        {
            Caption = 'Process Overdue Bank Rec';
        }
        field(50206; "View All Requisitions"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View All Purchase Requisitions';
        }
        field(50308; "Edit Cost Center on Reqs"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "View All Workplans"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Reopen Bank Account Recon."; Boolean)
        {
        }
        field(50114; "Grants Team"; Boolean)
        {
        }
        field(50116; "Procurement Officer"; Boolean)
        {
        }
        field(50118; "Administration Team"; Boolean)
        {

        }
        field(50120; "View All Accountabilities"; Boolean)
        {

        }
        field(50121; "View All Payment Reqs."; Boolean)
        {
            Caption = 'View All Payment Requisitions';
        }
        field(50122; "Edit chart of accounts"; Boolean)
        {
            Caption = 'Edit chart of accounts';
        }
        field(50123; "Reverse Accountability"; Boolean)
        {
            Caption = 'Reverse Accountability';
        }
        field(50124; Signature; Blob)
        { }
        field(50125; "Finance Admin Payment Reqs View"; Boolean)
        {
            Caption = 'Finance Admin Payment Requisitions View';
        }
        field(50300; "POS Cashier"; Boolean)
        {
            Caption = 'POS Cashier';
            DataClassification = ToBeClassified;
        }
        field(50301; "POS Supervisor"; Boolean)
        {
            Caption = 'POS Supervisor';
            DataClassification = ToBeClassified;
        }
        field(50302; "POS Approval PIN"; Text[88])
        {
            Caption = 'POS Approval PIN';
            DataClassification = ToBeClassified;
        }
        field(50303; "POS PIN Last Changed"; DateTime)
        {
            Caption = 'POS PIN Last Changed';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50304; "POS PIN Configured"; Boolean)
        {
            Caption = 'POS PIN Configured';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
