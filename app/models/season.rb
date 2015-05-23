class Season < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use:  [:slugged, :finders]

  validates :title, presence: true

  belongs_to :account
  has_many :teams
  has_many :venues
end
