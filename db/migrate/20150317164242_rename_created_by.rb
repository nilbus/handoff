class RenameCreatedBy < ActiveRecord::Migration
  def change
    rename_column :handoffs, :created_by, :creator_id
  end
end
