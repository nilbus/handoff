class AddHandoffIdToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :handoff_id, :integer
  end
end
