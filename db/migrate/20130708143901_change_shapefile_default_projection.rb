class ChangeShapefileDefaultProjection < ActiveRecord::Migration
  def change
	change_column :shapefiles, :projection, :integer, :default => 4326
  end
end
