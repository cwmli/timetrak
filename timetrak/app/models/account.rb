class Account < ActiveRecord::Base
  has_many :scheduleitems

  validates_prescence_of :user
  validates_prescence_of :pass
  validates_prescence_of :email

  def change
  end
end
