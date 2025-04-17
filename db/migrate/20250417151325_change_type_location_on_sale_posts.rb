class ChangeTypeLocationOnSalePosts < ActiveRecord::Migration[7.1]
  def change
    change_column :sale_posts, :location, :text
  end
end
