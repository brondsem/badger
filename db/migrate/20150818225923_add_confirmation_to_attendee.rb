class AddConfirmationToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :confirmation, :string
  end
end
