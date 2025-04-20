class SalePostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :price, :status, :year, :odo, :created_at, :updated_at, :favorited, :images, :location

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

  def images
    return [] unless object.images.attached?

    object.images.map do |image|
      {
        id: image.blob.id,
        url: custom_image_url(image.blob.id)
      }
    end
  end

  def default_url_options
    { host: ENV['HOST'] || 'http://localhost:3000' }
  end
end
