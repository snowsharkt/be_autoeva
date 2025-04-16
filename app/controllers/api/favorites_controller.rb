module Api
  class FavoritesController < ApiController
    before_action :authenticate_user!
    before_action :set_favorite, only: [:destroy]
    before_action :set_sale_post, only: [:create]

    # GET /api/favorites
    def index
      @favorites = current_user.favorites.includes(:sale_post)
      render json: @favorites, each_serializer: FavoriteSerializer
    end

    # POST /api/sale_posts/:sale_post_id/favorites
    def create
      @favorite = current_user.favorites.build(sale_post: @sale_post)

      if @favorite.save
        render json: @favorite, serializer: FavoriteSerializer, status: :created
      else
        render json: { errors: @favorite.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/favorites/:id
    def destroy
      @favorite.destroy
      head :no_content
    end

    private

    def set_favorite
      @favorite = current_user.favorites.find(params[:id])
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
