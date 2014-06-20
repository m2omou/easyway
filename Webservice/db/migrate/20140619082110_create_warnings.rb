class CreateWarnings < ActiveRecord::Migration
  def change
    create_table :warnings do |t|
      t.text :description
      t.string :picture
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
