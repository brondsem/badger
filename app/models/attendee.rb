class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :role

  scope :alphabetical, -> { order("LOWER(last_name) asc, LOWER(first_name) asc") }

  def self.not_exported
    where(exported: false)
  end

  def self.pending
    where(exported: false)
  end

  def name
    [first_name, last_name].join(" ")
  end
end
