module UserManager
  class GenerateLink < ApplicationService
    def initialize(email)
      @email = email
    end

    def call
      return @response unless fetch_user

      @user.generate_link!
      @user.save

      send_email

      respond_with(true, PAYLOAD => @user, MESSAGE => "An email was sent to #{@user.email}.")
    end

    private

    def fetch_user
      @response = FindUser.call(:email, @email)

      return false unless @response.status

      @user = @response.payload
    end

    def send_email
      UserMailer.send_link(@user).deliver_later
    end
  end
end
