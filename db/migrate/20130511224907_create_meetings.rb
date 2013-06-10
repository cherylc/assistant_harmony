class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer  :user_id,       null: false
      t.integer  :assignment_id, null: false
      t.string   :external_id,   null: true
      t.string   :key,           null: false, limit: 36
      t.datetime :start_at,      null: false
      t.datetime :end_at,        null: false
      t.string   :state,         default: 'suggested'

      t.timestamps
    end

    add_index :meetings, [:user_id, :assignment_id]
    add_index :meetings, [:start_at, :end_at], unique: true
    add_index :meetings, [:key], unique: true
  end
end
