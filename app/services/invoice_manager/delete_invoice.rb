module InvoiceManager
  class DeleteInvoice < ApplicationService
    def initialize(user, id)
      @user = user
      @id = id
    end

    def call
      fetch_invoice

      if @invoice.destroy
        respond_with(true, MESSAGE => "Invoice was successfully destroyed.")
      else
        respond_with(false, MESSAGE => "Invoice could not be destroyed.")
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