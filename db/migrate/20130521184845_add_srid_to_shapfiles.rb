class AddSridToShapfiles < ActiveRecord::Migration
  def up
    add_column :shapefiles, :projection, :integer, :default => 4236
  end

  def down
    remove_column :shapefiles, :projection
  end
end
