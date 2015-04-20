class Calendar < ActiveRecord::Base
  has_many :scheduleitems

  validates :name, presence: true
  validates :owners, presence: true

  def initialize
    @name = :name
    @owners = Array.new
    @owners = :owners.collect
  end
end
