class SalePostDetailsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :price, :status, :year, :odo, :created_at, :updated_at, :favorited, :images, :location,
             :origin, :fuel, :transmission, :seats

  belongs_to :user
  has_many :sale_post_images
  has_many :comments

  def origin
    { "Imported" => "Nhập khẩu" }[object.version.origin] || "Lắp ráp"
  end

  def location
    object.location.gsub(/[\n\t]/, '')
          .gsub(/Website:.*/, '')
          .squish
  end

  def fuel
    fuel_map = {
      "Petrol" => "Xăng",
      "Diesel" => "Dầu",
      "Electric" => "Điện"
    }
    fuel_map[object.version.fuel_type] || "Hybird"
  end

  def transmission
    object.version.transmission
  end

  def seats
    object.version.seats
  end

  def favorited
    return false unless scope
    object.favorites.exists?(user_id: scope.id)
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
