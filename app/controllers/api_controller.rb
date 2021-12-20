class APIController < ActionController::API
  include Wardenable

  def root
    render json: {}
  end

  def not_found
    render json: {}, status: :not_found
  end
end
