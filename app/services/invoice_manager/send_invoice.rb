module InvoiceManager
  class SendInvoice < ApplicationService
    def initialize(invoice, emails)
      @invoice = invoice
      @emails = emails
    end

    def call
      @emails.each do |email|
        InvoiceMailer.invoice(@invoice, email).deliver_later
      end
    end
  end
end
