class Role < ActiveRecord::Base
  belongs_to :event
  has_many :attendees
end
