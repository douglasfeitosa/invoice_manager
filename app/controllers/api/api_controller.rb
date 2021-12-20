module API
  class APIController < ActionController::API
    prepend_before_action :authenticate!

    helper_method :signed_in?, :current_user

    def signed_in?
      warden.authenticated?(:api)
    end

    def current_user
      warden.user(:api)
    end

    def authenticate!
      warden.authenticate!(scope: :api, store: false)
    end

    def warden
      env['warden']
    end

    def env
      request.env
    end

    def root
      render json: {}
    end

    def not_found
      render json: {}, status: :not_found
    end
  end
end
