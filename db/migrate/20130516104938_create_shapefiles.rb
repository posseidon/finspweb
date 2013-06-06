class CreateShapefiles < ActiveRecord::Migration
  def change
    create_table :shapefiles do |t|
      t.string   :identifier
      t.integer  :version_id
      t.timestamps
    end
  end
end
