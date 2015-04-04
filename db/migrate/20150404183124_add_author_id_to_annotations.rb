class AddAuthorIdToAnnotations < ActiveRecord::Migration
  def change
    add_column :annotations, :author_id, :integer
  end
end
