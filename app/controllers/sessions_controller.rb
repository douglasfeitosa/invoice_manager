class SessionsController < ApplicationController
  before_action :logged_redirect_to, only: :new, if: :signed_in?

  def create
    user = authenticate

    if user
      redirect_to internal_invoices_path
    else
      flash[:alert] = env['warden'].message
      redirect_to new_sessions_path
    end
  end

  def destroy
    warden.logout

    redirect_to root_url, notice: "Logged out!"
  end

  private

  def logged_redirect_to
    redirect_to internal_invoices_path
  end
end
