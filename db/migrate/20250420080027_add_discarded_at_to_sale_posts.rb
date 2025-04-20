class AddDiscardedAtToSalePosts < ActiveRecord::Migration[7.1]
  def change
    add_column :sale_posts, :discarded_at, :datetime
    add_index :sale_posts, :discarded_at
  end
end
