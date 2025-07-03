class RelatedPostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :price, :location, :image
  def location
    return "" if object.location.blank?
    object.location.gsub(/\n.*/m, '').strip
  end

  def image
    return custom_image_url(object.images.first.blob.id) if object.images.attached?
    object.sale_post_images.first.image_url if object.sale_post_images.present?
  end

  def default_url_options
    { host: ENV['HOST'] || 'http://localhost:3000' }
  end
end
