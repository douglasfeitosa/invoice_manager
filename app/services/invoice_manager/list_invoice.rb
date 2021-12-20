module InvoiceManager
  class ListInvoice < ApplicationService
    def initialize(user, filter)
      @user = user
      @filter = filter
    end

    def call
      fetch_invoices
      normalize_filter
      filter_invoices

      respond_with(true, PAYLOAD => @invoices)
    end

    private

    def fetch_invoices
      @invoices = @user.invoices
    end

    def normalize_filter
      @filter ||= {}
      @filter = @filter.delete_if { |_, value| value.blank? }
    end

    def filter_invoices
      @filter.each do |key, value|
        @invoices = @invoices.where(key => value)
      end
    end
  end
end