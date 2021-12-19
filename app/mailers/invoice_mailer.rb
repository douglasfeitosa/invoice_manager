class InvoiceMailer < ApplicationMailer
  def invoice(invoice, email)
    @invoice = invoice

    mail(to: email, subject: 'New Invoice')
  end
end
