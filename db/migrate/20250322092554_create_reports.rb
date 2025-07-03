class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :reportable, polymorphic: true, null: false
      t.string :reason, null: false
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
