class Version < ApplicationRecord
  belongs_to :model
  has_many :sale_posts

  validates :name, presence: true, uniqueness: { scope: :model_id }
  validates :seats, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :car_name_encoded, numericality: { only_integer: true }, allow_nil: true
end
