class Api::CommentsController < Api::ApiController
  before_action :authenticate_user!
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authorize_comment_owner!, only: [:update, :destroy]

  # GET /api/sale_posts/:sale_post_id/comments
  def index
    @sale_post = SalePost.find(params[:sale_post_id])
    @comments = @sale_post.comments.includes(:user).order(created_at: :desc)
                          .paginate(page: params[:page], per_page: 10)
    render json: {
      comments: ActiveModelSerializers::SerializableResource.new(
        @comments,
        each_serializer: CommentSerializer,
      ),
      current_page: @comments.current_page,
      total_pages: @comments.total_pages,
    }
  end

  # GET /api/comments/:id
  def show
    render json: @comment
  end

  # POST /api/sale_posts/:sale_post_id/comments
  def create
    @sale_post = SalePost.find(params[:sale_post_id])
    @comment = @sale_post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_comment_owner!
    unless current_user.admin? || @comment.user.id == current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end
end
