class AddBorderColorToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :border_color, :string
  end
end
