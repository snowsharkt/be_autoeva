class Model < ApplicationRecord
  belongs_to :brand
  has_many :versions, dependent: :destroy
  has_many :sale_posts

  validates :name, presence: true, uniqueness: { scope: :brand_id }
end
