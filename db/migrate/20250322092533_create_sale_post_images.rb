class CreateSalePostImages < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_post_images do |t|
      t.references :sale_post, null: false, foreign_key: true
      t.string :image_url, null: false

      t.timestamps
    end
  end
end
