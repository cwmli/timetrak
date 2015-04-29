class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use:  [:slugged, :finders]

  belongs_to :account

  validates :title, presence: true
  validates :startdate, presence: true
  validates :enddate, presence: true
end
