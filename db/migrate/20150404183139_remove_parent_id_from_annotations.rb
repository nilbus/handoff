class RemoveParentIdFromAnnotations < ActiveRecord::Migration
  def change
    remove_column :annotations, :parent_id, :integer
  end
end
