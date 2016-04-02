class SaveSentMessage

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(message_info, provider)
  	@message = Message.find_by(id: message_info["id"])
 	
 	if provider.present? and @message.persisted?	
	  	case provider
	  	when "facebook"
	  		if @message.update_attributes(fb_sent_message: message_info["message"])
	  			puts "facebook message saved correctly in Message"
	  		else
	  			puts "There was some problem saving the facebook message"
	  		end
	  	when "twitter"
	  		if @message.update_attributes(tw_sent_message: message_info["message"])
	  			puts "twitter message saved correctly in Message"
	  		else
	  			puts "There was some problem saving the facebook message"
	  		end
	  	when "google_oauth2"
	  		if @message.update_attributes(gg_sent_message: message_info["message"])
	  			puts "google message saved correctly in Message"
	  		else
	  			puts "There was some problem saving the facebook message"
	  		end
	  	end
	else
		raise "No provider specified when saving the message"
	end
  end	  
end