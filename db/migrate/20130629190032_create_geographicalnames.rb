class CreateGeographicalnames < ActiveRecord::Migration
  def change
    create_table   :geographicalnames do |t|
      t.string     :name, :null => false
      t.string     :language, :default => 'Magyar'
      t.string     :type_of_name
      t.string     :tipus_nev
      t.string     :sourceofname
      t.geometry   :geom, :srid => 4258
    end
  end
end
