class Brand < ApplicationRecord
  has_many :models, dependent: :destroy
  has_many :sale_posts

  validates :name, presence: true, uniqueness: true
end
