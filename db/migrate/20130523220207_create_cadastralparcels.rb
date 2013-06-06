class CreateCadastralparcels < ActiveRecord::Migration
  def change
    create_table :cadastralparcels do |t|
      t.string     :identifier
      t.string     :localid
      t.float      :area
      t.string     :label
      t.string     :natref
      t.geometry   :geom, :srid => 4258
    end
  end
end
