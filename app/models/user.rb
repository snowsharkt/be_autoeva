class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :sale_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :sale_post
  has_many :reports, foreign_key: :reporter_id, dependent: :nullify
  has_many :received_reports, as: :reportable, class_name: 'Report', dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(user admin banned) }
  validates :phone_number, uniqueness: true, allow_blank: true

  def admin?
    role == 'admin'
  end

  def banned?
    role == 'banned'
  end

  def active_for_authentication?
    super && !banned?
  end

  def inactive_message
    banned? ? :banned : super
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def reset_password_period_valid?
    return false unless reset_password_sent_at

    reset_password_sent_at.utc >= (Time.current.utc - self.class.reset_password_within)
  end
end
