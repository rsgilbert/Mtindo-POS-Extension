report 50201 "Approval Entries"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Reports/rdl/ERP Approval Entries.rdl';

    dataset
    {
        dataitem("Approval Entry"; "Approval Entry")
        {
            RequestFilterFields = "Document Type", "Document No.", "Sender ID", "Approver ID";
            column(Document_Type; "Document Type") { }
            column(Document_No_; "Document No.") { }
            column(Purpose; Purpose) { }
            column(Sequence_No_; "Sequence No.") { }
            column(Status; Status) { }
            column(Sender_ID; "Sender ID") { }
            column(Employee_ID; "Employee ID") { }
            column(Approver_ID; "Approver ID") { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(Date_Time_Sent_for_Approval; "Date-Time Sent for Approval") { }
            column(Last_Date_Time_Modified; "Last Date-Time Modified") { }
            column(Last_Modified_By_User_ID; "Last Modified By User ID") { }
        }
    }

}