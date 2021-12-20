class User < ApplicationRecord
  include Emailable
  include Uuidable

  has_many :invoices

  validates :email, presence: true, uniqueness: true, format: EMAIL_FORMAT
  validates :token, uniqueness: true

  before_create :generate_token!

  def generate_link!
    generate_unique_uuid(:email_token)
  end

  def generate_token!
    self.email_token = nil
    generate_unique_uuid(:token)
  end
end
