class ChangeTypePriceSalePosts < ActiveRecord::Migration[7.1]
  def change
    change_column :sale_posts, :price, :decimal, precision: 13, scale: 2
  end
end
