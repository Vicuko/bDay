class ParseTwitterMessage
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	sidekiq_options queue: 'messages_distribution'

  def perform(relationship_info, message_info)
  	@relationship = parse_relationship_info(relationship_info)
  	@social_network = parse_social_network_info(@relationship[:relationship_id])
  	if @social_network[:nickname].present? and message_info["message"].present?
	
	  	@message = parse_message_info(message_info, @social_network)
	  	if @message[:characters_count]<40
			SendTwitterMessage.perform_async(@relationship[:user_id], @message)
			# Cuando genere el mensaje con open graph, no debería hacer falta hacer la validación de 40 caracteres aquí
		end
	
	end
  end

private
	
	def parse_relationship_info (relationship_info)
		info = {
			user_id: relationship_info["user_id"] || "",
			relationship_id: relationship_info["relationship_id"] || "",
			nickname: relationship_info["nickname"] || ""
		}
		return info
	end


	def parse_social_network_info (receiver_id)
		social_network = SocialNetwork.find_by(user_id: receiver_id)
		info = {
			nickname: social_network.nickname || "",
			uid: social_network.uid || ""
		}
		return info
	end


	def parse_message_info (message_info, social_network)
		
		info = {
			id: message_info["id"] || "",
			message_url: message_info["message_url"] || "",
			characters_count: (message_info["message"].size + social_network[:nickname].size + 2)
		}
		
		if info[:characters_count] <140
			info[:message] = "@#{social_network[:nickname]} #{message_info['message']}"
		else
			info[:message] = message_info['message']
			# Aquí debería montar un mensaje para mandarlo en open graph :D
		end
		return info
		
	end
end
