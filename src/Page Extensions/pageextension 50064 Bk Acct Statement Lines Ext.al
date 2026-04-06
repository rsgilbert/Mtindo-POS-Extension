pageextension 50064 "Bk Acct Statement Lines Ext" extends "Bank Account Statement List"
{
    actions
    {
        // modify(Undo)
        // {
        //     Visible = false;
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //         lvusersetup: Record "User Setup";
        //     begin
        //         lvusersetup.Reset();
        //         lvusersetup.SetRange("User ID", USERID);
        //         lvusersetup.SetRange("Undo Bank Reconciliation", true);
        //         if lvusersetup.IsEmpty() then
        //             Error('You do not have the required access to undo bank reconciliation. Please contact your system administrator.');
        //     end;
        // }
        // addafter(Print)
        // {
        //     action("Undo Bank Reconciliation")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Undo Bank Reconciliation';
        //         Ellipsis = true;
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         PromotedIsBig = true;
        //         trigger OnAction()
        //         var
        //             lvusersetup: Record "User Setup";
        //             UndoDialogPage: Page "Reason for Undo Dialog";
        //           //  ReasonTempRec: Record "Reason for Undo Temp.";
        //             BankReconUndoLog: Record "Bank Recon. Undo Log";
        //           //  UndoBankStatementYesNo: Codeunit "Undo Bank Statement (Yes/No)";
        //             Comment: Text[250];
        //         begin
        //             //Determine if the user has rights to undo bank reconciliation
        //             lvusersetup.Reset();
        //             lvusersetup.SetRange("User ID", USERID);
        //             lvusersetup.SetRange("Undo Bank Reconciliation", true);
        //             if lvusersetup.IsEmpty() then
        //                 Error('You do not have the required access to undo bank reconciliation. Please contact your system administrator.');


        //             // This sets the temporary record on the dialog page
        //             // UndoDialogPage.SetRecord(ReasonTempRec);
        //             Clear(Comment);
        //             if UndoDialogPage.RunModal() = ACTION::OK then begin

        //                 // This retrieves the updated record from the dialog page
        //                 // UndoDialogPage.GetRecord(ReasonTempRec);
        //                 Comment := UndoDialogPage.GetCommentText();
        //                 if Comment <> '' then begin
        //                     // Log the data in your custom table
        //                     BankReconUndoLog."Bank Reconciliation No." := Rec."Statement No.";
        //                     BankReconUndoLog."Bank Account" := Rec."Bank Account No.";
        //                     BankReconUndoLog."Statement Date" := Rec."Statement Date";
        //                     BankReconUndoLog."Reason for Undo" := Comment;
        //                     BankReconUndoLog."Statement Ending Balance" := Rec."Statement Ending Balance";
        //                     BankReconUndoLog."Last Statement Balance" := Rec."Balance Last Statement";
        //                     BankReconUndoLog."User ID" := UserId();
        //                     BankReconUndoLog."Date/Time" := CurrentDateTime();
        //                     BankReconUndoLog."Reason for Undo" := Comment;
        //                     BankReconUndoLog.Insert();
        //                     // Call the standard undo function
        //                 //    UndoBankStatementYesNo.Run(Rec);

        //                     Message('Bank reconciliation has been undone and the reason has been logged.');
        //                 end else begin
        //                     Message('Action cancelled. A reason must be provided to proceed.');
        //                 end;
        //             end;
        //         end;
        //     }
        // }
    }

}

