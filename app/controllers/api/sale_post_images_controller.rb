class Api::SalePostImagesController < Api::ApiController
  before_action :set_sale_post
  before_action :authorize_owner!
  before_action :set_image, only: [:destroy]
  def create
    @image = @sale_post.sale_post_images.new(image_params)

    if @image.save
      render json: @image, status: :created
    else
      render json: { errors: @image.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @image.destroy
      render json: { message: 'Image deleted successfully' }, status: :ok
    else
      render json: { errors: @image.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_sale_post
    @sale_post = SalePost.find(params[:sale_post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Sale post not found' }, status: :not_found
  end

  def set_image
    @image = @sale_post.sale_post_images.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Image not found' }, status: :not_found
  end

  def authorize_owner!
    unless @sale_post.user_id == current_user.id || current_user.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def image_params
    params.require(:sale_post_image).permit(:image_url)
  end
end
