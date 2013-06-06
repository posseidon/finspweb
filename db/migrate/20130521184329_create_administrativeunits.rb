class CreateAdministrativeunits < ActiveRecord::Migration
  def change
    create_table :administrativeunits do |t|
      t.string     :identifier
      t.string     :name
      t.string     :code
      t.string     :natcode
      t.string     :levelname
      t.string     :level
      t.geometry   :geom, :srid => 4258
    end
  end
end
