class ApplicationController < ActionController::Base
  before_action :logged_redirect_to, only: :root, if: :signed_in?
  helper_method :signed_in?, :current_user

  def signed_in?
    warden.authenticated?(:internal)
  end

  def current_user
    warden.user(:internal)
  end

  def authenticate!
    warden.authenticate!(scope: :internal, store: true)
  end

  def warden
    env['warden']
  end

  def env
    request.env
  end

  def root
  end

  private

  def logged_redirect_to
    redirect_to internal_invoices_path
  end
end
