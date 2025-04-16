class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :user
  belongs_to :sale_post

  def user
    {
      id: object.user.id,
      email: object.user.email,
      name: object.user.name
    }
  end
end
