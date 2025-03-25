class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :sale_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :sale_post
  has_many :reports, foreign_key: :reporter_id, dependent: :nullify
  has_many :received_reports, as: :reportable, class_name: 'Report', dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(user admin) }
  validates :phone_number, presence: true, uniqueness: true

  def admin?
    role == 'admin'
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
