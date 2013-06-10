class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.integer :assignment_id, null: false
      t.string  :email,         null: false

      t.timestamps
    end

    add_index :recipients, [:assignment_id, :email], unique: true
  end
end
