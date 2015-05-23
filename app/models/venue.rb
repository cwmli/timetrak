class Venue < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use:  [:slugged, :finders]

  validates :location, presence: true

  belongs_to :season
end
