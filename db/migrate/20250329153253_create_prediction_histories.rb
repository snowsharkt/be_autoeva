class CreatePredictionHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :prediction_histories do |t|
      t.string :car_name
      t.integer :year_of_manufacture
      t.integer :mileage
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
