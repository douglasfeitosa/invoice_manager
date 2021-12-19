module InvoiceManager
  class CreateInvoice < ApplicationService
    def initialize(user, attrs)
      @user = user
      @attrs = attrs
    end

    def call
      @invoice = build_invoice

      if @invoice.save
        respond_with(true, PAYLOAD => @invoice, MESSAGE => 'Invoice sent to informed emails.')
      else
        respond_with(false, PAYLOAD => @invoice)
      end
    end

    private

    def build_invoice
      @user.invoices.build(@attrs)
    end
  end
end