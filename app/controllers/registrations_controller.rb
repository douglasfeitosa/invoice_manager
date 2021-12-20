class RegistrationsController < ApplicationController
  before_action :logged_redirect_to, if: :signed_in?

  def new
    @user = User.new
  end

  def create
    response = UserManager::CreateUser.call(user_params[:email])

    if response.status
      redirect_to new_sessions_path, notice: response.message
    else
      @user = response.payload

      response = UserManager::FindUser.call(:email, user_params[:email])

      if response.status
        redirect_to confirm_registrations_path(email: user_params[:email])
      else
        render :new
      end
    end
  end

  def confirm
    response = UserManager::FindUser.call(:email, registration_params[:email])

    if response.status
      @user = response.payload

      render :confirm
    else
      redirect_to new_registrations_path, alert: response.message
    end
  end

  def generate
    response = UserManager::GenerateLink.call(registration_params[:email])

    key = response.status ? :notice : :alert

    redirect_to root_path, key => response.message
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def registration_params
    params.permit(:email)
  end
end
