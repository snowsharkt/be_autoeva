class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.1]
  def change
    change_table(:users) do |t|
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""
      t.boolean :allow_password_change, default: false
      t.text :tokens
    end

    User.reset_column_information
    User.find_each do |user|
      user.uid = user.email
      user.provider = 'email'
      user.save!
    end

    add_index :users, [:uid, :provider], unique: true
  end
end
