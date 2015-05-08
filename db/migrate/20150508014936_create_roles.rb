class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :border_color
      t.boolean :show_company

      t.timestamps null: false
    end
  end
end
