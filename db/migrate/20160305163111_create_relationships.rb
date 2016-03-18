class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :relationship, class_name: "User"
    	t.string :nickname, null: false
    	t.string :picture
    	t.string :email, null: false, default: ""
    	t.boolean :fb_connected, null: false, default: false
    	t.boolean :tw_connected, null: false, default: false
    	t.boolean :gg_connected, null: false, default: false
    	t.date :send_date
      t.timestamps null: false
    end
  end
end
