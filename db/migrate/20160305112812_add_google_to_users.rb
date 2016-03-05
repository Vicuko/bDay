class AddGoogleToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :GG, :string, null: false, default:""
  end
end
