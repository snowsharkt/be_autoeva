module Api
  module V1
    class SessionsController < Devise::SessionsController
      protect_from_forgery with: :null_session
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        render json: {
          status: { code: 200, message: 'Logged in successfully' },
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      end

      def respond_to_on_destroy
        if current_user
          render json: {
            status: 200,
            message: 'Logged out successfully'
          }
        else
          render json: {
            status: 401,
            message: 'Couldn\'t find an active session'
          }
        end
      end
    end
  end
end
