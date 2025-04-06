class SalePostImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :created_at

  belongs_to :sale_post
end
