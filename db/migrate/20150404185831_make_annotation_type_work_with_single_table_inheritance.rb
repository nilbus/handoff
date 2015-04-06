class MakeAnnotationTypeWorkWithSingleTableInheritance < ActiveRecord::Migration
  def up
    change_column 'annotations', 'type', :string
  end

  def down
    change_column 'annotations', 'type', :integer
  end
end
