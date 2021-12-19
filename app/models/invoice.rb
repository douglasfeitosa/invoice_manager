class Invoice < ApplicationRecord
  include Emailable

  belongs_to :user

  validates :user_id, :number, :date, :company, :billing_for, :total, :emails, presence: true
  validate :validate_emails

  private

  def validate_emails
    if emails.to_s.split("\n").any? { |email| !EMAIL_FORMAT.match?(email) }
      errors.add(:email, 'There\'s an invalid email')
    end
  end
end
