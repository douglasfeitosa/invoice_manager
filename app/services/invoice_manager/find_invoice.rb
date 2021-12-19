module InvoiceManager
  class FindInvoice < ApplicationService
    def initialize(user, id)
      @user = user
      @id = id
    end

    def call
      fetch_invoice

      respond_with(true, PAYLOAD => @invoice)
    rescue ActiveRecord::RecordNotFound
      respond_with(false, MESSAGE => 'Invoice not found.')
    end

    private

    def fetch_invoice
      @invoice = @user.invoices.find(@id)
    end
  end
end