require 'rails_helper'

RSpec.describe UserManager::CreateUser, type: :service do
  include ActiveJob::TestHelper

  subject(:call) { described_class.call(email) }

  describe '.call' do
    context 'when given valid email' do
      let(:email) { 'douglasfeitosa@outlook.com' }

      it 'expects create an user' do
        expect { call }.to change { User.count }.by(1)
      end

      it 'expects respond with message' do
        expect(call.message).to eq('User was created. Check your email.')
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

      it 'expects create an user' do
        expect { call }.to change { User.count }.by(0)
      end
    end
  end
end