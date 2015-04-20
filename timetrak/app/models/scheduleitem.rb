class ScheduleItem < ActiveRecord::Base
  belongs_to :calendar

  validates :title, presence:true

  validates :start_time, presence:true
  validates :end_time, presence:true
end
