class AddCheckedInToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :checked_in, :boolean, default: false
  end
end
