class AddDescriptionToHandoff < ActiveRecord::Migration
  def change
    add_column :handoffs, :description, :string
  end
end
