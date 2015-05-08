class AddRoleToAttendee < ActiveRecord::Migration
  def change
    add_reference :attendees, :role, index: true
    add_foreign_key :attendees, :roles
  end
end
