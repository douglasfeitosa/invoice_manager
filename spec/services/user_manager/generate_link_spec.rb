require 'rails_helper'

RSpec.describe UserManager::GenerateLink, type: :service do
  include ActiveJob::TestHelper

  subject(:call) { described_class.call(email) }

  let(:user) { create(:user) }

  describe '.call' do
    context 'when given valid email' do
      let(:email) { user.email }

      it 'expects respond with status true' do
        expect(call.status).to eq(true)
      end

      it 'expects respond with message' do
        expect(call.message).to eq("An email was sent to #{user.email}.")
      end

      it 'expects to have sent email' do
        ActiveJob::Base.queue_adapter = :test

        expect do
          perform_enqueued_jobs do
            call
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context 'when given invalid email' do
      let(:email) { '' }

      it 'expects respond with status false' do
        expect(call.status).to be_falsey
      end

      it 'expects respond with error message' do
        expect(call.message).to eq('User not found.')
      end
    end
  end
end