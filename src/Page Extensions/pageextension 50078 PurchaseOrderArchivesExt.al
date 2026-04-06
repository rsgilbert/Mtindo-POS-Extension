pageextension 50078 PurchaseOrderArchivesExt extends "Purchase Order Archive"
{
    layout
    {

        // Add changes to page layout here
    }

    actions
    {
        addafter("Dimensions")
        {
            action("Attachments")
            {
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    DocumentAttachment: Record "Document Attachment";
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    PurchInvHeader.Reset();
                    DocumentAttachment.Reset();
                    DocumentAttachment.SetRange("Table ID", Database::"Purch. Inv. Header");
                    PurchInvHeader.SetRange("Order No.", Rec."No.");
                    if PurchInvHeader.FindFirst() then begin
                        DocumentAttachment.SetRange("No.", PurchInvHeader."No.");
                        DocumentAttachmentDetails.SetTableView(DocumentAttachment);
                        DocumentAttachmentDetails.Editable(false);
                        DocumentAttachmentDetails.RunModal();
                    end else begin
                        Message('No attachment found for this Purchase Order Archive');
                    end;
                end;


            }
        }
        // attachments


        // Add changes to page actions here
    }

    var
        myInt: Integer;
}