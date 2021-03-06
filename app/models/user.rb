class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, {
             class_name: "Relationship",
             foreign_key: "follower_id",
             dependent: :destroy
           }
  has_many :passive_relationships, {
             class_name: "Relationship",
             foreign_key: "followed_id",
             dependent: :destroy
           }
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save do
    self.email = email.downcase
  end

  has_secure_password
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}

  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  def feed
    Micropost.where(user_id: following.map(&:id).push(self.id))
  end

  def follow(user)
    following.push user
  end

  def unfollow(user)
    following.delete user
  end

  def following?(user)
    following.include? user
  end

  def followed_by?(user)
    followers.include? user
  end

  def self.digest(str)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(str, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
