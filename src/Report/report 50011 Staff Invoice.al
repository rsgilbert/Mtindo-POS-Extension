report 50011 "Staff Invoice"
{
    RDLCLayout = './src/Report/rdl/Staff Invoice.rdl';
    Caption = 'Imprest Accountability - Invoice';
    UsageCategory = ReportsAndAnalysis;

    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("Accountability_Header"; "Accountability Header")
        {
            column(HDR_No_; "No.")
            {
            }
            column(HDR_Document_Date; "Document Date")
            {

            }
            column(HDR_Activity_Date; "Activity Date")
            {

            }
            column(HDR_Bank_Account_No; "Bank Account No")
            {

            }
            column(HDR_Activity_Completion_Date; "Activity Completion Date")
            {

            }
            column(HDR_Payee_Name; "Payee Name")
            {

            }
            column(HDR_Payee_No; "Payee No")
            {

            }
            column(HDR_Purpose; Purpose)
            {

            }
            column(HDR_Requestor_Name; "Requestor Name")
            {

            }
            column(HDR_Total_Amount; "Total Amount")
            {

            }
            column(HDR_Currency_Factor; "Currency Factor")
            {

            }
            column(HDR_Currency_Code; "Currency Code")
            {

            }
            column(HDR_Posting_Date; "Posting Date")
            {

            }
            column(HDR_Bank_Account_Name; "Bank Account Name")
            {

            }
            dataitem("Accountability_Line"; "Accountability Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No" = FIELD("No.");
                DataItemTableView = where("Account Type" = filter("Bank Account"));
                column(Line_Document_No; "Document No")
                {
                }
                column(WorkPlan_Entry_No; "WorkPlan Entry No")
                {
                }
                column(WorkPlan_No; "WorkPlan No")
                {
                }
                column(Account_Name; "Account Name")
                {
                }
                column(Description; Description)
                {
                }
                column(Amount_To_Pay__LCY_; "Amount To Pay (LCY)")
                {
                }
                column(Amount; Amount)
                {
                }
                column(Amount__LCY_; "Amount (LCY)")
                {
                }
                column(Amount_To_Pay; "Amount To Pay")
                {
                }
                column(Amount_Paid; "Amount Paid")
                {
                }
                column(CompanyName; CompanyInformation.Name)
                {
                }
                column(CompanyLogo; CompanyInformation.Picture)
                {
                }
                column(CompanyWaterMark; CompanyInformation.Watermark)
                {
                }
                column(CompanyPhoneNo; CompanyInformation."Phone No.")
                {
                }
                column(CompanyAddress; CompanyInformation.Address)
                {
                }
                column(CompanyAddress2; CompanyInformation."Address 2")
                {
                }
                column(CompanyFaxNo; CompanyInformation."Fax No.")
                {
                }
                column(CompanyEmail; CompanyInformation."E-Mail")
                {
                }
                column(CompanyWebsite; CompanyInformation."Home Page")
                {
                }
            }

        }

    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
        CompanyInformation.CalcFields(Watermark);
    end;

    var
        CompanyInformation: Record "Company Information";
}