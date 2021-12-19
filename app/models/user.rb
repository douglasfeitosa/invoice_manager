class User < ApplicationRecord
  include Emailable
  include Tokenable

  has_many :invoices

  validates :email, presence: true, uniqueness: true, format: EMAIL_FORMAT
  validates :token, uniqueness: true
end
