table 50015 "Gen. Requisition Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Primary; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Work Plan Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(3; "Work Plan Archive Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(4; "Work Plan Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 1 Code" <> '') then begin
                    if ("Work Plan Dimension 1 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 1 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end
            end;
        }
        field(5; "Work Plan Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 2 Code" <> '') then begin
                    if ("Work Plan Dimension 2 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 2 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end
            end;

        }
        field(6; "Work Plan Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 3 Code" <> '') then begin
                    if ("Work Plan Dimension 3 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 3 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end
            end;

        }
        field(7; "Work Plan Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 4 Code" <> '') then begin
                    if ("Work Plan Dimension 4 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 4 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end
            end;

        }
        field(8; "Work Plan Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 5 Code" <> '') then begin
                    if ("Work Plan Dimension 5 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 5 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end

            end;

        }
        field(9; "Work Plan Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var

            begin
                GenLedSetup.Get();
                if ("Work Plan Dimension 6 Code" <> '') then begin
                    if ("Work Plan Dimension 6 Code" = GenLedSetup."Shortcut Dimension 1 Code") Or ("Work Plan Dimension 6 Code" = GenLedSetup."Shortcut Dimension 2 Code") then
                        Error(Text001, GenLedSetup."Shortcut Dimension 1 Code", GenLedSetup."Shortcut Dimension 2 Code");

                    if ("Work Plan Dimension 1 Code" = "Work Plan Dimension 2 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 3 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 4 Code") OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 5 Code")
                        OR ("Work Plan Dimension 1 Code" = "Work Plan Dimension 6 Code") then
                        Error(Text023);
                end;
            end;

        }
        field(10; "Work Plan Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
        }
        field(11; "Work Plan Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension.Code;
        }
        field(12; "Payment Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(13; "Payment Req. Archive Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(14; "Purchase Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(15; "Purchase Req. Archive Nos."; Code[20])
        {
            Caption = 'Store/Purch Archive Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(16; "Auto Archive Purch. Req"; Boolean)
        {
            Caption = 'Auto Archive Requisition';
            DataClassification = ToBeClassified;
        }
        field(17; "Auto Archive Pay. Req"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Requisition Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(19; "Req Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Requisition Journal Template"));
        }
        field(20; "Send Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Send Vend Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Store Requisition Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(23; "Archive Store Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Store Req Item Jnl Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item journal template';
            TableRelation = "Item Journal Template";
        }
        field(25; "Store Req Item Jnl Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Journal Batch';
            trigger OnLookup()
            var
                frmBatchList: Page "Item Journal Batches";
                lvItemJnlBatch: Record "Item Journal Batch";
            begin
                CLEAR(frmBatchList);
                lvItemJnlBatch.SETRANGE(lvItemJnlBatch."Journal Template Name", "Store Req Item Jnl Template");
                lvItemJnlBatch.SETRANGE(lvItemJnlBatch."Template Type", lvItemJnlBatch."Template Type"::Item);
                frmBatchList.SETRECORD(lvItemJnlBatch);
                frmBatchList.SETTABLEVIEW(lvItemJnlBatch);
                frmBatchList.LOOKUPMODE(TRUE);
                IF frmBatchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    frmBatchList.GETRECORD(lvItemJnlBatch);
                    "Store Req Item Jnl Batch" := lvItemJnlBatch.Name;
                END;
                CLEAR(frmBatchList);
            end;
        }
        field(26; "Validity Date Formula"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Auto Inventory Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Payment Voucher Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(29; "Bank Transfer Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(30; "Accountability Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(31; "Procurement Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Budget Reallocation No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(36; "Budget Realloc. Archive No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(40; "Travel Request Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(42; "Request Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(43; "Auto Send App Req For Purc Req"; Boolean)
        {
            Caption = 'Auto Send Approval Request For Purchase Requisition';
        }
        field(44; "Auto Send App Req For Pay Req"; Boolean)
        {
            Caption = 'Auto Send Approval Request For Payment Requisition';

        }
        field(45; "Enable stores Req Approvals"; Boolean)
        {
            Caption = 'Enable Stores Requisition Approvals';
        }
        field(46; "Purchase Req Due Date formula"; DateFormula)
        {
            Caption = 'Purchase Requesition Due Date Formula';
        }
        field(47; "Proc. Team Email For Requests"; Text[80])
        {
            Caption = 'Procurement Team Email For Approved Requests';
        }

        field(48; "Auto Transfer Approved Pay Req"; Boolean)
        {
            Caption = 'Transfer Approved Payment Requisition To Journal';
        }
        field(50000; "System Id"; Guid) { }



    }

    keys
    {
        key(Key1; Primary)
        {
            Clustered = true;
        }
    }

    var
        Text023: Label '%1\You cannot use the same dimension twice in the same setup.';
        Text001: Label 'The selected dimension is already used as Global Dimension, you can select another dimension other than %1 and %2';
        GenLedSetup: Record "General Ledger Setup";


    trigger OnInsert()
    begin
        GenLedSetup.Get();
        Rec."System Id" := System.CreateGuid();

        "Work Plan Dimension 1 Code" := GenLedSetup."Shortcut Dimension 3 Code";
        "Work Plan Dimension 2 Code" := GenLedSetup."Shortcut Dimension 4 Code";
        "Work Plan Dimension 3 Code" := GenLedSetup."Shortcut Dimension 5 Code";
        "Work Plan Dimension 4 Code" := GenLedSetup."Shortcut Dimension 6 Code";
        "Work Plan Dimension 5 Code" := GenLedSetup."Shortcut Dimension 7 Code";
        "Work Plan Dimension 6 Code" := GenLedSetup."Shortcut Dimension 8 Code";
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure getDefaultCostCenter(): Code[20]
    var
        lvEmployees: Record Employee;
    begin
        lvEmployees.SetRange("User ID", UserId);
        if lvEmployees.FindFirst() then
            exit(lvEmployees."Global Dimension 1 Code")
        else
            exit('');
    end;

    procedure CheckBudget(WorkPlan: Code[20]; WorkPlanEntry: Integer; BudgetCode: Code[20]; LineAmount: Decimal; ExistingLineAmt: Decimal)
    var
        Text01: Label 'Insufficient funds for this transaction:\\Check budget allocation for \\Budget Item %1 for all dimensions\\Current Transac =%2\\Budget Alloc =%3\\Actual & Commitments = %4';
        Text02: Label 'There is no budget that was allocated for this line';
        WorkPlanLine: Record "WorkPlan Line";
        BudgetControlSetup: Record "Budget Control Setup";
        lvTotalDeductions: Decimal;
        lvTotalEntitlement: Decimal;
        lvAvailableBudget: Decimal;
    begin
        BudgetControlSetup.Get();
        if BudgetControlSetup."Activate Budget Control" then begin
            WorkPlanLine.SetRange("WorkPlan No", WorkPlan);
            WorkPlanLine.SetRange("Entry No", WorkPlanEntry);
            if WorkPlanLine.FindFirst() then begin
                WorkPlanLine.CalcFields(Actuals, "Actual Invoices", Encumbrances, "Credit Memos", "Payment Req. Pre-Encumbrances", "Unconfirmed Encumbrances", Advances);

                //Sums to Add ==========================================
                if BudgetControlSetup."Original Budget" then
                    lvTotalEntitlement += WorkPlanLine."Annual Amount";
                //======================================================

                //Sums to Subtract =====================================
                if BudgetControlSetup."Actual Expenditure" then
                    lvTotalDeductions := WorkPlanLine.Actuals + WorkPlanLine."Actual Invoices";
                if BudgetControlSetup.Encumbrances then
                    lvTotalDeductions += WorkPlanLine.Encumbrances + WorkPlanLine.Advances + WorkPlanLine."Credit Memos";
                if BudgetControlSetup."Unconfirmed Encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Unconfirmed Encumbrances";
                if BudgetControlSetup."Pre-encumbrances" then
                    lvTotalDeductions += WorkPlanLine."Payment Req. Pre-Encumbrances";

                // lvTotalDeductions += WorkPlanLine."Pre-Encumbrances" + WorkPlanLine."Payment Req. Pre-Encumbrances";
                // if BudgetControlSetup."Unconfirmed Pre-encumbrances" then
                //     lvTotalDeductions += WorkPlanLine."Unconfirmed Pre-Encumbrances";
                //======================================================

                lvAvailableBudget := lvTotalEntitlement - lvTotalDeductions - ExistingLineAmt;
                if LineAmount > lvAvailableBudget then
                    Error(Text01, WorkPlanLine."Account No", LineAmount, lvTotalEntitlement, lvTotalDeductions);

            end
            else
                Error(Text02);
        end;

    end;


}