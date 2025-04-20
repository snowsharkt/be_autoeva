class SalePost < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  belongs_to :user
  belongs_to :brand
  belongs_to :model
  belongs_to :version

  has_many :sale_post_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_many :reports, as: :reportable, dependent: :destroy

  has_many_attached :images

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w(active sold) }
  validates :price, numericality: { greater_than: 0 }, allow_nil: true
  validates :year, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Time.current.year + 1 } }, allow_nil: true
  validates :odo, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
