class Admin::CommentsController < AdminController
  before_action :set_comment, only: [:show, :destroy]

  def index
    @comments = Comment.includes(:user, :sale_post).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def destroy
    @comment.destroy
    redirect_to admin_comments_path, notice: 'Comment was successfully deleted.'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
