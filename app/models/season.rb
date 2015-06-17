class Season < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use:  [:slugged, :finders]

  validates :title, presence: true

  belongs_to :account
  has_and_belongs_to_many :teams, dependent: :nullify
  has_many :venues, dependent: :destroy
end
