codeunit 50203 "Custom Workflow Mgt."
{
    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure CheckCancelWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: Code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowforApproval(var RecRef: RecordRef)
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowforApproval(var RecRef: RecordRef)
    begin

    end;

    // Add events to the library
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    // local procedure OnAddWorkflowEventPredecessorsToLibrary()
    // var
    //     RecRef: RecordRef;
    //     WorkflowEventHandling: Codeunit "Workflow Event Handling";
    // begin
    //     RecRef.Open(Database::"Human Resource Header");
    //     WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Human Resource Header", GetWorkflowEventDesc(WorkflowSendApprovalEventDescTxt, RecRef), 0, false);
    //     WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Human Resource Header",
    //       GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);

    // end;

    // Add events to the library
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    // local procedure OnAddWorkflowEventPredecessorsToLibrary1()
    // var
    //     RecRef: RecordRef;
    //     WorkflowEventHandling: Codeunit "Workflow Event Handling";
    // begin
    //     RecRef.Open(Database::"Performance Header");
    //     WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Performance Header", GetWorkflowEventDesc(WorkflowSendApprovalEventDescTxt, RecRef), 0, false);
    //     WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Performance Header",
    //       GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    // end;

    // Subscribe
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgt.", 'OnSendWorkflowForApproval', '', true, true)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgt.", 'OnCancelWorkflowForApproval', '', true, true)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    // Handle the document
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    // local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    // var
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     case RecRef.Number of
    //         Database::"Human Resource Header":
    //             begin
    //                 RecRef.SetTable(HumanResourceHeader);
    //                 HumanResourceHeader.Validate(Status, HumanResourceHeader.Status::Open);
    //                 HumanResourceHeader.Modify;
    //                 Handled := true;
    //             end;

    //         Database::"Performance Header":
    //             begin
    //                 RecRef.SetTable(PerformanceHeader);
    //                 PerformanceHeader.Validate(Status, PerformanceHeader.Status::Open);
    //                 PerformanceHeader.Modify;
    //                 Handled := true;
    //             end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]

    // local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    // var
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     case RecRef.Number of
    //         Database::"Human Resource Header":
    //             begin
    //                 RecRef.SetTable(HumanResourceHeader);
    //                 HumanResourceHeader.Validate(Status, HumanResourceHeader.Status::"Pending Approval");
    //                 HumanResourceHeader.Modify;
    //                 variant := HumanResourceHeader;
    //                 IsHandled := true;
    //             end;

    //         Database::"Performance Header":
    //             begin
    //                 RecRef.SetTable(PerformanceHeader);
    //                 PerformanceHeader.Validate(Status, PerformanceHeader.Status::"Pending Approval");
    //                 PerformanceHeader.Modify;
    //                 variant := PerformanceHeader;
    //                 IsHandled := true;
    //             end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    // local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    // var
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     RecRef.SetTable(HumanResourceHeader);
    //     ApprovalEntryArgument."Document No." := HumanResourceHeader."No.";
    //     ApprovalEntryArgument."Document Type" := HumanResourceHeader."Document Type";

    //     // RecRef.SetTable(PerformanceHeader);
    //     // ApprovalEntryArgument."Document No." := PerformanceHeader."No.";
    //     // ApprovalEntryArgument."Document Type" := PerformanceHeader."Document Type";

    //     // lin commented out temporarily
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    // local procedure OnPopulateApprovalEntryArgument1(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    // var
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     // RecRef.SetTable(PerformanceHeader);
    //     // ApprovalEntryArgument."Document No." := PerformanceHeader."No.";
    //     // ApprovalEntryArgument."Document Type" := PerformanceHeader."Document Type";

    //     // lin commented out temporarily
    //     case RecRef.Number of
    //         Database::"Human Resource Header":
    //             begin
    //                 RecRef.SetTable(HumanResourceHeader);
    //                 ApprovalEntryArgument."Document No." := HumanResourceHeader."No.";
    //                 ApprovalEntryArgument."Document Type" := HumanResourceHeader."Document Type";
    //             end;
    //         Database::"Performance Header":
    //             begin
    //                 RecRef.SetTable(PerformanceHeader);
    //                 ApprovalEntryArgument."Document No." := PerformanceHeader."No.";
    //                 ApprovalEntryArgument."Document Type" := PerformanceHeader."Document Type";
    //             end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    // local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    // var
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     case RecRef.Number of
    //         Database::"Human Resource Header":
    //             begin
    //                 RecRef.SetTable(HumanResourceHeader);
    //                 HumanResourceHeader.Validate(Status, HumanResourceHeader.Status::Approved);
    //                 HumanResourceHeader.Modify;
    //                 Handled := true;
    //             end;

    //         Database::"Performance Header":
    //             begin
    //                 RecRef.SetTable(PerformanceHeader);
    //                 PerformanceHeader.Validate(Status, PerformanceHeader.Status::Approved);
    //                 PerformanceHeader.Modify;
    //                 Handled := true;
    //             end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    // local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     RecRef: RecordRef;
    //     HumanResourceHeader: Record "Human Resource Header";
    //     PerformanceHeader: Record "Performance Header";
    // begin
    //     case ApprovalEntry."Table ID" of
    //         Database::"Human Resource Header":
    //             begin
    //                 if HumanResourceHeader.Get(ApprovalEntry."Document No.") then begin
    //                     HumanResourceHeader.Validate(Status, HumanResourceHeader.Status::Rejected);
    //                     HumanResourceHeader.Modify;
    //                 end;
    //             end;

    //         Database::"Performance Header":
    //             begin
    //                 if PerformanceHeader.Get(ApprovalEntry."Document No.") then begin
    //                     PerformanceHeader.Validate(Status, PerformanceHeader.Status::Open);
    //                     PerformanceHeader.Modify;
    //                 end;
    //             end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Human Resource Header", 'OnSendLeaveApprovalRequest', '', false, false)]
    // local procedure OnSendLeaveApprovalRequest(var RecRef: RecordRef)
    // begin
    //     if CheckApprovalsWorkflowEnabled(RecRef) then
    //         OnSendWorKflowforApproval(RecRef);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Human Resource Header", 'onCancelLeaveApprovalRequest', '', false, false)]
    // local procedure onCancelLeaveApprovalRequest(var RecRef: RecordRef)
    // begin
    //     if CheckCancelWorkflowEnabled(RecRef) then
    //         OnCancelWorKflowforApproval(RecRef);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Performance Header", 'onSendIPAApprovalRequest', '', false, false)]
    // local procedure onSendIPAApprovalRequest(var RecRef: RecordRef)
    // begin
    //     if CheckApprovalsWorkflowEnabled(RecRef) then
    //         OnSendWorKflowforApproval(RecRef);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Performance Header", 'onCancelIPAApprovalRequest', '', false, false)]
    // local procedure onCancelIPAApprovalRequest(var RecRef: RecordRef)
    // begin
    //     if CheckCancelWorkflowEnabled(RecRef) then
    //         OnCancelWorKflowforApproval(RecRef);
    // end;

    var
        WorkflowMgt: Codeunit "Workflow Management";
        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No Approval workflow for this record type is enabled.';
        WorkflowSendApprovalEventDescTxt: Label 'Approval of a %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of a %1 is canceled.';
}