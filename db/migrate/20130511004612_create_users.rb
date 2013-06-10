class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :provider, limit: 15,  null: false
      t.string  :uid,      limit: 25,  null: false
      t.string  :token,    limit: 64,  null: false
      t.string  :refresh_token, limit: 64, null: false
      t.integer :expires_at, null: false
      t.string  :name,     limit: 100, null: false
      t.string  :email,    limit: 255, null: false
      t.integer :gender,  limit: 2
      t.string  :locale,   limit: 5
      t.string  :image,    limit: 255
      t.integer :selected_calendar_id

      t.timestamps
    end

    add_index :users, [:provider, :uid], unique: true
    add_index :users, [:email], unique: true
  end
end
