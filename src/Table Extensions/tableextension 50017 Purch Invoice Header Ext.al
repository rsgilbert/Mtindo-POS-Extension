tableextension 50017 "Purch Invoice Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50200; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50201; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50205; "Created from Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50211; "LPO Reference"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50206; "Work Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WorkPlan Header"."No." where(Blocked = const(false), Status = const(Approved), "Transferred To Budget" = const(true));
            trigger OnValidate()
            var
                WorkPlanHDr: Record "WorkPlan Header";
            begin
                if WorkPlanHDr.Get("Work Plan") then
                    "Budget Name" := WorkPlanHDr."Budget Code";
            end;
        }
        field(50213; "Requestor No."; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active));
            Caption = 'Requestor No.';
        }
        field(50214; "Requestor Name"; Text[100])
        {
            Editable = false;
        }
        field(50215; "Requested By Email"; Text[80])
        {
            Caption = 'Requested By Email';
        }
    }
}