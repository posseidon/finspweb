class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.references :user
      t.string     :mapping_type, :null => false
      t.text       :data, :null => false
    end
  end
end
