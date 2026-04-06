tableextension 50011 "Purchase Header Ext." extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50200; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50201; "Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
            Editable = false;
        }
        field(50202; "FDN"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fiscal Document No';
            //NotBlank = true;
            trigger OnValidate()
            var
                lvPurchasesandPayable: Record "Purchases & Payables Setup";
            begin
                lvPurchasesandPayable.Get();
                //if StrLen(FDN) <> lvPurchasesandPayable."FDN Maximum Character" then
                //Error('The length of the FDN must be equal to %1. It is currently %2', lvPurchasesandPayable."FDN Maximum Character", StrLen(FDN));
            end;
        }
        field(50203; "FDN Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fiscal Document No Date';
            //NotBlank = true;
        }
        field(50204; "Vendor TIN"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."Vendor TIN" where("No." = field("Buy-from Vendor No.")));
        }
        field(50205; "Created from Requisition"; Boolean)
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
                if WorkPlanHDr.Get("Work Plan") then begin
                    "Budget Code" := WorkPlanHDr."Budget Code";
                    validate("Shortcut Dimension 2 Code", WorkPlanHDr."Shortcut Dimension 2 Code");
                end;
            end;
        }
        field(50207; "Received By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
            begin
                "Receipt Date" := Today;
                IF "Received By" = "Checked By" then
                    Error('Received by cannot be the same as checked by');
            end;
        }
        field(50208; "Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50209; "Checked By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
            begin
                "Check Date" := Today;
                IF "Received By" = "Checked By" then
                    Error('Received by cannot be the same as checked by');
            end;
        }
        field(50210; "Check Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50211; "LPO Reference"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50212; Archived; Boolean)
        {
        }
        field(50213; "Requestor No."; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active));
            Caption = 'Requestor No.';

            trigger OnValidate()
            var
                lvEmployee: Record Employee;
            begin
                if "Requestor No." <> '' then begin
                    if lvEmployee.Get("Requestor No.") then begin
                        "Requestor Name" := lvEmployee.FullName();
                        "Requested By Email" := lvEmployee."Company E-Mail";
                    end;
                end
                else
                    Clear("Requestor Name");
            end;
        }
        field(50214; "Requestor Name"; Text[100])
        {
            Editable = false;
        }
        field(50215; "Requested By Email"; Text[80])
        {
            Caption = 'Requested By Email';
        }
        field(50216; "Order Validity Period"; Text[50])
        {
            Caption = 'Order Validity Period';
        }
    }

    trigger OnAfterInsert()
    var
        PurchHeader: Record "Purchase Header";
        EmployeeRec: Record Employee;
    begin
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            //EmployeeRec.SetRange("User ID", UserId);
            if EmployeeRec.FindFirst() then
                Validate("Shortcut Dimension 1 Code", EmployeeRec."Global Dimension 1 Code");
    end;

    trigger OnBeforeDelete()
    var
        myInt: Integer;
    begin
        // TestField("Created from Requisition", false); Moved to the page
        //TestField(Status, Status::Open); //Commented to enable the team delete very old entries
    end;

    procedure CheckAttachments(RecHeader: Record "Purchase Header"): Boolean
    var
        DocumentAtt: Record "Document Attachment";
    begin
        DocumentAtt.SetRange("Table ID", Database::"Purchase Header");
        DocumentAtt.SetRange("No.", RecHeader."No.");
        IF DocumentAtt.FindFirst() then
            exit(true)
        else
            EXIT(false);
    end;

    procedure CheckPurchLines(): Boolean
    var
        PurchLine_Copy: Record "Purchase Line";
    begin
        PurchLine_Copy.Reset();
        PurchLine_Copy.SetRange("Document Type", "Document Type");
        PurchLine_Copy.SetRange("Document No.", "No.");
        IF PurchLine_Copy.FindFirst() then
            repeat
                PurchLine_Copy.TestField("Location Code");
                PurchLine_Copy.TestField("Description 2");
            until PurchLine_Copy.Next() = 0;
        exit(PurchLine_Copy.FindFirst());
    end;

    procedure UpdateLineStatus(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                if (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) and (Status = Status::Open) then
                    PurchaseLine.Status := PurchaseLine.Status::"Pending Approval"
                else
                    PurchaseLine.Status := PurchaseHeader.Status;
                PurchaseLine.Modify();
            until PurchaseLine.Next() = 0;
    end;

    procedure BudgetCheck(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseLine."No.");
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.BudgetCheckAtInvoice((PurchaseLine.Quantity * PurchaseLine."Unit Cost (LCY)"), PurchaseLine."Line No.");
            until PurchaseLine.Next() = 0;
    end;

    procedure PRBudgetCheck(var PurchHeader: Record "Purchase Header")
    var
        lvPurchLine: Record "Purchase Line";
    begin
        lvPurchLine.reset();
        lvPurchLine.SetRange("Document Type", PurchHeader."Document Type");
        lvPurchLine.SetRange("Document No.", PurchHeader."No.");
        if lvPurchLine.FindSet() then
            repeat
                lvPurchLine.BudgetCheck(lvPurchLine."Outstand. Amt. Not Invd.(LCY)", lvPurchLine."Line No.");
            until lvPurchLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseApprovalRequest(var Recref: RecordRef; senderUserID: Code[50])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewPurchaseApprovalHistory(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnViewPurchaseComments(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

}