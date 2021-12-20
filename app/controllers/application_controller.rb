class ApplicationController < ActionController::Base
  before_action :logged_redirect_to, only: :root, if: :signed_in?

  helper_method :signed_in?, :current_user

  def root
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

  private

  def logged_redirect_to
    redirect_to internal_invoices_path
  end
end
