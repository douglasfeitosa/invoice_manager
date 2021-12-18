class User < ApplicationRecord
  include Tokenable

  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :token, uniqueness: true
end
