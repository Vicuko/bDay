class ParseTwitterMessage
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	sidekiq_options queue: 'messages_distribution'

  def perform(relationship_info, message_info)
  	@relationship = parse_relationship_info(relationship_info)
  	@social_network = parse_social_network_info(@relationship["user_id"])
  	if @social_network["nickname"].present? and message_info["message"].present?
	  	@message = parse_message_info(message_info)
		SendTwitterMessage.perform_async(@relationship["user_id"], @message)
	end
  end

private
	
	def parse_social_network_info (user_id)
		social_network = SocialNetwork.find_by(user_id: user_id)
		info = {
			nickname: social_network.nickname || "",
			uid: social_network.uid || ""
		}
		return info
	end


	def parse_relationship_info (relationship_info)
		info = {
			user_id: relationship_info["user_id"] || "",
			nickname: relationship_info["nickname"] || ""
		}
		return info
	end

	def parse_message_info (message_info)
		info = {
			id: message_info["id"] || "",
			message_url: message_info["message_url"] || ""
		}
		if message_info["message"],
		return info
	end
end
