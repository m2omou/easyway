class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :name
      t.boolean :accessibility
      t.string :stif
      t.string :sens

      t.timestamps
    end
  end
end
