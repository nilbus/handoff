class AddNameToHandoff < ActiveRecord::Migration
  def change
    add_column :handoffs, :name, :string
  end
end
