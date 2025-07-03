class AddPredictionPriceToPredictionHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :prediction_histories, :prediction_price, :string
  end
end
