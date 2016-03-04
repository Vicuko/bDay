class AddFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :language, :string, null: false, length: 2 ,default:"ES"
    add_column :users, :signed_up, :boolean, default: true
  end
end
