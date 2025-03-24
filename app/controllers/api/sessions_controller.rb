class Api::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user, only: [:destroy]

  # Sign in
  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      sign_in(user)
      render json: { user: user.as_json(only: [:id, :email, :first_name, :last_name, :role]) }
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  # Sign out
  def destroy
    sign_out(current_user)
    reset_session
    render json: { success: true }
  end

  # Check if user is logged in
  def show
    if user_signed_in?
      render json: {
        user: current_user.as_json(only: [:id, :email, :first_name, :last_name, :role])
      }
    else
      render json: { user: nil }
    end
  end
end
