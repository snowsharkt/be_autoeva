class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(user admin) }

  def admin?
    role == 'admin'
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
