report 50014 "Payables Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/rdl/Payables Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "Buy-from Vendor No.", "Posting Date";
            column(CompanyInfo_name; CompanyInfo.Name)
            {

            }
            column(CompanyInfo_address; CompanyInfo.Address)
            {

            }
            column(CompanyInfo_logo; CompanyInfo.Picture)
            {

            }
            column(No_; "No.")
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLinkReference = "Purch. Inv. Header";
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(No_Line; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {

                }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                column(AmtLCY; AmtLCY)
                {

                }
                column(SiteCode; SiteCode)
                {

                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(SiteCode);
                    Clear(AmtLCY);
                    DimSetEntry.SetRange("Dimension Code", GenLedSetup."Shortcut Dimension 3 Code");
                    DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                    if DimSetEntry.FindFirst() then
                        SiteCode := DimSetEntry."Dimension Value Code";

                    AmtLCY := "Unit Cost (LCY)" * Quantity;
                    //"Line Amount"

                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        SiteCode: Code[20];
        DimSetEntry: Record "Dimension Set Entry";
        GenLedSetup: Record "General Ledger Setup";
        AmtLCY: Decimal;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        GenLedSetup.Get();
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}