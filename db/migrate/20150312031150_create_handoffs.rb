class CreateHandoffs < ActiveRecord::Migration
  def change
    create_table :handoffs do |t|
      t.string :patient_id
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
