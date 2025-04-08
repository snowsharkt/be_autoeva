class UpdateVersionsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :versions, :year_start
    remove_column :versions, :year_end
    add_column :versions, :engine_capacity, :string
    add_column :versions, :car_name_encoded, :integer
  end
end
