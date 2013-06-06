class AddArchivePathToShapefile < ActiveRecord::Migration
  def change
    add_column :shapefiles, :archive_path, :string
  end
end
