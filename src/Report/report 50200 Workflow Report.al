report 50200 "Workflow Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Reports/rdl/Workflow Report.rdl';
    dataset
    {
        dataitem("User Setup"; "User Setup")
        {
            RequestFilterFields = "User ID", Requestor;
            column(User_ID; "User ID")
            {

            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {

            }
            column(CompanyInfo_Logo; CompanyInfo.Picture)
            {

            }
            dataitem("Departmental User Setup"; "Departmental User Setup")
            {
                DataItemLinkReference = "User Setup";
                DataItemLink = "User ID" = field("User ID");
                DataItemTableView = sorting("User ID", "Approver ID", "Document Type", "Approval Dimension Code", "Sequence No.");
                column(Document_Type; "Document Type")
                {

                }
                column(User_ID_V2; "User ID")
                {

                }
                column(Approval_Dimension_Code; "Approval Dimension Code")
                {

                }
                column(Approver_ID; "Approver ID")
                {

                }
                column(Payment_Amount_Approval_Limit; "Payment Amount Approval Limit")
                {

                }
                column(Purchase_Amount_Approval_Limit; "Purchase Amount Approval Limit")
                {

                }
                column(Request_Amount_Approval_Limit; "Request Amount Approval Limit")
                {

                }

                dataitem("Departmental User Setup_Copy"; "Departmental User Setup")
                {
                    DataItemLinkReference = "Departmental User Setup";
                    DataItemLink = "User ID" = field("Approver ID"), "Document Type" = field("Document Type"), "Approval Dimension Code" = field("Approval Dimension Code");
                    DataItemTableView = sorting("User ID", "Approver ID", "Document Type", "Approval Dimension Code", "Sequence No.");
                    column(Document_Type_Copy; "Document Type")
                    {

                    }
                    column(User_ID_V2_Copy; "User ID")
                    {

                    }
                    column(Approval_Dimension_Code_Copy; "Approval Dimension Code")
                    {

                    }
                    column(Approver_ID_Copy; "Approver ID")
                    {

                    }
                    column(Payment_Amount_Approval_Limit_Copy; "Payment Amount Approval Limit")
                    {

                    }
                    column(Purchase_Amount_Approval_Limit_Copy; "Purchase Amount Approval Limit")
                    {

                    }
                    column(Request_Amount_Approval_Limit_Copy; "Request Amount Approval Limit")
                    {

                    }

                    dataitem("Departmental User Setup_Approver3"; "Departmental User Setup")
                    {
                        DataItemLinkReference = "Departmental User Setup_Copy";
                        DataItemLink = "User ID" = field("Approver ID"), "Document Type" = field("Document Type"), "Approval Dimension Code" = field("Approval Dimension Code");
                        DataItemTableView = sorting("User ID", "Approver ID", "Document Type", "Approval Dimension Code", "Sequence No.");
                        column(Document_Type_Approver3; "Document Type")
                        {

                        }
                        column(User_ID_V2_Approver3; "User ID")
                        {

                        }
                        column(Approval_Dimension_Code_Approver3; "Approval Dimension Code")
                        {

                        }
                        column(Approver_ID_Approver3; "Approver ID")
                        {

                        }
                        column(Payment_Amount_Approval_Limit_Approver3; "Payment Amount Approval Limit")
                        {

                        }
                        column(Purchase_Amount_Approval_Limit_Approver3; "Purchase Amount Approval Limit")
                        {

                        }
                        column(Request_Amount_Approval_Limit_Approver3; "Request Amount Approval Limit")
                        {

                        }
                        trigger OnAfterGetRecord()
                        var
                            myInt: Integer;
                        begin
                            if "Departmental User Setup_Approver3"."User ID" = "Departmental User Setup_Approver3"."Approver ID" then
                                CurrReport.Skip();
                        end;
                    }


                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        if "Departmental User Setup_Copy"."User ID" = "Departmental User Setup_Copy"."Approver ID" then
                            CurrReport.Skip();
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if "Departmental User Setup"."User ID" = "Departmental User Setup"."Approver ID" then
                        CurrReport.Skip();
                end;
            }

            trigger OnAfterGetRecord()
            var
                DepartmentSetup: Record "Departmental User Setup";
            begin
                DepartmentSetup.SetRange("User ID", "User Setup"."User ID");
                if not DepartmentSetup.FindFirst() then
                    CurrReport.Skip();
            end;

        }
    }


    var
        CompanyInfo: Record "Company Information";

    trigger OnPreReport()
    var
    begin
        CompanyInfo.GET();
        CompanyInfo.CalcFields(Picture);
    end;
}