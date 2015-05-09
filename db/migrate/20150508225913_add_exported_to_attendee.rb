class AddExportedToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :exported, :boolean
  end
end
