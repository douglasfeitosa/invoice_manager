module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def generate_token
    self.token = loop do
      token = SecureRandom.uuid
      break token unless self.class.exists?(token: token)
    end
  end
end