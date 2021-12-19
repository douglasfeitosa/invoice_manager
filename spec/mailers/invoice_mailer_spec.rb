require "rails_helper"

RSpec.describe InvoiceMailer, type: :mailer do
  describe '.invoice' do
    subject(:mail) { described_class.invoice(invoice, email).deliver_now }

    let(:invoice) { create(:invoice) }
    let(:email) { 'douglasfeitosa@outlook.com' }

    it 'renders the subject' do
      expect(mail.subject).to eq('New Invoice')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['douglasfeitosa@outlook.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['invoicemanagerapplication@gmail.com'])
    end

    it 'expects render invoice number on email' do
      expect(mail.body.encoded).to match(invoice.number)
    end
  end
end
