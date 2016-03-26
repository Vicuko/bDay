class Relationship < ActiveRecord::Base
	belongs_to :user
  	belongs_to :relationship, class_name: "User"
  	has_many :messages
  	accepts_nested_attributes_for :messages

  	def self.find_or_create(relationship)
  		Relationship.find_or_create_by(relationship).id
  	end

  	def self.relationship_exists?(user_id, relationship_id)
  		Relationship.find_by!(user_id: user_id, relationship_id: relationship_id).present?
    	rescue ActiveRecord::RecordNotFound
      		return false
  	end

end
