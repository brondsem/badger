class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :role

  scope :alphabetical, -> { order("role_id asc, first_name asc, last_name asc") }

  def self.not_exported
    where(exported: false)
  end
end
