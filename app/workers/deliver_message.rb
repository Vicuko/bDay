class DeliverMessage
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	sidekiq_options queue: 'messages_distribution'

  def perform(relationship_id, message_id)
  	@relationship=Relationship.find_by(id: relationship_id)
  	@message = Message.find_by(id: message_id)

  	if @relationship.persisted? and @message.persisted?

		if 	@relationship.send_message

			if @relationship.email.present? and @message.send_email
				send_mail(@relationship.attributes, @message.attributes)
			end

			if @relationship.fb_connected and @message.send_fb
				send_facebook_message(@relationship.attributes, @message.attributes)
			end
		
			if @relationship.tw_connected and @message.send_tw
				send_twitter_message(@relationship.attributes, @message.attributes)
			end

			if @relationship.gg_connected and @message.send_gg
				send_google_message(@relationship.attributes, @message.attributes)
			end

			if @message.persisted?
				update_message_status(@message)
				create_new_message(@relationship)
			end
		end
	end
  end

private

  def send_mail(relationship, message)
	ParseEmailMessage.perform_async(relationship, message)
  end

  def send_facebook_message(relationship, message)
  	ParseFacebookMessage.perform_async(relationship, message)
  end

  def send_twitter_message(relationship, message)
  	ParseTwitterMessage.perform_async(relationship, message)
  end

  def send_google_message(relationship, message)
	ParseGoogleMessage.perform_async(relationship, message)
  end

  def update_message_status(message)
	  @message.update(message_sent: true)
	  rescue ActiveRecord::RecordNotFound || ActiveRecord::NoMethodError
  end

  def create_new_message(relationship)
  	  Message.create(relationship_id: relationship.id)
  end

end
