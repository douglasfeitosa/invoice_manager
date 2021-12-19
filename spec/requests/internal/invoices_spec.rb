 require 'rails_helper'

RSpec.describe '/internal/invoices', type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }

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

  let!(:invoice) { create(:invoice) }

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

  describe 'POST /create' do
    let(:user) { create(:user) }

    before do
      login_as user
    end

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
    context 'with valid parameters' do
      let(:new_attributes) { { number: '123456789' } }

      before do
        patch internal_invoice_url(invoice), params: { invoice: new_attributes }

        invoice.reload
      end

      it 'redirects to the invoice' do
        expect(response).to redirect_to(internal_invoice_url(invoice))
      end

      it 'renders template show' do
        follow_redirect!

        expect(response).to render_template('internal/invoices/show')
      end
    end

    context 'with invalid parameters' do
      it 'renders template edit' do
        patch internal_invoice_url(invoice), params: { invoice: invalid_attributes }

        expect(response).to render_template('internal/invoices/edit')
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
