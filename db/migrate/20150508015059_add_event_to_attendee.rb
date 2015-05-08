class AddEventToAttendee < ActiveRecord::Migration
  def change
    add_reference :attendees, :event, index: true
    add_foreign_key :attendees, :events
  end
end
