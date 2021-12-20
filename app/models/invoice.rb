class Invoice < ApplicationRecord
  include Emailable

  belongs_to :user

  validates :user_id, :number, :date, :company, :billing_for, :total, :emails, presence: true
  validate :validate_emails

  def splitted_emails
    emails.to_s.split("\n")
  end

  private

  def validate_emails
    if splitted_emails.any? { |email| !EMAIL_FORMAT.match?(email) }
      errors.add(:emails, 'There\'s an invalid email')
    end
  end
end
