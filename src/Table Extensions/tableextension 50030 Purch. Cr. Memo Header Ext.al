tableextension 50030 "Purch. Cr. Memo Header Ext." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50101; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50105; "Created from Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "LPO Reference"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Work Plan"; Code[20])
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
    }
}