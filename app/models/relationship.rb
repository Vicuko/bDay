class Relationship < ActiveRecord::Base
	belongs_to :user
  	belongs_to :relationship, class_name: "User"
  	has_many :messages
  	accepts_nested_attributes_for :messages
end
