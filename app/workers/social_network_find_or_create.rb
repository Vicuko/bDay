class SocialNetworkFindOrCreate

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(user_id, social_network_info, persona_info, provider)
  	@user = User.find_by(id: user_id)
  	@provider = provider
  	@social_network_info = social_network_info
  	@persona_info = persona_info

  	if @social_network_info.present? and @user.persisted?
  		@social_network = social_network_find_or_create(@social_network_info)
  		@relationship_info = parse_relationship_info(user_id, @social_network,@provider)
  		
  		if @social_network.user_id.present?
  			RelationshipFindOrCreate.perform_async(@relationship_info)
  		else
  			PersonaFindOrCreate.perform_async(@persona_info,@relationship_info,@social_network.id)
  		end
  	end
  end

private

	def social_network_find_or_create(social_network)
	  if social_network.present?
	  	return SocialNetwork.where(provider: @provider, uid: social_network["uid"]).first_or_create do |network|
	  		network.update_attributes(social_network)
		end
	  end
	end

	def parse_relationship_info(user_id, social_network, provider)
		relationship_info = {
			user_id: user_id,
			relationship_id: social_network.user_id,
		 	nickname: social_network.nickname,
			picture: social_network.image,
			email: social_network.email,
		}
		case provider
		when "facebook"
			relationship_info[:fb_connected]= true
		when "twitter"
			relationship_info[:tw_connected]= true
		when "google_oauth2"
			relationship_info[:gg_connected]= true
		end
		return relationship_info
	end
end