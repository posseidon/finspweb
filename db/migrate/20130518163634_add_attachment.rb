class AddAttachment < ActiveRecord::Migration
  def up
    add_attachment :shapefiles, :shapefile
  end

  def down
    remove_attachment :shapefiles, :shapefile
  end
end
