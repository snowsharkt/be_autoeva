class Version < ApplicationRecord
  belongs_to :model
  has_many :sale_posts

  validates :name, presence: true, uniqueness: { scope: :model_id }
  validates :year_start, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Time.current.year + 1 } }, allow_nil: true
  validates :year_end, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Time.current.year + 1 } }, allow_nil: true
  validates :seats, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
