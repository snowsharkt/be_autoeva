class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions do |t|
      t.references :model, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :year_start
      t.integer :year_end
      t.string :origin
      t.string :transmission
      t.string :fuel_type
      t.integer :seats

      t.timestamps
    end
    add_index :versions, [:model_id, :name], unique: true
  end
end
