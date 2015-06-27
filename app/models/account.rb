class Account < ActiveRecord::Base
  extend FriendlyId
  attr_accessor :remember_token
  has_many :seasons
  has_many :teams
  has_many :venues, through: :seasons
  has_many :events, through: :teams

  friendly_id :username, use: [:slugged, :finders]

  validates :username, presence: true, length: {  maximum: 12 }, uniqueness: true
  validates :email, presence: true,
                    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
                    on: :create

  has_secure_password
  validates :password, length: {  minimum: 6  }

  def Account.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Account.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Account.new_token
    update_attribute(:remember_digest, Account.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
