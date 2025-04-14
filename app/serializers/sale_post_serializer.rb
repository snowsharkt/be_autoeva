class SalePostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :status, :year, :odo, :created_at, :updated_at, :favorited

  belongs_to :user
  belongs_to :brand
  belongs_to :model
  belongs_to :version
  has_many :sale_post_images
  has_many :comments

  def favorited
    return false unless current_user
    object.favorites.exists?(user_id: current_user.id)
  end
end
