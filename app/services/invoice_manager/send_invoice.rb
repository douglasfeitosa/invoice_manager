module InvoiceManager
  class SendInvoice < ApplicationService
    def initialize(invoice)
      @invoice = invoice
    end

    def call
      @invoice.splitted_emails.each do |email|
        InvoiceMailer.invoice(@invoice, email).deliver_later
      end
    end
  end
end