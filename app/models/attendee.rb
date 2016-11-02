class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :role

  scope :alphabetical, -> { order("LOWER(last_name) asc, LOWER(first_name) asc") }

  store_accessor(
    :preferences,
    :company,
    :twitter,
    :ticket_1,
    :ticket_2,
    :nonprofit,
    :shirt_size,
    :dietary_restrictions,
    :notes
  )

  def self.not_exported
    where(exported: false)
  end
end
