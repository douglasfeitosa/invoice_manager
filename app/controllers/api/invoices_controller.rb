module API
  class InvoicesController < APIController
    def index
      @invoices = InvoiceManager::ListInvoice.call(current_user, params[:filter]).payload

      render template: 'api/views/invoices/index.json.jbuilder'
    end

    def show
      response = InvoiceManager::FindInvoice.call(current_user, params[:id])

      if response.status
        @invoice = response.payload

        render template: 'api/views/invoices/show.json.jbuilder'
      else
        render json: { error: response.message }, status: :not_found
      end
    end

    def create
      response = InvoiceManager::CreateInvoice.call(current_user, invoice_params)

      if response.status
        @invoice = response.payload

        render template: 'api/views/invoices/show.json.jbuilder'
      else
        render json: { errors: response.error }, status: :unprocessable_entity
      end
    end

    def update
      response = InvoiceManager::UpdateInvoice.call(current_user, params[:id], invoice_params)

      if response.status
        @invoice = response.payload

        render template: 'api/views/invoices/show.json.jbuilder'
      elsif response.error
        render json: { errors: response.error }, status: :unprocessable_entity
      else
        render json: { error: response.message }, status: :not_found
      end
    end

    def send_email
      response = InvoiceManager::FindInvoice.call(current_user, params[:id])

      if response.status
        @invoice = response.payload
        @invoice.assign_attributes(invoice_params)
        @invoice.valid?

        if @invoice.errors[:emails].any?
          render json: { errors: { emails: @invoice.errors[:emails] } }, status: :bad_request
        else
          InvoiceManager::SendInvoice.call(response.payload, @invoice.splitted_emails)

          render json: {}, status: :accepted
        end
      else
        render json: { error: response.message }, status: :not_found
      end
    end

    private

    def invoice_params
      params.require(:invoice).permit(:number, :date, :company, :billing_for, :total, :emails)
    end
  end
end
