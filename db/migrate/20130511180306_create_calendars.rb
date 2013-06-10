class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :user_id,    null: false
      t.string  :external_id, limit: 100, null: false
      t.string  :name,        limit: 100, null: false
      t.string  :time_zone,   limit: 50,  null: false
      t.boolean :selected,    default: false

      t.timestamps
    end

    add_index :calendars, [:user_id]
    add_index :calendars, [:external_id], unique: true
  end
end
