require 'rails_helper'
require_relative 'concerns/tokenable_spec.rb'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it_behaves_like 'tokenable'

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value(Faker::Internet.email).for(:email) }
    it { should validate_uniqueness_of(:token) }
  end
end