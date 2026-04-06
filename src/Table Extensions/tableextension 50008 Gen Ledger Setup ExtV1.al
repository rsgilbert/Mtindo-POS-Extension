tableextension 50008 "Gen Ledger Setup ExtV1" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50120; "Enable WHT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50122; "BVA Reporting Accounts"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Enable Bank Rec. Approvals"; Boolean)
        {

        }
        field(50105; "Enable Project Notifications"; Boolean)
        {

        }
        field(50106; "No Of Notifications"; Integer)
        {

        }
        field(50107; "Notification Receipients"; Text[250])
        {

        }
        field(50108; "Notifcn Threshold Period"; Integer)
        {
            Caption = 'Notification Threshold Period(Days)';
        }
        field(50109; "Enable G/L Account Approvals"; Boolean)
        {
            Caption = 'Enable G/L Account Approvals';
        }
        field(50110; "Enable Gen. Jnl. Budget checks"; Boolean)
        {
            Caption = 'Enable General Journal Budget Checks';
        }
        field(50111; "Journal Templ. Name Mandatory"; Boolean)
        {
            Caption = 'Journal Templ. Name Mandatory';
        }
        field(50112; "Apply Jnl. Template Name"; Code[10])
        {
            Caption = 'Apply Jnl. Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(50113; "Apply Jnl. Batch Name"; Code[10])
        {
            Caption = 'Apply Jnl. Batch Name';
            TableRelation = if ("Apply Jnl. Template Name" = filter(<> '')) "Gen. Journal Batch".Name where("Journal Template Name" = field("Apply Jnl. Template Name"));

            trigger OnValidate()
            begin
                TestField("Apply Jnl. Template Name");
            end;
        }

    }

    var
        myInt: Integer;
}