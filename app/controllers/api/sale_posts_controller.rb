class Api::SalePostsController < Api::ApiController
  before_action :set_sale_post, only: [:show, :update, :destroy, :show_user_post]
  before_action :authorize_owner!, only: [:update, :destroy, :show_user_post]

  skip_before_action :authenticate_user!, only: [:upload, :show, :home, :search]

  def index
    @sale_posts = SalePost.includes(:user, :brand, :model, :version, :sale_post_images)
                          .order(created_at: :desc)

    render json: @sale_posts, include: [:user, :brand, :model, :version, :sale_post_images]
  end

  def show
    @related_posts = get_related_posts
    render json: {
      sale_post: ActiveModelSerializers::SerializableResource.new(
        @sale_post,
        include: [:user, :sale_post_images, comments: { include: :user }],
        serializer: SalePostDetailsSerializer,
        scope: current_user
      ),
      related_sale_posts: ActiveModelSerializers::SerializableResource.new(
        @related_posts,
        each_serializer: RelatedPostSerializer,
      ),
    }
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
    if sale_post_params[:brand_id].present? && sale_post_params[:model_id].present? && sale_post_params[:version_id].present?
      brand = Brand.find_by(id: sale_post_params[:brand_id])
      model = Model.find_by(id: sale_post_params[:model_id])
      version = Version.find_by(id: sale_post_params[:version_id])
      @sale_post.assign_attributes(title: "#{brand&.name} #{model&.name} #{version&.name}")
    end

    if @sale_post.update(sale_post_params)
      update_images_by_blob_ids if params[:images].present?
      render json: @sale_post, status: :ok
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

  def show_user_post
    render json: @sale_post, include: [:brand, :model, :version]
  end

  def home
    @sale_posts = SalePost.includes(:user, :sale_post_images)
                          .where(status: 'active')
                          .order(created_at: :desc)
                          .limit(6)
    render json: @sale_posts, each_serializer: ListSalePostsSerializer, scope: current_user
  end

  def search
    @sale_posts = SalePost.includes(:user, :sale_post_images, :images_attachments)
                          .where(status: 'active')

    if params[:query].present?
      query = "%#{params[:query]}%"
      @sale_posts = @sale_posts.where("title LIKE :q OR location LIKE :q OR description LIKE :q", q: query)
    end

    @sale_posts = @sale_posts.where(brand_id: params[:brand_id]) if params[:brand_id].present?
    @sale_posts = @sale_posts.where(model_id: params[:model_id]) if params[:model_id].present?
    @sale_posts = @sale_posts.where(version_id: params[:version_id]) if params[:version_id].present?
    @sale_posts = @sale_posts.where(year: params[:year]) if params[:year].present?

    if params[:odo_min].present? || params[:odo_max].present?
      @sale_posts = @sale_posts.where("odo >= ?", params[:odo_min].to_i) if params[:odo_min].present?
      @sale_posts = @sale_posts.where("odo <= ?", params[:odo_max].to_i) if params[:odo_max].present?
    end

    if params[:price_min].present? || params[:price_max].present?
      @sale_posts = @sale_posts.where("price >= ?", params[:price_min].to_i) if params[:price_min].present?
      @sale_posts = @sale_posts.where("price <= ?", params[:price_max].to_i) if params[:price_max].present?
    end

    case params[:sort]
    when 'price_asc'
      @sale_posts = @sale_posts.order(price: :asc)
    when 'price_desc'
      @sale_posts = @sale_posts.order(price: :desc)
    when 'year_asc'
      @sale_posts = @sale_posts.order(year: :asc)
    else
      @sale_posts = @sale_posts.order(created_at: :desc)
    end

    @sale_posts = @sale_posts.paginate(page: params[:page], per_page: 12)

    render json: {
      sale_posts: ActiveModelSerializers::SerializableResource.new(
        @sale_posts,
        each_serializer: ListSalePostsSerializer,
        scope: current_user
      ),
      current_page: @sale_posts.current_page,
      total_pages: @sale_posts.total_pages
    }
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

  def update_images_by_blob_ids
    current_images = @sale_post.images.map { |image| image&.blob&.id }
    new_images = params[:images] - current_images
    deleted_images = current_images - params[:images]
    new_images.each do |image_id|
      upload_image = ActiveStorage::Blob.find_by(id: image_id)
      @sale_post.images.attach(upload_image) if upload_image.present?
    end
    deleted_images.each do |image_id|
      @sale_post.images.find_by(blob_id: image_id).purge
    end
  end

  def get_related_posts
    base_price = @sale_post.price.to_f
    numbers_of_related_posts = 5
    numbers_of_used = 0

    sale_posts_same_version = SalePost.includes(:sale_post_images, :images_attachments).where(version_id: @sale_post.version_id, status: 'active')
                                      .where.not(id: @sale_post.id)
                                      .select("sale_posts.id, sale_posts.title, sale_posts.price, sale_posts.location")
                                      .order(Arel.sql("ABS(sale_posts.price - #{base_price}) ASC"), created_at: :desc)
                                      .limit(1)
    numbers_of_used += sale_posts_same_version.size

    sale_posts_same_model = SalePost.includes(:sale_post_images, :images_attachments).where(model_id: @sale_post.model_id, status: 'active')
                                    .where.not(id: @sale_post.id)
                                    .where.not(id: sale_posts_same_version.map{ |p| p[:id] })
                                    .select("id, title, price, location, ABS(price - #{base_price}) AS price_diff")
                                    .order(Arel.sql("ABS(sale_posts.price - #{base_price}) ASC"), created_at: :desc)
                                    .limit(numbers_of_related_posts - numbers_of_used - 2)
    numbers_of_used += sale_posts_same_model.size

    sale_posts_same_brand = SalePost.includes(:sale_post_images, :images_attachments).where(brand_id: @sale_post.brand_id, status: 'active')
                                    .where.not(id: @sale_post.id)
                                    .where.not(id: sale_posts_same_version.map{ |p| p[:id] } + sale_posts_same_model.map{ |p| p[:id] })
                                    .select("id, title, price, location, ABS(price - #{base_price}) AS price_diff")
                                    .order(Arel.sql("ABS(sale_posts.price - #{base_price}) ASC"), created_at: :desc)
                                    .limit(numbers_of_related_posts - numbers_of_used - 2)
    numbers_of_used += sale_posts_same_brand.size

    new_sale_posts = SalePost.includes(:sale_post_images, :images_attachments).where(status: 'active')
                              .where.not(id: @sale_post.id)
                             .select("sale_posts.id, sale_posts.title, sale_posts.price, sale_posts.location")
                             .order(created_at: :desc)
                             .limit((numbers_of_used - numbers_of_related_posts).abs) if (numbers_of_related_posts - numbers_of_used) > 0

    sale_posts_same_version + sale_posts_same_model + sale_posts_same_brand + new_sale_posts
  end
end
