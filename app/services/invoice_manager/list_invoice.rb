module InvoiceManager
  class ListInvoice < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      fetch_invoices

      respond_with(true, PAYLOAD => @invoices)
    end

    private

    def fetch_invoices
      @invoices = @user.invoices
    end
  end
end