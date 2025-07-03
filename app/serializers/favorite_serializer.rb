class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  belongs_to :sale_post, serializer: ListSalePostsSerializer, scope: :current_user
end
