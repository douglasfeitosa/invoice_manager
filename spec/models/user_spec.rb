require 'rails_helper'
require_relative 'concerns/uuidable_spec.rb'

RSpec.describe User, type: :model do
  subject { build(:user) }

  let(:column) { :token }

  it_behaves_like 'uuidable'

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value(Faker::Internet.email).for(:email) }
    it { should validate_uniqueness_of(:token) }
  end

  describe '.generate_link!' do
    it 'expects to generate random uuid' do
      subject.email_token = nil

      expect { subject.generate_link! }.to change { subject.email_token }.from(nil)
    end
  end
end