class ParseEmailMessage
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	sidekiq_options queue: 'messages_distribution'

  def perform(relationship_info, message_info)
  	@sender = parse_sender_info(relationship_info)
  	@relationship = parse_relationship_info(relationship_info)
  	@message = parse_message_info(message_info)
	RelationshipMailer.message_email(@sender, @relationship, @message).deliver_later
  end

private
	
	def parse_sender_info (relationship_info)
		persona = User.find_by(id: relationship_info["user_id"])
		info = {
			name: persona.name || "",
			surname: persona.surname || "",
			language: persona.language || "",
			email: persona.email || ""
		}
		return info
	end

	def parse_relationship_info (relationship_info)
		info = {
			email: relationship_info["email"] || "",
			nickname: relationship_info["nickname"] || "",
			picture: relationship_info["picture"] || ""
		}
		return info
	end

	def parse_message_info (message_info)
		info = {
			message: message_info["message"] || "",
			message_url: message_info["message_url"] || ""
		}
		return info
	end
end
