module Internal
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[ show edit update destroy ]

    def index
      @invoices = Invoice.all
    end

    def show
    end

    def new
      @invoice = Invoice.new
    end

    def edit
    end

    def create
      @invoice = current_user.invoices.build(invoice_params)

      if @invoice.save
        redirect_to internal_invoice_path(@invoice), notice: 'Invoice sent to informed emails.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @invoice.update(invoice_params)
        redirect_to internal_invoice_path(@invoice), notice: "Invoice was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @invoice.destroy

      redirect_to internal_invoices_path, notice: "Invoice was successfully destroyed."
    end

    private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:number, :date, :company, :billing_for, :total, :emails)
    end
  end
end
