class ApplicationController < ActionController::Base
  include Wardenable

  before_action :logged_redirect_to, only: :root, if: :signed_in?

  def root
  end

  private

  def logged_redirect_to
    redirect_to internal_invoices_path
  end
end
