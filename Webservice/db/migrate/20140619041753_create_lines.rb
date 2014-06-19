class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :name
      t.string :origin
      t.string :destination
      t.string :stif

      t.timestamps
    end
  end
end
