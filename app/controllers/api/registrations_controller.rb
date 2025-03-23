class Api::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)
    resource.role = 'user'

    if resource.save
      sign_in(resource)
      render json: { user: resource.as_json(only: [:id, :email, :first_name, :last_name, :role]) }
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
