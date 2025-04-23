module Api
  class FavoritesController < ApiController
    before_action :authenticate_user!
    before_action :set_favorite, only: [:destroy]
    before_action :set_sale_post, only: [:create]

    # GET /api/favorites
    def index
      @favorites = current_user.favorites.includes(sale_post: [:sale_post_images, :images_attachments]).order(created_at: :desc)
                               .paginate(page: params[:page], per_page: 6)
      render json: {
        favorites: ActiveModelSerializers::SerializableResource.new(
          @favorites, include: [:sale_post], each_serializer: FavoriteSerializer, scope: current_user
        ),
        current_page: @favorites.current_page,
        total_pages: @favorites.total_pages
      }
    end

    # POST /api/sale_posts/:sale_post_id/favorites
    def create
      @favorite = current_user.favorites.build(sale_post: @sale_post)

      if @favorite.save
        render json: {message: "success"}, status: :created
      else
        render json: { errors: @favorite.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/favorites/:id
    def destroy
      if @favorite.present? && @favorite.destroy
        render json: { message: 'Favorite deleted successfully' }, status: :ok
      else
        render json: { errors: "Delete fail" }, status: :unprocessable_entity
      end
    end

    private

    def set_favorite
      @favorite = current_user.favorites.find_by(sale_post_id: params[:sale_post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Favorite not found" }, status: :not_found
    end

    def set_sale_post
      @sale_post = SalePost.find(params[:sale_post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Sale post not found" }, status: :not_found
    end
  end
end
