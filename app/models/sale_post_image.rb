class SalePostImage < ApplicationRecord
  belongs_to :sale_post

  validates :image_url, presence: true
end
