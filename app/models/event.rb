class Event < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_and_belongs_to_many :users

  scope :upcoming, -> { order(:start_date) }
  scope :alphabetical, -> { order(:name) }
end
