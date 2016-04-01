class RelationshipFindOrCreate

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(relationship_info)
  		Relationship.find_or_create_by(user_id: relationship_info["user_id"], relationship_id: relationship_info["relationship_id"]) do |relationship|
  			relationship.update_attributes(relationship_info)
  			Message.create(relationship_id: relationship.id)
  		end
  end
end