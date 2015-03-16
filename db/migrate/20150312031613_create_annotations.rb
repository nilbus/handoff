class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :resource_id
      t.integer :parent_id
      t.integer :type
      t.text :content

      t.timestamps null: false
    end
  end
end
