class Team < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use:  [:slugged, :finders]

  validates :name, presence: true

  has_many :events, dependent: :destroy
  has_many :members, dependent: :destroy
  belongs_to :account
  has_and_belongs_to_many :seasons
end
