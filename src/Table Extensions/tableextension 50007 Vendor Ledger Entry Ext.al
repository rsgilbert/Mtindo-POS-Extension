tableextension 50007 "Vendor Ledger Entry Ext." extends "Vendor Ledger Entry"
{
    fields
    {

        // Add changes to table fields here
        modify("Amount to Apply")
        {
            trigger OnAfterValidate()
            var
                lvGenLedgerSetup: Record "General Ledger Setup";
                lvPostPurchLines: Record "Purch. Inv. Line";
                lvWhtSetup: Record "WHT Posting Groups";
                lvVendor: Record Vendor;
                lvGLAccount: Record "G/L Account";
                lvItem: Record Item;
                lvWHTProdPostingGroup: Code[20];
                lvTempWHT: Decimal;
                lvTotelWhtAmount: Decimal;
                lvTempWHT_VAT: Decimal;
                lvTotelWht_VATAmount: Decimal;

            begin
                "Payment Percentage" := 0;
                "WHT Amount" := 0;
                "WHT on VAT Amount" := 0;
                lvGenLedgerSetup.Get();
                if lvGenLedgerSetup."Enable WHT" then
                    if "Amount to Apply" <> 0 then begin
                        Rec.CalcFields("Original Amount", "Amount (LCY)");
                        "Payment Percentage" := Round(("Amount to Apply" / "Original Amount") * 100, 0.01, '>');

                        lvVendor.get("Vendor No.");
                        lvPostPurchLines.SetRange("Document No.", "Document No.");
                        lvPostPurchLines.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                        if lvPostPurchLines.FindSet() then
                            repeat
                                // Clear(lvWHTProdPostingGroup);
                                // if lvPostPurchLines."WHT Prod. Posting Group" <> '' then
                                //     lvWHTProdPostingGroup := lvPostPurchLines."WHT Prod. Posting Group"
                                // else
                                //     case lvPostPurchLines.Type of
                                //         lvPostPurchLines.Type::"G/L Account":
                                //             begin
                                //                 lvGLAccount.Reset();
                                //                 if lvGLAccount.Get(lvPostPurchLines."No.") then
                                //                     lvWHTProdPostingGroup := lvGLAccount."WHT Prod. Posting Group";
                                //             end;
                                //         lvPostPurchLines.Type::Item:
                                //             begin
                                //                 lvItem.Rseset();
                                //                 if lvItem.Get(lvPostPurchLines."No.") then
                                //                     lvWHTProdPostingGroup := lvItem."WHT Prod. Posting Group";
                                //             end;
                                //     end;
                                if lvWhtSetup.Get(lvVendor."WHT Posting Group", lvWHTProdPostingGroup) then begin
                                    if (ABS("Amount (LCY)") >= lvWhtSetup."WHT Minimum Invoice Amount") OR (Prepayment = true) then begin
                                        lvTempWHT := (lvPostPurchLines."VAT Base Amount" * "Payment Percentage") / 100;
                                        lvTotelWhtAmount += Round((lvTempWHT * lvWhtSetup."WHT %") / 100, 0.01, '=');
                                        if lvPostPurchLines."VAT %" > 0 then begin
                                            lvTempWHT_VAT := lvTempWHT;
                                            lvTotelWht_VATAmount += Round((lvTempWHT_VAT * lvWhtSetup."WHT On VAT %") / 100, 0.01, '=');
                                        end;
                                    end;
                                end
                                else
                                    Error('Wht posting setup for combination of %1 and %2 does not exist.', lvVendor."WHT Posting Group", lvWHTProdPostingGroup);
                            until lvPostPurchLines.Next() = 0;

                        "WHT Amount" := lvTotelWhtAmount;
                        "WHT on VAT Amount" := lvTotelWht_VATAmount;
                        if "Currency Code" = '' then begin
                            "WHT Amount (LCY)" := "WHT Amount";
                            "WHT on VAT Amount (LCY)" := "WHT on VAT Amount";
                        end
                        else begin
                            "WHT Amount (LCY)" := Round("WHT Amount" / "Original Currency Factor", 0.01, '=');
                            "WHT on VAT Amount (LCY)" := Round("WHT on VAT Amount" / "Original Currency Factor", 0.01, '=');
                        end;
                    end
                    else begin
                        "Payment Percentage" := 0;
                        "WHT Amount" := 0;
                        "WHT Amount (LCY)" := 0;
                        "WHT on VAT Amount" := 0;
                    end;
            end;

        }
        field(50100; "Reversal Description"; Text[100])
        {
            Editable = false;

        }
        field(50101; "Fiscal Document No"; Code[20])
        {

        }
        field(50102; "Fiscal Issue Date"; Date)
        {

        }
        field(50103; "Rem. Amt"; Decimal)
        {

        }
        field(50104; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
        }
        field(50105; "WHT Amount (LCY)"; Decimal)
        {
            Caption = 'WHT Amount (LCY)';
            Editable = false;
        }
        field(50106; "Payment Percentage"; Decimal)
        {
            Editable = false;
        }

        field(50107; "WHT on VAT Amount"; Decimal)
        {
            Caption = 'WHT VAT Amount';
            Editable = false;
        }
        field(50108; "WHT on VAT Amount (LCY)"; Decimal)
        {
            Caption = 'WHT VAT Amount (LCY)';
            Editable = false;
        }
        field(50109; "Purchase Requisition No"; Code[20])
        {
            Caption = 'Purchase Requisition No';
            Editable = false;
        }
        field(50110; "Work Plan No"; Code[20])
        {
            Caption = 'Work Plan No';
            Editable = false;
        }
        field(50111; "Budget Code"; Code[20])
        {
            Caption = 'Budget Code';
            Editable = false;
        }
        field(50112; "FDN"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fiscal Document No';
        }
        field(50113; "FDN Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fiscal Document No Date';
        }
        field(50114; "Vendor TIN"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}