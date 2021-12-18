class SessionsController < ApplicationController
  before_action :redirect_to_welcome, only: :new, if: :signed_in?

  def create
    user = env['warden'].authenticate

    if user
      redirect_to home_path
    else
      flash[:alert] = env['warden'].message
      redirect_to new_sessions_path
    end
  end

  private

  def redirect_to_welcome
    redirect_to home_path
  end
end
