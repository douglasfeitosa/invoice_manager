module Uuidable
  def generate_unique_uuid(column = :token)
    send("#{column}=", loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(column => uuid)
    end)
  end
end
