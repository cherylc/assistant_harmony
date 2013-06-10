class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer  :user_id,           null: false
      t.datetime :schedule_start_at, null: false

      t.timestamps
    end

    add_index :assignments, [:user_id]
  end
end
