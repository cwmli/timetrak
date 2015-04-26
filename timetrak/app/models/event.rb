class Event < ActiveRecord::Base
  belongs_to :account

  validates :title, presence: true
  validates :startdate, presence: true
  validates :enddate, presence: true
end
