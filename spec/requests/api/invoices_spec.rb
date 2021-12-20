require 'rails_helper'

RSpec.describe '/api/invoices', type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  let!(:invoices_1) { create_list(:invoice, 3, user: user_1) }
  let!(:invoices_2) { create_list(:invoice, 2, user: user_2) }
  let!(:invoices_3) { create_list(:invoice, 8, user: user_2, date: Date.new(2021, 12, 20)) }

  describe 'POST /index' do
    before do
      get api_invoices_path(params)
    end

    context 'when not given filter' do
      context 'when given user_1' do
        let(:params) { { user: { token: user_1.token } } }

        it 'returns all invoices_1' do
          expect(JSON.parse(response.body).size).to eq(3)
        end
      end

      context 'when given user_2' do
        let(:params) { { user: { token: user_2.token } } }

        it 'returns all invoices_2 and invoices_3' do
          expect(JSON.parse(response.body).size).to eq(10)
        end
      end
    end

    context 'when given filter' do
      let(:params) { { user: { token: user.token }, filter: { date: Date.new(2021, 12, 20) } } }

      context 'when given user_1' do
        let(:user) { user_1 }

        it 'not returns invoices' do
          expect(JSON.parse(response.body).size).to eq(0)
        end
      end

      context 'when given user_2' do
        let(:user) { user_2 }

        it 'returns all invoices_3' do
          expect(JSON.parse(response.body).size).to eq(8)
        end
      end
    end
  end

  describe 'POST /show' do
    let(:invoice_1) { create(:invoice) }
    let(:invoice_2) { create(:invoice) }

    before do
      get api_invoice_path(invoice, params)
    end

    context 'when given invoice_1' do
      let(:invoice) { invoice_1 }
      let(:params) { { user: { token: invoice_1.user.token } } }

      it 'shows invoice_1' do
        expect(JSON.parse(response.body)).to match({
                                                     'invoice' => {
                                                       'billing_for' => 'DFG',
                                                       'company' => 'Husky',
                                                       'created_at' => invoice_1.created_at.as_json,
                                                       'date' => '2021-12-18',
                                                       'emails' => "douglasfeitosa@outlook.com\n",
                                                       'id' => invoice_1.id,
                                                       'number' => '123456789',
                                                       'total' => '9.99',
                                                       'updated_at' => invoice_1.updated_at.as_json
                                                     }
                                                   })
      end
    end

    context 'when given invoice_2' do
      let(:invoice) { invoice_2 }
      let(:params) { { user: { token: invoice_1.user.token } } }

      it 'expects to be not found' do
        expect(response.status).to eq(404)
      end

      it 'expects to returns error message' do
        expect(JSON.parse(response.body)).to match({ 'error' => 'Invoice not found.'})
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }

    before do
      post api_invoices_path(params)
    end

    context 'when given valid attributes' do
      let(:valid_parameters) do
        {
          invoice: {
            number: '123456789',
            date: Date.new(2021, 12, 20),
            company: 'Husky',
            billing_for: 'DFG',
            total: 10.0,
            emails: 'douglasfeitosa@outlook.com\n'
          }
        }
      end
      let(:params) do
        {
          user: { token: user.token },
          **valid_parameters
        }
      end

      it 'expects successful response' do
        expect(response.status).to eq(200)
      end

      it 'expects show created invoice' do
        invoice = Invoice.last
        expect(JSON.parse(response.body)).to match({
                                                     'invoice' => {
                                                       'billing_for' => 'DFG',
                                                       'company' => 'Husky',
                                                       'created_at' => invoice.created_at.as_json,
                                                       'date' => '2021-12-20',
                                                       'emails' => 'douglasfeitosa@outlook.com\n',
                                                       'id' => invoice.id,
                                                       'total' => '10.0',
                                                       'number' => '123456789',
                                                       'updated_at'=> invoice.updated_at.as_json
                                                     }
                                                   })
      end
    end

    context 'when given invalid attributes' do
      let(:invalid_parameters) do
        {
          invoice: {
            number: '',
            date: '',
            company: '',
            billing_for: '',
            total: '',
            emails: ''
          }
        }
      end
      let(:params) do
        {
          user: { token: user.token },
          **invalid_parameters
        }
      end

      it 'expects unprocessable response' do
        expect(response.status).to eq(422)
      end

      it 'expects show error json' do
        expect(JSON.parse(response.body)).to match({
                                                     'errors' => {
                                                       'billing_for' => ['can\'t be blank'],
                                                       'company' => ['can\'t be blank'],
                                                       'date' => ['can\'t be blank'],
                                                       'emails' => ['can\'t be blank'],
                                                       'number' => ['can\'t be blank'],
                                                       'total' => ['can\'t be blank']
                                                     }
                                                   })
      end
    end
  end

  describe 'POST /update' do
    let(:invoice_1) { create(:invoice) }
    let(:invoice_2) { create(:invoice) }

    before do
      patch api_invoice_path(invoice.id, params)
    end

    context 'when given invoice from another user' do
      let(:invoice) { invoice_2 }
      let(:params) { { user: { token: invoice_1.user.token }, invoice: { number: '987564321' } } }

      it 'expects not found response' do
        expect(response.status).to eq(404)
      end

      it 'expects show error json' do
        expect(JSON.parse(response.body)).to match({
                                                     'error' => 'Invoice not found.'
                                                   })
      end
    end

    context 'when given valid attributes' do
      let(:invoice) { invoice_1 }
      let(:valid_parameters) do
        {
          invoice: {
            number: '987654321',
            company: 'Tesla',
            emails: "invoicemanagerapplication@gmail.com\n"
          }
        }
      end
      let(:params) do
        {
          user: { token: invoice.user.token },
          **valid_parameters
        }
      end

      it 'expects successful response' do
        expect(response.status).to eq(200)
      end

      it 'expects show updated invoice' do
        expect(JSON.parse(response.body)).to match({
                                                     'invoice' => {
                                                       'billing_for' => 'DFG',
                                                       'company' => 'Tesla',
                                                       'created_at' => invoice.created_at.as_json,
                                                       'date' => '2021-12-18',
                                                       'emails' => "invoicemanagerapplication@gmail.com\n",
                                                       'id' => invoice.id,
                                                       'total' => '9.99',
                                                       'number' => '987654321',
                                                       'updated_at'=> invoice.reload.updated_at.as_json
                                                     }
                                                   })
      end
    end

    context 'when given invalid attributes' do
      let(:invoice) { invoice_1 }
      let(:invalid_parameters) do
        {
          invoice: {
            number: '',
            date: '',
            company: '',
            billing_for: '',
            total: '',
            emails: ''
          }
        }
      end
      let(:params) do
        {
          user: { token: invoice.user.token },
          **invalid_parameters
        }
      end

      it 'expects unprocessable response' do
        expect(response.status).to eq(422)
      end

      it 'expects show error json' do
        expect(JSON.parse(response.body)).to match({
                                                     'errors' => {
                                                       'billing_for' => ['can\'t be blank'],
                                                       'company' => ['can\'t be blank'],
                                                       'date' => ['can\'t be blank'],
                                                       'emails' => ['can\'t be blank'],
                                                       'number' => ['can\'t be blank'],
                                                       'total' => ['can\'t be blank']
                                                     }
                                                   })
      end
    end
  end

  describe 'POST /send_email' do
    let(:invoice_1) { create(:invoice) }
    let(:invoice_2) { create(:invoice) }

    before do
      get send_email_api_invoice_path(invoice.id, params)
    end

    context 'when given invoice from another user' do
      let(:invoice) { invoice_2 }
      let(:params) { { user: { token: invoice_1.user.token }, invoice: { emails: "invoicemanagerapplication@gmail.com\n" } } }

      it 'expects not found response' do
        expect(response.status).to eq(404)
      end

      it 'expects show error json' do
        expect(JSON.parse(response.body)).to match({
                                                     'error' => 'Invoice not found.'
                                                   })
      end
    end

    context 'when given valid emails' do
      let(:invoice) { invoice_1 }
      let(:valid_parameters) do
        {
          invoice: {
            emails: "invoicemanagerapplication@gmail.com\n"
          }
        }
      end
      let(:params) do
        {
          user: { token: invoice.user.token },
          **valid_parameters
        }
      end

      it 'expects successful response' do
        expect(response.status).to eq(202)
      end
    end

    context 'when given invalid emails' do
      let(:invoice) { invoice_1 }
      let(:invalid_parameters) do
        {
          invoice: {
            emails: 'douglas'
          }
        }
      end
      let(:params) do
        {
          user: { token: invoice.user.token },
          **invalid_parameters
        }
      end

      it 'expects unprocessable response' do
        expect(response.status).to eq(400)
      end

      it 'expects show error json' do
        expect(JSON.parse(response.body)).to match({
                                                     'errors' => {
                                                       'emails' => ['There\'s an invalid email']
                                                     }
                                                   })
      end
    end
  end
end