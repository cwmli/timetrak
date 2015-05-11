class Team < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use:  [:slugged, :finders]

  validates :name, presence: true

  has_many :events
  belongs_to :account #can only be changed by one account
end
