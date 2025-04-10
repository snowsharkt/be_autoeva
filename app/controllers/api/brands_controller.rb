class Api::BrandsController < Api::ApiController
  skip_before_action :authenticate_user!

  def index
    brands = Brand.all.order(name: :asc)
    render json: brands, each_serializer: BrandSerializer
  end
end
