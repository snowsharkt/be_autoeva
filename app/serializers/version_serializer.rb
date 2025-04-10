class VersionSerializer < ActiveModel::Serializer
  attributes :id, :info

  def info
    "#{object.name}-#{origin}-#{fuel_type}"
  end

  def origin
    { "Imported" => "Nhập khẩu" }[object.origin] || "Lắp ráp"
  end

  def fuel_type
    fuel_map = {
      "Petrol" => "Xăng",
      "Diesel" => "Dầu",
      "Electric" => "Điện"
    }
    fuel_map[object.fuel_type] || "Hybird"
  end

end
