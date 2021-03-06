module InvoiceManager
  class CreateInvoice < ApplicationService
    def initialize(user, attrs)
      @user = user
      @attrs = attrs
    end

    def call
      @invoice = build_invoice

      if @invoice.save
        send_email

        respond_with(true, PAYLOAD => @invoice, MESSAGE => 'Invoice sent to informed emails.')
      else
        respond_with(false, PAYLOAD => @invoice, ERROR => @invoice.errors)
      end
    end

    private

    def build_invoice
      @user.invoices.build(@attrs)
    end

    def send_email
      SendInvoice.call(@invoice, @invoice.splitted_emails)
    end
  end
end