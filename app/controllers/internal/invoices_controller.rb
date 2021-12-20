module Internal
  class InvoicesController < InternalController
    def index
      @invoices = InvoiceManager::ListInvoice.call(current_user, params[:filter]).payload
    end

    def show
      response = InvoiceManager::FindInvoice.call(current_user, params[:id])

      if response.status
        @invoice = response.payload

        respond_to do |format|
          format.html { render :show }
          format.pdf do
            render pdf: 'invoice.pdf', layout: 'application.pdf.erb'
          end
        end

      else
        redirect_to internal_invoices_path, alert: response.message
      end
    end

    def new
      @invoice = Invoice.new
    end

    def edit
      response = InvoiceManager::FindInvoice.call(current_user, params[:id])

      if response.status
        @invoice = response.payload
      else
        redirect_to internal_invoices_path, alert: response.message
      end
    end

    def create
      create_invoice_response = InvoiceManager::CreateInvoice.call(current_user, invoice_params)

      if create_invoice_response.status
        redirect_to internal_invoice_path(create_invoice_response.payload), notice: create_invoice_response.message
      else
        @invoice = create_invoice_response.payload

        render :new, status: :unprocessable_entity
      end
    end

    def update
      response = InvoiceManager::UpdateInvoice.call(current_user, params[:id], invoice_params)

      if response.status
        redirect_to internal_invoice_path(response.payload), notice: response.message
      elsif response.payload
        @invoice = response.payload

        render :edit, status: :unprocessable_entity
      else
        redirect_to internal_invoices_path, alert: response.message
      end
    end

    def destroy
      response = InvoiceManager::DeleteInvoice.call(current_user, params[:id])

      key = response.status ? :notice : :alert

      redirect_to internal_invoices_path, key => response.message
    end

    private

    def invoice_params
      params.require(:invoice).permit(:id, :number, :date, :company, :billing_for, :total, :emails)
    end
  end
end
