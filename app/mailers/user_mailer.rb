class UserMailer < ApplicationMailer
  def new_user(user)
    @user = user

    mail(to: @user.email, subject: 'Welcome')
  end

  def send_link(user)
    @user = user

    mail(to: @user.email, subject: 'Generate another token')
  end

  def send_token(user)
    @user = user

    mail(to: @user.email, subject: 'Your access token')
  end
end
