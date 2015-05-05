class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :company
      t.string :twitter_handle
      t.string :shirt_size
      t.text :dietary_restrictions

      t.timestamps null: false
    end
  end
end
