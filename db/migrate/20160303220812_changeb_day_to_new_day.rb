class ChangebDayToNewDay < ActiveRecord::Migration
  def change
  	change_column :users, :bday, :date, :default => "01/01/1980", null: false
  end
end
