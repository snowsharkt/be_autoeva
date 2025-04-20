class ListSalePostsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :price, :status, :year, :odo, :location, :image, :created_at, :updated_at, :favorited

  def favorited
    return false unless scope
    object.favorites.exists?(user_id: scope&.id)
  end

  def image
    return [] unless object.images.attached?

    custom_image_url(object.images.first.blob.id)
  end

  def default_url_options
    { host: ENV['HOST'] || 'http://localhost:3000' }
  end
end
