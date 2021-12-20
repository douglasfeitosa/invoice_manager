require 'rails_helper'

RSpec.describe '/internal/invoices', type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let!(:invoice) { create(:invoice, user: user) }

  let(:valid_attributes) do
    {
      number: '123456789',
      date: Date.new(2021, 12, 18),
      company: 'Husky',
      billing_for: 'Douglas',
      total: 100.0,
      emails: 'douglasfeitosa@outlook.com'
    }
  end

  let(:invalid_attributes) do
    {
      number: '',
      date: '',
      company: '',
      billing_for: '',
      total: '',
      emails: ''
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    before do
      get internal_invoices_url
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'renders template index' do
      expect(response).to render_template('internal/invoices/index')
    end
  end

  describe 'GET /show' do
    context 'with a valid invoice for user' do
      before do
        get internal_invoice_url(invoice)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'renders template show' do
        expect(response).to render_template('internal/invoices/show')
      end
    end

    context 'with downloading pdf' do
      before do
        get internal_invoice_url(invoice, format: :pdf)

        @analysis = PDF::Inspector::Text.analyze response.body
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'expects downloaded PDF with invoice number' do
        expect(@analysis.strings.join).to include invoice.number
      end
    end

    context 'with an invoice from another user' do
      let(:invoice_2) { create(:invoice) }

      before do
        get internal_invoice_url(invoice_2)
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end

    context 'with an invalid invoice' do
      before do
        get internal_invoice_path(1000)
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end
  end

  describe 'GET /new' do
    before do
      get new_internal_invoice_url
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'renders template new' do
      expect(response).to render_template('internal/invoices/new')
    end
  end

  describe 'GET /edit' do
    context 'with a valid invoice for user' do
      before do
        get edit_internal_invoice_url(invoice)
      end

      it 'render a successful response' do
        expect(response).to be_successful
      end

      it 'renders template edit' do
        expect(response).to render_template('internal/invoices/edit')
      end
    end

    context 'with an invoice from another user' do
      let(:invoice_2) { create(:invoice) }

      before do
        get edit_internal_invoice_url(invoice_2)
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end

    context 'with an invalid invoice' do
      before do
        get edit_internal_invoice_path(1000)
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Invoice' do
        expect {
          post internal_invoices_url, params: { invoice: valid_attributes }
        }.to change(Invoice, :count).by(1)
      end

      it 'redirects to the created invoice' do
        post internal_invoices_url, params: { invoice: valid_attributes }

        expect(response).to redirect_to(internal_invoice_url(Invoice.last))
      end

      it 'expects to have message' do
        post internal_invoices_url, params: { invoice: valid_attributes }

        follow_redirect!

        expect(response.body).to include('Invoice sent to informed emails.')
      end

      it 'expects to deliver one email' do
        ActiveJob::Base.queue_adapter = :test

        expect do
          perform_enqueued_jobs do
            post internal_invoices_url, params: { invoice: valid_attributes }
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Invoice' do
        expect {
          post internal_invoices_url, params: { invoice: invalid_attributes }
        }.to change(Invoice, :count).by(0)
      end

      it 'renders template new' do
        post internal_invoices_url, params: { invoice: invalid_attributes }

        expect(response).to render_template('internal/invoices/new')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with a valid invoice for user' do
      context 'with valid parameters' do
        let(:invoice) { create(:invoice, user: user, emails: "douglasfeitosa@outlook.com\ninvoicemanagerapplication@gmail.com") }
        let(:new_attributes) do
          {
            number: '123456789',
            emails: "douglasfeitosa@outlook.com\ndouglas_fg@hotmail.com\ndfeitosagoncalves@gmail.com"
          }
        end

        it 'redirects to the invoice' do
          ActiveJob::Base.queue_adapter = :test

          patch internal_invoice_url(invoice), params: { invoice: new_attributes }

          invoice.reload

          expect(response).to redirect_to(internal_invoice_url(invoice))
        end

        it 'renders template show' do
          ActiveJob::Base.queue_adapter = :test

          patch internal_invoice_url(invoice), params: { invoice: new_attributes }

          invoice.reload

          follow_redirect!

          expect(response).to render_template('internal/invoices/show')
        end

        it 'expects to deliver two emails' do
          ActiveJob::Base.queue_adapter = :test

          expect do
            perform_enqueued_jobs do
              patch internal_invoice_url(invoice), params: { invoice: new_attributes }
            end
          end.to change { ActionMailer::Base.deliveries.size }.by(2)
        end
      end

      context 'with invalid parameters' do
        it 'renders template edit' do
          patch internal_invoice_url(invoice), params: { invoice: invalid_attributes }

          expect(response).to render_template('internal/invoices/edit')
        end
      end
    end

    context 'with an invoice from another user' do
      let(:invoice_2) { create(:invoice) }

      before do
        patch internal_invoice_url(invoice_2), params: { invoice: { number: '123456789' } }
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end

    context 'with an invalid invoice' do
      before do
        patch internal_invoice_path(1000), params: { invoice: { number: '123456789' } }
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(internal_invoices_url)
      end

      it 'expects to have an error message' do
        follow_redirect!

        expect(response.body).to include('Invoice not found.')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested invoice' do
      expect {
        delete internal_invoice_url(invoice)
      }.to change(Invoice, :count).by(-1)
    end

    it 'redirects to the invoices list' do
      delete internal_invoice_url(invoice)

      expect(response).to redirect_to(internal_invoices_url)
    end
  end
end
