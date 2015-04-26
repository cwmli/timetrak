class Account < ActiveRecord::Base
  has_many :events

  validates :username, presence: true
  validates :password_digest, presence: true
  validates :email, presence: true,
                    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
                    on: :create

  has_secure_password
end
