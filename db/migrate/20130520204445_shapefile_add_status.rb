class ShapefileAddStatus < ActiveRecord::Migration
  def up
    add_column :shapefiles, :condition, :string, :default => "Empty"
    add_column :shapefiles, :features, :integer, :default => 0
    add_column :shapefiles, :faults, :string
  end

  def down
    remove_column :shapefiles, :faults
    remove_column :shapefiles, :features
    remove_column :shapefiles, :condition
  end
end
