class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :team1, use:  [:slugged, :finders]

  belongs_to :team

  validates :team1, presence: true
  validates :team2, presence: true
  validates :startdate, presence: true
end
