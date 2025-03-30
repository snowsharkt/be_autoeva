class PredictionHistory < ApplicationRecord
  includes Discard::Model

  validates :car_name, presence: true, length: { maximum: 255 }
  validates :year_of_manufacture, presence: true, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: Time.current.year }
  validates :mileage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
