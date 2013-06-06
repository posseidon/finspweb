class AddUserToVersion < ActiveRecord::Migration
  def change
  	add_column :versions, :user_id, :integer
  end
end
