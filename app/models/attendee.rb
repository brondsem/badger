class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :role

  scope :alphabetical, -> { order("LOWER(last_name) asc, LOWER(first_name) asc") }
  scope :with_name, lambda { |first_name, last_name|
    if first_name.present? || last_name.present?
      self.where(
        "first_name ILIKE :first_name AND last_name ILIKE :last_name",
        first_name: "%#{first_name}%",
        last_name: "%#{last_name}%"
      )
    end
  }

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
