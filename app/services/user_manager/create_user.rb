module UserManager
  class CreateUser < ApplicationService
    def initialize(email)
      @email = email
    end

    def call
      build_user

      if @user.save
        send_email

        respond_with(true, PAYLOAD => @user, MESSAGE => 'User was created. Check your email.')
      else
        respond_with(false, PAYLOAD => @user)
      end
    end

    private

    def build_user
      @user = User.new(email: @email)
    end

    def send_email
      UserMailer.new_user(@user).deliver_later
    end
  end
end
