class SessionsController < ApplicationController
  before_action :logged_redirect_to, except: :destroy, if: :signed_in?

  def create
    user = warden.authenticate(scope: :internal)

    if user
      redirect_to internal_invoices_path
    else
      flash[:alert] = warden.message
      redirect_to new_sessions_path
    end
  end

  def destroy
    warden.logout(:internal)

    redirect_to root_url, notice: 'Logged out!'
  end

  def token
    response = UserManager::ConsumeToken.call(params[:token])

    if response.status
      warden.set_user(response.payload, scope: :internal)

      redirect_to internal_invoices_path
    else
      redirect_to new_sessions_path, alert: response.message
    end
  end
end
