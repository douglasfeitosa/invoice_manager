require 'rails_helper'

RSpec.describe UserManager::FindUser, type: :service do
  subject(:call) { described_class.call(key, value) }

  describe '.call' do
    context 'when given valid attrs' do
      let(:user) { create(:user) }

      context 'when key is email' do
        let(:key) { 'email' }
        let(:value) { user.email }

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with user' do
          expect(call.payload).to eq(user)
        end
      end

      context 'when key is token' do
        let(:key) { 'token' }
        let(:value) { user.token }

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with user' do
          expect(call.payload).to eq(user)
        end
      end

      context 'when key is email token' do
        let(:key) { 'email_token' }
        let(:value) { user.email_token }

        it 'expects respond with status true' do
          expect(call.status).to be_truthy
        end

        it 'expects respond with payload with user' do
          expect(call.payload).to eq(user)
        end
      end
    end

    context 'when given invalid attrs' do
      let(:user) { create(:user) }

      context 'when key is email' do
        let(:key) { 'token' }
        let(:value) { user.email }

        it 'expects respond with status false' do
          expect(call.status).to be_falsey
        end

        it 'expects respond with payload nil' do
          expect(call.payload).to eq(nil)
        end

        it 'expects respond with error message' do
          expect(call.message).to eq('User not found.')
        end
      end

      context 'when key is token' do
        let(:key) { 'email_token' }
        let(:value) { user.token }

        it 'expects respond with status true' do
          expect(call.status).to be_falsey
        end

        it 'expects respond with payload nil' do
          expect(call.payload).to eq(nil)
        end

        it 'expects respond with error message' do
          expect(call.message).to eq('User not found.')
        end
      end

      context 'when key is email token' do
        let(:key) { 'email' }
        let(:value) { user.email_token }

        it 'expects respond with status false' do
          expect(call.status).to be_falsey
        end

        it 'expects respond with payload nil' do
          expect(call.payload).to eq(nil)
        end

        it 'expects respond with error message' do
          expect(call.message).to eq('User not found.')
        end
      end
    end
  end
end