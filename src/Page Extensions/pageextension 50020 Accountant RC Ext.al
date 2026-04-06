pageextension 50020 "Accountant RC Ext." extends "Accountant Role Center"
{
    layout
    {
        // Add changes to page layout here
        addfirst(RoleCenter)
        {
            part("Pending Approval Cue"; "Pending Approval Cue")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(sections)
        {
            group(Budgeting)
            {
                action(Workplans)
                {
                    ApplicationArea = All;
                    RunObject = Page WorkPlans;
                }
                action("Pending Workplans")
                {
                    ApplicationArea = All;
                    RunObject = Page "Pending WorkPlans";
                }
                action("Approved Workplans")
                {
                    ApplicationArea = All;
                    RunObject = page "Approved WorkPlans";
                }
                action("G/L Budgets")
                {
                    ApplicationArea = All;
                    RunObject = page "G/L Budget Names";
                }
                action("Budget Reallocations")
                {
                    ApplicationArea = All;
                    RunObject = page "Budget Reallocations";
                }
                action("Archived Budget Reallocations")
                {
                    ApplicationArea = All;
                    RunObject = page "Budget Reallocation Archives";
                }
            }
            group(Requisitions)
            {
                // action("Purchase Requisitions")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Purchase Requisitions";
                // }
                // action("Pending Purchase Requisitions")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Pending Purchase Requisitions";
                // }
                // action("Approved Purchase Requisitions")
                // {
                //     ApplicationArea = All;
                //     RunObject = page "Approved Purchase Requisitions";
                // }
                action("Payment Requisitions")
                {
                    ApplicationArea = All;
                    RunObject = Page "Payment Requisitions";
                }
                action("Pending Approval")
                {
                    ApplicationArea = All;
                    RunObject = Page "Pending Approval";
                }
                action("Pending Payment Requisitions")
                {
                    ApplicationArea = All;
                    RunObject = Page "Pending Payment Requisitions";
                }
                action("Approved Payment Requisitions")
                {
                    ApplicationArea = All;
                    RunObject = page "Approved Payment Requisitions";
                }
                action("Finance Payment Requisitions")
                {
                    ApplicationArea = All;
                    RunObject = page "Finance Payment Requisitions";
                }
                // action("Travel Requests")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Travel Requests";
                // }
                // action("Bank Transfers")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Bank Transfer List";
                // }
                // action("Petty Cash")
                // {
                //     ApplicationArea = All;
                //     RunObject = page "Petty Cash List";
                // }
                // action("Stores Requisitions")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Stores Requisition List";
                // }
            }
            group(Accountabilities)
            {
                action("Imprest Pending Accountability")
                {
                    ApplicationArea = All;
                    RunObject = Page "Imprest Pending Accountability";
                }
                action("Accountability List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Accountability List";
                    RunPageView = where(Posted = const(false));
                }
                action("Posted Accountability List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Accountability List";
                    RunPageView = where(Posted = const(true));
                }
                action("Archived Accountability List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Archived Accountabilities";
                }
            }
            group("Archived Requisitions")
            {
                // action("Archived Purchase Requisition")
                // {
                //     ApplicationArea = All;
                //     RunObject = page "Archived Purchase Requisitions";
                // }
                action("Archived Payment Requisitions")
                {
                    ApplicationArea = All;
                    RunObject = Page "Archived Payment Requisitions";
                }
                // action("Archived Bank Transfer")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Archived Bank Transfers";
                // }
                // action("Archived Travel Requests")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Archived Travel Request";
                // }
                // action("Archived Petty Cash")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Archived Petty Cash List";
                // }
                // action("Archived Stores Requisitions")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Archived Store Requisitions";
                // }
            }
        }
    }

    var
        myInt: Integer;
}