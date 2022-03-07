class User < ApplicationRecord
  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 250 },
                    uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  has_many :toys, foreign_key: :owner_id, dependent: :destroy

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # returns a hashed password
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end
end
