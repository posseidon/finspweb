class AddNoteToShapefiles < ActiveRecord::Migration
  def up
    add_column :shapefiles, :note, :text
  end

  def down
    remove_column :shapefiles, :note
  end
end
