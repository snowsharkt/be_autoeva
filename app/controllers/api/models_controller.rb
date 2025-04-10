class Api::ModelsController < Api::ApiController
  skip_before_action :authenticate_user!

  def index
    models = Model.where(brand_id: model_params[:brand_id]).order(name: :asc)
    render json: models, each_serializer: ModelSerializer
  end

  private
  def model_params
    params.permit(:brand_id)
  end
end
