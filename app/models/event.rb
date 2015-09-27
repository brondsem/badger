class Event < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
end
