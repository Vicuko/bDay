class CreateSocialNetworks < ActiveRecord::Migration
  def change
    create_table :social_networks do |t|
    	t.belongs_to :user, index: true
    	t.string :provider, null: false
		t.string :uid, null: false
		t.string :token, null: false
		t.string :expiry_date, null: false
		t.boolean :expires?, null: false, default: true
		t.string :email, null: false, default: ""
		t.string :image, null: false, default: ""
		t.boolean :verified, default: false
		t.string :timezone
		t.string :language, default: "es"
      	t.timestamps null: false
    end
  end
end
