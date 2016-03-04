class ChangeSignedUpInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :signed_up, :boolean, default: false
  end
end
