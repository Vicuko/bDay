class PersonaFindOrCreate

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(persona_info, relationship_info, social_network_id)
  		@persona = User.find_or_create_by(persona_info)
      @social_network = SocialNetwork.find_by(id: social_network_id)
  		if relationship_info.present?
  			relationship_info["relationship_id"]=@persona.id
  			RelationshipFindOrCreate.perform_async(relationship_info)
  		end
      
      if @social_network.present?
        @social_network.update_attributes(user_id: @persona.id)
      end 
  end
  
end