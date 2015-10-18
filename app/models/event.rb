class Event < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_and_belongs_to_many :users
  has_many :roles
  has_many :attendees

  scope :upcoming, -> { order(:start_date) }
  scope :alphabetical, -> { order(:name) }
end
