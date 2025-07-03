class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :sale_post

  validates :content, presence: true
end
