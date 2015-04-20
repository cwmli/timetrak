class Account < ActiveRecord::Base
  has_many :calendars

  validates :user, presence: true
  validates :pass, presence: true
  validates :email, presence: true

  def change
  end
end
