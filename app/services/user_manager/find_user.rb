module UserManager
  class FindUser < ApplicationService
    def initialize(key, value)
      @key = key
      @value = value
    end

    def call
      fetch_user

      respond_with(true, PAYLOAD => @user)
    rescue ActiveRecord::RecordNotFound
      respond_with(false, MESSAGE => 'User not found.')
    end

    private

    def fetch_user
      @user = User.find_by!(@key => @value)
    end
  end
end
