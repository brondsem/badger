class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :registration_key
      t.jsonb :preferences, null: false, default: '{}'
      t.belongs_to :event, index: true
      t.belongs_to :role, index: true
      t.boolean :checked_in
      t.boolean :exported

      t.timestamps null: false
    end
    add_foreign_key :attendees, :events
    add_foreign_key :attendees, :roles
    add_index  :attendees, :preferences, using: :gin
  end
end
