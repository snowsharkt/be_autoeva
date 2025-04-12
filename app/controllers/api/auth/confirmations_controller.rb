class Api::Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  def show
    begin
      @resource = resource_class.confirm_by_token(confirmation_params[:confirmation_token])

      if @resource.errors.empty?
        render json: { success: true, message: "Email confirmed." }, status: :ok
      else
        render json: { success: false, errors: @resource.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { success: false, message: "Server error!" }, status: 500
    end
  end

  private

  def confirmation_params
    params.permit(:confirmation_token)
  end
end
