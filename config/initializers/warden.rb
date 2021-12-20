strategies = [:internal, :api]

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :internal
  manager.failure_app = lambda do |env|
    if env['REQUEST_PATH'].to_s.include?('/api')
      [401, { "Content-Type" => "application/json" }, [{ error: "Authentication failure" }.to_json]]
    else
      ApplicationController.action(:root).call(env)
    end
  end
end

strategies.each do |strategy|
  Warden::Manager.serialize_into_session(strategy) do |user|
    user.id
  end

  Warden::Manager.serialize_from_session(strategy) do |id|
    User.find(id)
  end

  Warden::Strategies.add(strategy) do
    def authenticate!
      user = User.find_by_token(params.dig('user', 'token').to_s.strip)

      if user
        success! user
      else
        fail "Invalid token"
      end
    end
  end
end
