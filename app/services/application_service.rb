require 'ostruct'

class ApplicationService
  TYPES = [
    ERROR = :error,
    MESSAGE = :message,
    PAYLOAD = :payload
  ]

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def respond_with(status, response = {})
    OpenStruct.new({ status: status, **response })
  end
end