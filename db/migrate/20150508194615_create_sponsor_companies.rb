class CreateSponsorCompanies < ActiveRecord::Migration
  def change
    create_table :sponsor_companies do |t|
      t.string :company
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
    add_foreign_key :sponsor_companies, :events
  end
end
