module InvoiceManager
  class UpdateInvoice < ApplicationService
    def initialize(user, id, attrs)
      @user = user
      @id = id
      @attrs = attrs
    end

    def call
      fetch_invoice
      fetch_older_emails

      if @invoice.update(@attrs)
        send_email

        respond_with(true, PAYLOAD => @invoice, MESSAGE => 'Invoice was successfully updated.')
      else
        respond_with(false, PAYLOAD => @invoice)
      end
    rescue ActiveRecord::RecordNotFound
      respond_with(false, MESSAGE => "Invoice not found.")
    end

    private

    def fetch_invoice
      @invoice = @user.invoices.find(@id)
    end

    def fetch_older_emails
      @older_emails = @invoice.splitted_emails
    end

    def send_email
      emails = @invoice.splitted_emails - @older_emails

      SendInvoice.call(@invoice, emails)
    end
  end
end