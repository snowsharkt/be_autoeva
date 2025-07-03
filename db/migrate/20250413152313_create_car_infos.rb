class CreateCarInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :car_infos do |t|
      t.string :name
      t.string :name_encoded

      t.timestamps
    end
  end
end
