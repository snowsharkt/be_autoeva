class Api::SalePostsController < Api::ApiController
  before_action :set_sale_post, only: [:show, :update, :destroy]
  before_action :authorize_owner!, only: [:update, :destroy]

  skip_before_action :authenticate_user!, only: [:upload]

  def index
    @sale_posts = SalePost.includes(:user, :brand, :model, :version, :sale_post_images)
                          .order(created_at: :desc)

    render json: @sale_posts, include: [:user, :brand, :model, :version, :sale_post_images]
  end

  def show
    render json: @sale_post, include: [:user, :brand, :model, :version, :sale_post_images, comments: { include: :user }]
  end

  def create
    @sale_post = current_user.sale_posts.new(sale_post_params)
    @sale_post.title = "#{@sale_post.brand.name} #{@sale_post.model.name} #{@sale_post.version.name}"
    @sale_post.status = 'active'
    @sale_post.location = sale_post_params[:location]
    if @sale_post.save
      create_images_by_blob_ids if params[:images].present?
      render json: @sale_post, status: :created
    else
      render json: { errors: @sale_post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @sale_post.update(sale_post_params)
      create_images_by_blob_ids if params[:images].present?
      render json: @sale_post, include: [:sale_post_images]
    else
      render json: { errors: @sale_post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @sale_post.discard
      render json: { message: 'Sale post deleted successfully' }, status: :ok
    else
      render json: { errors: @sale_post.errors }, status: :unprocessable_entity
    end
  end

  def upload
    if params[:image].present?
      blob = ActiveStorage::Blob.create_and_upload!(
        io: params[:image],
        filename: params[:image].original_filename,
        content_type: params[:image].content_type
      )

      render json: {
        id: blob.id,
        url: url_for(blob)
      }, status: :created
    else
      render json: { error: "No image provided" }, status: :unprocessable_entity
    end
  end

  private

  def set_sale_post
    @sale_post = SalePost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Sale post not found' }, status: :not_found
  end

  def authorize_owner!
    unless @sale_post.user_id == current_user.id || current_user.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def sale_post_params
    params.require(:sale_post).permit(
      :description, :price, :status, :year, :odo, :location,
      :brand_id, :model_id, :version_id
    )
  end

  def create_images
    params[:images].each do |image|
      @sale_post.sale_post_images.create(image_url: image)
    end
  end

  def create_images_by_blob_ids
    params[:images].each do |image_id|
      upload_image = ActiveStorage::Blob.find_by(id: image_id)
      @sale_post.images.attach(upload_image) if upload_image.present?
    end
  end
end
