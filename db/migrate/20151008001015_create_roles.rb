class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :reference_key
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
    add_foreign_key :roles, :events
  end
end
