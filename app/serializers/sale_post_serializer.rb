class SalePostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :status, :year, :odo, :created_at, :updated_at

  belongs_to :user
  belongs_to :brand
  belongs_to :model
  belongs_to :version
  has_many :sale_post_images
  has_many :comments
end
