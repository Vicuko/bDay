class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  t.belongs_to :relationship, index: true
	  t.string :message, null: false, default: ""
	  t.string :message_url, null: false, default: ""
	  t.boolean :send_email, null: false, default: false
	  t.boolean :send_fb, null: false, default: false
	  t.boolean :send_tw, null: false, default: false
	  t.boolean :send_gg, null: false, default: false
	  t.boolean :message_sent, null: false, default: false
      t.timestamps null: false
    end
  end
end
