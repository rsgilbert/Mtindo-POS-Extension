codeunit 50201 "Approval Notification"
{
    var
        Text001: Label 'D365BC: %1 Mail : %2';
        Text002: Label 'Approval';
        SenderName: Text[200];
        SenderAddress: Text[200];
        Recipient: Text[200];
        Subject: Text[200];
        FromUser: Text[100];
        Body: Text;
        gvSenderName: Text[1024];
        gvApproverName: Text[1024];
        // Email: Codeunit Email;
        // EmailMessage: Codeunit "Email Message";
        // RecipientType: Enum "Email Recipient Type";
        ApprovalSetup: Record "Req Approval Setup";
        Smtpmail: Codeunit "SMTP Mail";


    procedure GetEmailAddress(AppEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        userRec: Record User;
        userRec2: Record User;
    begin
        userRec.SetRange("User Name", AppEntry."Approver ID");
        if userRec.FindFirst() then
            gvApproverName := userRec."Full Name";



        UserSetup.GET(AppEntry."Approver ID");
        if UserSetup."E-Mail" <> '' then
            Recipient := UserSetup."E-Mail";



        userRec2.SetRange("User Name", AppEntry."Sender ID");
        if userRec2.FindFirst() then
            gvSenderName := userRec2."Full Name";

        UserSetup.GET(AppEntry."Sender ID");
        if UserSetup."E-Mail" <> '' then
            SenderAddress := UserSetup."E-Mail";

        UserSetup.GET(USERID);
        if UserSetup."E-Mail" <> '' then
            FromUser := UserSetup."E-Mail";
    end;

    procedure GetCancelRejectEmailAddress(AppEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        userRec: Record User;
        userRec2: Record User;
        lvEmployee: Record Employee;
    begin
        userRec.SetRange("User Name", AppEntry."Approver ID");
        if userRec.FindFirst() then
            gvApproverName := userRec."Full Name";

        // EKK
        // modifying the value of an Receiptient mail if req is purch, pay or allowance
        if AppEntry."Table ID" in [50108, 50251, 50104] then begin
            lvEmployee.Reset();
            lvEmployee.setRange("No.", AppEntry."Employee ID");
            if lvEmployee.FindFirst() then
                Recipient := lvEmployee."E-Mail";
        end
        else begin
            UserSetup.GET(AppEntry."Approver ID");
            if UserSetup."E-Mail" <> '' then
                Recipient := UserSetup."E-Mail";
        end;
        // EKK
        userRec2.SetRange("User Name", AppEntry."Sender ID");
        if userRec2.FindFirst() then
            gvSenderName := userRec2."Full Name";

        UserSetup.GET(AppEntry."Sender ID");
        if UserSetup."E-Mail" <> '' then
            SenderAddress := UserSetup."E-Mail";

        UserSetup.GET(USERID);
        if UserSetup."E-Mail" <> '' then
            FromUser := UserSetup."E-Mail";
    end;

    procedure SetTemplate(AppEntry: Record "Approval Entry")
    var
    begin
        ApprovalSetup.GET();
        ApprovalSetup.CALCFIELDS("Approval Template");
        SenderName := COMPANYNAME;
        CLEAR(SenderAddress);
        CLEAR(Recipient);
        GetEmailAddress(AppEntry);
    end;

    procedure SendApprovalMail(ApprovalEntry: Record "Approval Entry")
    var
        GenLedsetup: Record "General Ledger Setup";
        Recipients: List of [text];
    begin

        GenLedsetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";
        Clear(Body);
        SetTemplate(ApprovalEntry);
        GetEmailAddress(ApprovalEntry);
        Subject := STRSUBSTNO(Text001, Text002, ApprovalEntry."Document No.");
        Recipients.Add(Recipient);
        Body := '<br>';
        Body += 'Dear ' + gvApproverName + ',<br><br>';
        Body += 'You have Received an approval request from ' + gvSenderName + ' as per details below. <br>';
        Body += '<br>';
        Body += '<table border = "0">';
        Body += '<tr><td Colspan ="2"><b>Approval Details</b></td></tr>';
        Body += '<tr><td>Document Type: </td><td>' + Format(ApprovalEntry."Document Type") + '</td></tr>';
        Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
        Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
        Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
        if ApprovalEntry."Payee Name" <> '' then
            Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
        if ApprovalEntry.Amount <> 0 then begin
            Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
            Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
        end;
        Body += '</table>';
        Body += '</br></br>';
        IF ApprovalSetup."Approval Link" <> '' then
            Body += 'Please click on the link below to review and approve the request.<b>BC:</b> <b><a href ="' + ApprovalSetup."Approval Link" + '">Requests to Approve link</a>';
        IF ApprovalSetup."Approval Link Portal" <> '' then
            Body += 'Please click on the link below to review and approve the request. <strong><b>SELF SERIVCE PORTAL:</b></strong> <b><a href ="' + ApprovalSetup."Approval Link Portal" + '">Requests to Approve link</a></b>';
        Body += '';
        // IF STRLEN(Body) > 100 THEN
        //     Body := STRSUBSTNO('%1...', STRSUBSTNO('%1', Body, 1, 100), STRLEN(Body) - 2);
        Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), Recipient, Subject, Body, true);
        Smtpmail.Send();
        // EmailMessage.Create(Recipient, Subject, Body, true);
        // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    procedure RejectionMail(ApprovalEntry: Record "Approval Entry"; var MailCreated: Boolean)
    var
        AppCommentLine: Record "Approval Comment Line";
        GenLedsetup: Record "General Ledger Setup";
        Recipients: List of [Text];
        ApprovalComment: Text;
        ApprovalCommentCount: Integer;
    begin
        GenLedsetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";
        Clear(Body);
        IF MailCreated THEN BEGIN
            GetEmailAddress(ApprovalEntry);
            Clear(Recipients);
            Recipients.Add(Recipient);
            IF Recipient <> SenderAddress THEN
                // EmailMessage.AddRecipient(RecipientType::Cc, Recipient);
                Smtpmail.AddCC(Recipient);
        END ELSE BEGIN
            SetTemplate(ApprovalEntry);
            Recipients.Add(Recipient);
            Clear(ApprovalComment);
            ApprovalCommentCount := 1;
            Subject := STRSUBSTNO(Text001, 'Rejection', ApprovalEntry."Document No.");
            Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), Recipient, Subject, Body, true);

            // EmailMessage.Create(Recipients, Subject, Body, true);
            AppCommentLine.SETCURRENTKEY("Table ID", "Document Type", "Document No.");
            AppCommentLine.SETRANGE("Table ID", ApprovalEntry."Table ID");
            AppCommentLine.SETRANGE("Document Type", ApprovalEntry."Document Type");
            AppCommentLine.SETRANGE("Document No.", ApprovalEntry."Document No.");
            AppCommentLine.SetRange("New Comment", true);
            IF AppCommentLine.FIND('-') THEN
                repeat
                    if ApprovalCommentCount = 1 then
                        ApprovalComment := AppCommentLine.Comment
                    else
                        ApprovalComment := ApprovalComment + '</br>' + AppCommentLine.Comment;

                    ApprovalCommentCount += 1;
                until AppCommentLine.Next() = 0;
            Body := '<br>';
            Body += 'Dear ' + gvSenderName + ',<br><br>';
            Body += 'The approval request with the details below has been rejected by ' + gvApproverName + '.<br>';
            Body += '<br>';
            Body += '<table border = "0">';
            Body += '<tr><td Colspan ="2"><b>Approval Details</b></td></tr>';
            Body += '<tr><td>Document Type: </td><td>' + Format(ApprovalEntry."Document Type") + '</td></tr>';
            Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
            Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
            Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
            if ApprovalEntry."Payee Name" <> '' then
                Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
            if ApprovalEntry.Amount <> 0 then begin
                Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
                Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
            end;
            Body += '</table>';
            Body += '</br></br>';
            Body += 'Rejection Comment: ' + ApprovalComment;
            Body += '';
            // EmailMessage.AppendToBody(Body);
            Smtpmail.AppendBody(Body);
            MailCreated := true;
        end;
        // EmailMessage.Create(Recipient, Subject, Body, true);
        // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    END;

    procedure CancelApprovalMail(ApprovalEntry: Record "Approval Entry"; MailCreated: Boolean)
    var
        AppCommentLine: Record "Approval Comment Line";
        Recipients: List of [Text];
        SenderAddresses: List of [Text];
        GenLedsetup: Record "General Ledger Setup";

    begin
        GenLedsetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";
        IF MailCreated THEN BEGIN
            GetEmailAddress(ApprovalEntry);
            Recipients.Add(Recipient);

            IF Recipient <> SenderAddress THEN;
            // EmailMessage.AddRecipient(RecipientType::Cc, Recipient);
            // Smtpmail.AddRecipients(RecipientType::Cc, Recipient);
            Smtpmail.AddCC(Recipient);
        END ELSE BEGIN
            SetTemplate(ApprovalEntry);
            Recipients.Add(Recipient);
            clear(SenderAddresses);
            SenderAddresses.Add(SenderAddress);
            Subject := STRSUBSTNO(Text001, 'Cancellation', ApprovalEntry."Document No.");
            Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), Recipient, Subject, Body, true);

            // EmailMessage.Create(Recipients, Subject, Body, true);
            IF AppCommentLine.FIND('+') THEN;
            Body := '<br>';
            Body += 'Dear ' + gvApproverName + ',<br><br>';
            Body += 'The approval request with the details below has been canceled by ' + gvSenderName + '.<br>';
            Body += '<br>';
            Body += '<table border = "0">';
            Body += '<tr><td Colspan ="2"><b>Approval Details</b></td></tr>';
            Body += '<tr><td>Document Type: </td><td>' + Format(ApprovalEntry."Document Type") + '</td></tr>';
            Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
            Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
            Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
            if ApprovalEntry."Payee Name" <> '' then
                Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
            if ApprovalEntry.Amount <> 0 then begin
                Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
                Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
            end;
            Body += '</table>';
            Body += '';
            Smtpmail.AppendBody(Body);

            // EmailMessage.AppendToBody(Body);
            MailCreated := true;
        end;
    END;

    procedure RequestApprovedMail(ApprovalEntry: Record "Approval Entry")
    var
        GenLedsetup: Record "General Ledger Setup";
        HRSetup: Record "Human Resources Setup";
    begin
        GenLedsetup.Get();
        HRSetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";
        Clear(Body);
        SetTemplate(ApprovalEntry);
        GetEmailAddress(ApprovalEntry);
        // if ApprovalEntry."Document Type" = ApprovalEntry."Document Type"::"Leave Request" then
        //     if HRSetup."HR Administrator Email" <> '' then
        //         EmailMessage.AddRecipient(RecipientType::Cc, HRSetup."HRM Administrator's E-mail");
        Subject := STRSUBSTNO('D365 Request Approved : %1', ApprovalEntry."Document No.");
        Body := '</br>';
        Body += ' Dear ' + gvSenderName + ',</br></br>';
        Body += 'The request as per details below has been approved.';
        Body += '</br>';
        Body += '<table border = "0">';
        Body += '<tr><td Colspan ="2"><b>Approval Details</b></td></tr>';
        Body += '<tr><td>Document Type: </td><td>' + Format(ApprovalEntry."Document Type") + '</td></tr>';
        Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
        Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
        Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
        if ApprovalEntry."Payee Name" <> '' then
            Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
        if ApprovalEntry.Amount <> 0 then begin
            Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
            Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
        end;
        Body += '</table>';
        Body += '</br>';
        if SenderAddress <> '' then begin
            Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), SenderAddress, Subject, Body, true);
            Smtpmail.Send();
            // EmailMessage.Create(SenderAddress, Subject, Body, true);
            // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;

    procedure DelegationMail(ApprovalEntry: Record "Approval Entry"; DelegatedBy: Text)
    var
        MailSent: Boolean;
        Recipients: List of [Text];
        EXTRecipients: List of [Text];
        SenderAddresses: List of [Text];
        GenLedsetup: Record "General Ledger Setup";
    begin
        GenLedsetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";
        Clear(Body);
        SetTemplate(ApprovalEntry);
        GetEmailAddress(ApprovalEntry);
        Subject := STRSUBSTNO(Text001, Text002, ApprovalEntry."Document No.");
        Body := '</br>';
        Body += ' Dear ' + gvApproverName + ',</br></br>';
        Body += 'You have been delegated to approve a request from ' + gvSenderName + '  by ' + DelegatedBy + ' as per details below.';
        Body += '</br>';
        Body += '<table border = "0">';
        Body += '<tr><td Colspan ="2"><b>Approval Details</b></td></tr>';
        Body += '<tr><td>Document Type: </td><td>' + Format(ApprovalEntry."Document Type") + '</td></tr>';
        Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
        Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
        Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
        if ApprovalEntry."Payee Name" <> '' then
            Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
        if ApprovalEntry.Amount <> 0 then begin
            Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
            Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
        end;
        Body += '</table>';
        Body += '</br>';
        Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), Recipient, Subject, Body, true);

        // EmailMessage.Create(Recipient, Subject, Body, true);
        // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    // procedure SendFinalApprovalMail(ApprovalEntry: Record "Approval Entry"; var FinanceRecipient: Text[80])
    // var
    //     MailSent: Boolean;
    //     Recipients: List of [Text];
    //     EXTRecipients: List of [Text];
    //     SenderAddresses: List of [Text];
    //     GenLedsetup: Record "General Ledger Setup";
    // begin
    //     Clear(Recipients);
    //     Clear(EXTRecipients);
    //     GenLedsetup.Get();
    //     if ApprovalEntry."Currency Code" = '' then
    //         ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";

    //     Recipients.Add(FinanceRecipient);
    //     Subject := 'Approved Payment Requisition';
    //     clear(SenderAddresses);
    //     SenderAddresses.Add(SenderAddress);
    //     SMTP.CreateMessage(FromUser, SenderAddress, FinanceRecipient, Subject, Body, true);
    //     Body := '</br>';
    //     Body += ' Dear Sir/Madam,</br></br>';
    //     Body += FORMAT(ApprovalEntry."Document Type") + 'Approval request No.: ' + ApprovalEntry."Document No." + ' has been ' + FORMAT(ApprovalEntry.Status) + '</br>';
    //     Body += '</br>';
    //     Body += '<table border = "0">';
    //     Body += '<tr><td Colspan ="2"><b><u>Details</u></b></td></tr>';
    //     if ApprovalEntry."Payee Name" <> '' then
    //         Body += '<tr><td>Payee Name: </td><td>' + ApprovalEntry."Payee Name" + '</td></tr>';
    //     Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Description + '</td></tr>';
    //     Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
    //     Body += '<tr><td>Amount: </td><td>' + FORMAT(ApprovalEntry.Amount) + '</td></tr>';
    //     Body += '</table>';
    //     Body += '</br>';
    //     SMTP.AppendBody(Body);
    //     MailCreated := TRUE;
    //     SMTP.Send();
    // END;


    procedure SendMail(var SendMail: Boolean)
    begin
        // Email.Send(EmailMessage);
        Smtpmail.Send();
    end;

    procedure SendProcurementTeamMail(ApprovalEntry: Record "Approval Entry")
    var
        lvGenReqSetup: Record "Gen. Requisition Setup";
        GenLedsetup: Record "General Ledger Setup";

        Recipients: List of [Text];
    begin
        GenLedsetup.Get();
        if ApprovalEntry."Currency Code" = '' then
            ApprovalEntry."Currency Code" := GenLedsetup."LCY Code";

        Clear(Body);

        // Get procurement team email from setup
        lvGenReqSetup.Get();
        if lvGenReqSetup."Proc. Team Email For Requests" = '' then
            Error('Procurement Team Email is not set up in Procurement Setup.');

        Subject := StrSubstNo('Approved Purchase Requisition: %1', ApprovalEntry."Document No.");
        Recipients.Add(lvGenReqSetup."Proc. Team Email For Requests");

        Body := '<br>';
        Body += 'Dear Procurement Team,<br><br>';
        Body += 'A Purchase Requisition has been approved and is ready for processing. Details are as follows:<br>';
        Body += '<br>';
        Body += '<table border = "0">';
        Body += '<tr><td Colspan ="2"><b>Purchase Requisition Details</b></td></tr>';
        Body += '<tr><td>Document No: </td><td>' + ApprovalEntry."Document No." + '</td></tr>';
        Body += '<tr><td>' + ApprovalEntry.FieldCaption("Global Dimension 1 Code") + ': </td><td>' + ApprovalEntry."Global Dimension 1 Code" + '</td></tr>';
        Body += '<tr><td>Description: </td><td>' + ApprovalEntry.Purpose + '</td></tr>';
        if ApprovalEntry.Amount <> 0 then begin
            Body += '<tr><td>Currency Code : </td><td>' + ApprovalEntry."Currency Code" + '</td></tr>';
            Body += '<tr><td>Amount: </td><td>' + Format(ApprovalEntry.Amount) + '</td></tr>';
        end;
        Body += '</table>';
        Body += '<br><br>';
        Body += 'Please proceed with the necessary procurement actions.';
        Body += '<br><br>';
        Body += 'Best regards,<br>';
        Body += CompanyName;
        if (Body <> '') or (Recipients.Count > 0) then begin
            Smtpmail.CreateMessage(GetSenderName(), GetSenderAddress(), lvGenReqSetup."Proc. Team Email For Requests", Subject, Body, true);
            Smtpmail.send();
            // EmailMessage.Create(Recipients, Subject, Body, true);
            // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;

    local procedure GetSenderAddress(): Text[250]
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        UserSetup: Record "User Setup";
        CompanyInformation: Record "Company Information";
    begin
        // SMTP setup should be the primary sender source to match server authentication.
        if SMTPMailSetup.Get() then
            if SMTPMailSetup."User ID" <> '' then
                exit(SMTPMailSetup."User ID");

        if SenderAddress <> '' then
            exit(SenderAddress);

        if FromUser <> '' then
            exit(FromUser);

        if UserSetup.Get(USERID) then
            if UserSetup."E-Mail" <> '' then
                exit(UserSetup."E-Mail");

        if CompanyInformation.Get() then
            if CompanyInformation."E-Mail" <> '' then
                exit(CompanyInformation."E-Mail");

        Error('No sender email is configured. Set SMTP Mail Setup User ID or User Setup E-Mail.');
    end;

    local procedure GetSenderName(): Text[200]
    begin
        if SenderName <> '' then
            exit(SenderName);

        exit(CompanyName);
    end;

}
