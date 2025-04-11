class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  belongs_to :sale_post
  belongs_to :user, serializer: UserSerializer
end
