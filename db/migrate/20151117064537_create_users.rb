class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :refresh_token
      t.string :access_token
      t.timestamp :expires

      t.timestamps null: false
    end
    add_index :users, [:provider, :uid]
  end
end
