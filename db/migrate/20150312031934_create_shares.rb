class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :handoff_id
      t.integer :user_id
      t.datetime :last_view
      t.integer :role

      t.timestamps null: false
    end
  end
end
