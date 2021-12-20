class InvoiceMailer < ApplicationMailer
  def invoice(invoice, email)
    @invoice = invoice

    attachments['invoice.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: 'invoice.pdf', layout: 'application.pdf.erb', template: 'internal/invoices/show.pdf.erb')
    )

    mail(to: email, subject: 'New Invoice')
  end
end
