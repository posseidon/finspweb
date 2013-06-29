class CreateGeographicalnames < ActiveRecord::Migration
  def change
    create_table :geographicalnames do |t|

      t.timestamps
    end
  end
end
