Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :token
  manager.failure_app = lambda { |env| ApplicationController.action(:index).call(env) }
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:token) do
  def authenticate!
    user = User.find_by_token(params.dig('user', 'token'))

    if user
      success! user
    else
      fail "Invalid token"
    end
  end
end
