class ApplicationController < ActionController::Base
  helper_method :signed_in?, :current_user

  def index
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    warden.user
  end

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end

  def env
    request.env
  end
end
