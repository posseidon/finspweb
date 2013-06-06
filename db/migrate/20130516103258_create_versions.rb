class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string  :name
      t.text    :description
      t.boolean :active,   :default => false
      t.boolean :archived, :default => false
      t.boolean :staging,  :default => false
      t.timestamps
    end
  end
end
