class PersonaFindOrCreate

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(persona_info, relationship_info)
  		@persona = User.find_or_create_by(persona_info)
  		if relationship_info.present?
  			relationship_info["relationship_id"]=@persona.id
  			RelationshipFindOrCreate.perform_async(relationship_info)
  		end
  end
  
end