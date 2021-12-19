require 'rails_helper'

RSpec.describe InvoiceManager::DeleteInvoice, type: :service do
  subject(:call) { described_class.call(user, invoice_id) }

  let(:user_1) { create(:user) }
  let(:invoice_1) { create(:invoice, user: user_1) }
  let(:user_2) { create(:user) }
  let(:invoice_2) { create(:invoice, user: user_2) }

  describe '.call' do
    context 'when user has an invoice' do
      let(:user) { user_1 }
      let(:invoice_id) { invoice_1.id }

      it 'expects respond with status true' do
        expect(call.status).to be_truthy
      end

      it 'expects respond with payload with invoice_1' do
        expect(call.message).to eq('Invoice was successfully destroyed.')
      end
    end

    context 'when another user has an invoice' do
      let(:user) { user_2 }
      let(:invoice_id) { invoice_1.id }

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects respond with message' do
        expect(call.message).to eq('Invoice not found.')
      end
    end

    context 'when given invalid invoice' do
      let(:user) { user_2 }
      let(:invoice_id) { 1000 }

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects respond with message' do
        expect(call.message).to eq('Invoice not found.')
      end
    end

    context 'when destroy returns false' do
      let(:user) { user_2 }
      let(:invoice_id) { invoice_2.id }

      before do
        invoices = double(:invoices)
        allow(user).to receive(:invoices) { invoices }
        allow(invoices).to receive(:find) { invoice_2 }
        allow(invoice_2).to receive(:destroy) { false }
      end

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects respond with message' do
        expect(call.message).to eq('Invoice could not be destroyed.')
      end
    end
  end
end