class Team < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use:  [:slugged, :finders]

  validates :name, presence: true

  has_many :events, dependent: :destroy
  has_many :members, dependent: :destroy
  belongs_to :season
  belongs_to :account
end
