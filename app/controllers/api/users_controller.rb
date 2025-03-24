class Api::UsersController < Api::ApiController
  before_action :set_user, only: [:show, :update]
  before_action :authorize_user, only: [:update]

  # GET /api/users/:id
  def show
    render json: { user: @user.as_json(only: [:id, :email, :first_name, :last_name, :role, :created_at]) }
  end

  # PUT/PATCH /api/users/:id
  def update
    if @user.update(user_params)
      render json: { user: @user.as_json(only: [:id, :email, :first_name, :last_name, :role, :created_at]) }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # GET /api/users/profile
  def profile
    render json: {
      user: current_user.as_json(only: [:id, :email, :first_name, :last_name, :role, :created_at])
    }
  end

  # POST /api/users/change_password
  def change_password
    if current_user.valid_password?(params[:current_password])
      if current_user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        render json: { success: true }
      else
        render json: { errors: current_user.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def authorize_user
    unless current_user.admin? || current_user.id == @user.id
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  def user_params
    if current_user.admin?
      params.require(:user).permit(:email, :first_name, :last_name, :role)
    else
      params.require(:user).permit(:first_name, :last_name)
    end
  end
end
