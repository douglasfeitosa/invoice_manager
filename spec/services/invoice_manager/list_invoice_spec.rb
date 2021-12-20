require 'rails_helper'

RSpec.describe InvoiceManager::ListInvoice, type: :service do
  subject(:call) { described_class.call(user, filter) }

  let(:user_1) { create(:user) }
  let!(:user_1_invoice_1) { create(:invoice, user: user_1, number: '123456789') }
  let!(:user_1_invoice_2) { create(:invoice, user: user_1, number: '987654321') }

  let(:user_2) { create(:user) }
  let!(:user_2_invoice_1) { create(:invoice, user: user_2, date: Date.new(2021, 12, 20)) }

  describe '.call' do
    context 'when has filter' do
      context 'when user has two invoices' do
        let(:user) { user_1 }
        let(:filter) { { number: '987654321' } }

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with one invoice' do
          expect(call.payload.count).to eq(1)
        end

        it 'expects respond with payload with user_1_invoice_2' do
          expect(call.payload).to eq([user_1_invoice_2])
        end
      end

      context 'when user has one invoice' do
        let(:user) { user_2 }
        let(:filter) { { date: Date.new(2021, 12, 19) } }

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with one invoice' do
          expect(call.payload.count).to eq(0)
        end

        it 'expects respond with payload with user_2_invoice_1' do
          expect(call.payload).to eq([])
        end
      end
    end

    context 'when has no filter' do
      context 'when user has two invoices' do
        let(:user) { user_1 }
        let(:filter) {}

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with one invoice' do
          expect(call.payload.count).to eq(2)
        end

        it 'expects respond with payload with user_1_invoice_1 and user_1_invoice_2' do
          expect(call.payload).to eq([user_1_invoice_1, user_1_invoice_2])
        end
      end

      context 'when user has one invoice' do
        let(:user) { user_2 }
        let(:filter) {}

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with one invoice' do
          expect(call.payload.count).to eq(1)
        end

        it 'expects respond with payload with user_2_invoice_1' do
          expect(call.payload).to eq([user_2_invoice_1])
        end
      end
    end
  end
end