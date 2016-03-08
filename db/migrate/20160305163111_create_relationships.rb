class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :relationship, class_name: "User"
      	t.timestamps null: false
    end
  end
end
