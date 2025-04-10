class Api::VersionsController < Api::ApiController
  skip_before_action :authenticate_user!, raise: false

  def index
    versions = Version.where(model_id: version_params[:model_id]).order(name: :asc)
    render json: versions, each_serializer: VersionSerializer
  end

  private

  def version_params
    params.permit(:model_id)
  end
end
