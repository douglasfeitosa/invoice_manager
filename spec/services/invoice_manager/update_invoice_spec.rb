require 'rails_helper'

RSpec.describe InvoiceManager::UpdateInvoice, type: :service do
  subject(:call) { described_class.call(user, id, attrs) }

  let(:user) { create(:user) }
  let(:invoice) { create(:invoice, user: user) }

  describe '.call' do
    context 'when given valid attributes' do
      let(:id) { invoice.id }
      let(:attrs) do
        {
          number: '987654321',
        }
      end

      it 'expects respond with status true' do
        expect(call.status).to be_truthy
      end

      it 'expects update invoice' do
        expect { call }.to change { invoice.reload.updated_at }
      end

      it 'expects respond payload with an invoice' do
        expect(call.payload).to eq(invoice)
      end

      it 'expects respond with notice message' do
        expect(call.message).to eq('Invoice was successfully updated.')
      end
    end

    context 'when given invalid attributes' do
      let(:id) { invoice.id }
      let(:attrs) do
        {
          number: ''
        }
      end

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects not update invoice' do
        expect { call }.not_to change { invoice.reload.updated_at }
      end

      it 'expects respond payload with an invoice' do
        expect(call.payload).to eq(invoice)
      end
    end

    context 'when given invalid invoice' do
      let(:id) { 500 }
      let(:attrs) {}

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects respond payload with nil' do
        expect(call.payload).to eq(nil)
      end

      it 'expects respond with error message' do
        expect(call.message).to eq('Invoice not found.')
      end
    end
  end
end