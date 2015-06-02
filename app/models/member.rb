class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use:  [:slugged, :finders]

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :team
end
