module InvoiceManager
  class DeleteInvoice < ApplicationService
    def initialize(user, id)
      @user = user
      @id = id
    end

    def call
      return @response unless fetch_invoice

      if @invoice.destroy
        respond_with(true, MESSAGE => "Invoice was successfully destroyed.")
      else
        respond_with(false, MESSAGE => "Invoice could not be destroyed.")
      end
    end

    private

    def fetch_invoice
      @response = FindInvoice.call(@user, @id)

      return false unless @response.status

      @invoice = @response.payload
    end
  end
end