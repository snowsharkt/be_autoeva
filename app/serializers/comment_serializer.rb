class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :user

  def user
    {
      id: object.user.id,
      email: object.user.email,
      name: "#{object.user.first_name} #{object.user.last_name}",
    }
  end
end
