class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string, null: false, default:""
    add_column :users, :country, :string, null: false, default:""
    add_column :users, :gender, :boolean
  end
end
