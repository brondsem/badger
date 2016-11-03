class AddDefaultToAttendeeExported < ActiveRecord::Migration
  def change
    change_column :attendees, :exported, :boolean, null: false, default: false
  end
end
