class User < ApplicationRecord
  attr_accessor :remember_token

  # before_save { self.email == email.downcase }
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

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    # handles case where user has opened the site in one browser and 
    #   logs in in another, thereby replacing the remember_digest with
    #   the new cookie set in the latter. If per chance the user logs
    #   out of the first browser, this effectively sets the remember_digest
    #   to nil, hence the user is now not authenticated for both browsers.
    #   Not returning false if it is nil results to an error in the Bcrypt 
    #   password call.
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

 def forget 
  update_attribute(:remember_digest, nil)
 end
end
