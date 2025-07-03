class CreateModels < ActiveRecord::Migration[7.1]
  def change
    create_table :models do |t|
      t.references :brand, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :models, [:brand_id, :name], unique: true
  end
end
