class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :sale_post

  validates :user_id, uniqueness: { scope: :sale_post_id }
end
