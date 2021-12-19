module InvoiceManager
  class UpdateInvoice < ApplicationService
    def initialize(user, id, attrs)
      @user = user
      @id = id
      @attrs = attrs
    end

    def call
      fetch_invoice

      if @invoice.update(@attrs)
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
  end
end