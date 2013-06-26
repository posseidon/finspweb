class AddNameToMapping < ActiveRecord::Migration
  def change
    add_column :mappings, :name, :string
  end
end
