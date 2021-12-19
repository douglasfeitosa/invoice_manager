require 'rails_helper'

RSpec.describe Invoice, type: :model do
  subject(:invoice) { build(:invoice) }
  subject(:invalid_invoice) { build(:invoice, :invalid_email) }

  describe 'validations' do
    it { should belong_to(:user) }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:billing_for) }
    it { should validate_presence_of(:total) }
    it { should validate_presence_of(:emails) }

    context '.validate_emails' do
      it 'expects to be valid with valid emails' do
        expect(invoice.valid?).to be_truthy
      end

      it 'expects to be invalid with invalid emails' do
        expect(invalid_invoice.valid?).to be_falsey
      end
    end
  end
end
