require 'rails_helper'

RSpec.describe InvoiceManager::SendInvoice, type: :service do
  include ActiveJob::TestHelper

  subject(:call) { described_class.call(invoice, invoice.splitted_emails) }

  describe '.call' do
    context 'with emails' do
      let(:invoice) do
        create(:invoice, emails: "douglasfeitosa@outlook.com\ndouglas_fg@hotmail.com\ndfeitosagoncalves@gmail.com")
      end

      it 'expects to have sent three emails' do
        ActiveJob::Base.queue_adapter = :test

        expect do
          perform_enqueued_jobs do
            call
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(3)
      end
    end

    context 'without emails' do
      let(:invoice) do
        create(:invoice, emails: "douglasfeitosa@outlook.com\n")
      end

      it 'expects to not sent emails' do
        ActiveJob::Base.queue_adapter = :test

        expect do
          perform_enqueued_jobs do
            call
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end
end
