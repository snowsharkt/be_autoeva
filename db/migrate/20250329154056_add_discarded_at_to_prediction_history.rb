class AddDiscardedAtToPredictionHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :prediction_histories, :discarded_at, :datetime
    add_index :prediction_histories, :discarded_at
  end
end
