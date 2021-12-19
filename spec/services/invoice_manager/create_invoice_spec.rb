require 'rails_helper'

RSpec.describe InvoiceManager::CreateInvoice, type: :service do
  subject(:call) { described_class.call(user, attrs) }

  let(:user) { create(:user) }

  describe '.call' do
    context 'when given valid attributes' do
      let(:attrs) do
        {
          number: '123456789',
          date: DateTime.new(2021, 12, 18),
          company: 'Husky',
          billing_for: 'DFG',
          total: 100.0,
          emails: "douglasfeitosa@outlook.com\n"
        }
      end

      it 'expects respond with status true' do
        expect(call.status).to be_truthy
      end

      it 'expects create one invoice' do
        expect { call }.to change { Invoice.count }.by(1)
      end

      it 'expects respond payload with an invoice' do
        expect(call.payload).to eq(Invoice.last)
      end

      it 'expects respond with notice message' do
        expect(call.message).to eq('Invoice sent to informed emails.')
      end
    end

    context 'when given invalid attributes' do
      let(:attrs) do
        {
          number: '',
          date: '',
          company: '',
          billing_for: '',
          total: '',
          emails: ''
        }
      end

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects to not to create an invoice' do
        expect { call }.to change { Invoice.count }.by(0)
      end

      it 'expects respond payload with an invoice' do
        expect(call.payload).to be_a(Invoice)
      end
    end
  end
end