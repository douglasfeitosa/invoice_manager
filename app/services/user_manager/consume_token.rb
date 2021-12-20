module UserManager
  class ConsumeToken < ApplicationService
    def initialize(email_token)
      @email_token = email_token
    end

    def call
      return @response unless fetch_user

      @user.generate_token!
      @user.save

      send_email

      respond_with(true, PAYLOAD => @user)
    end

    private

    def fetch_user
      @response = FindUser.call(:email_token, @email_token)

      return false unless @response.status

      @user = @response.payload
    end

    def send_email
      UserMailer.send_token(@user).deliver_later
    end
  end
end
