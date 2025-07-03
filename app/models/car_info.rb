class CarInfo < ApplicationRecord
  validates :name, presence: true
  validates :name_encoded, presence: true
end
