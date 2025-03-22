class CreateSalePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.references :version, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :year
      t.integer :odo
      t.string :location
      t.string :status, default: 'active', null: false

      t.timestamps
    end
  end
end
