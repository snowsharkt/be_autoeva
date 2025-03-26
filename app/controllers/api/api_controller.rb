class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from StandardError do |e|
    Rails.logger.error(e)
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
end
