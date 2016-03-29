class DeliverMessagesJob
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	include Sidetiq::Schedulable
  	sidekiq_options queue: 'messages_distribution'

  # recurrence backfill:true do
  # 	# hourly.minute_of_hour(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60)
  # end

  def perform()
  	@relationships=Relationship.where("send_message=? AND send_date<=?", true, Date.today).order(updated_at: :desc)

  	if @relationships.present?

	  	@relationships.each do |relationship|
	  		@message = relationship.messages.where("message_sent=?",false)
	  		
	  		if @message.size > 1
	  			correct_messages(@message[1..-1])
	  			@message=@message[0]
	  		else
	  			@message=@message[0]
	  		end

	  		if 	relationship.send_message
	  			send_mail(relationship, @message)
	  		end

	  		if relationship.send_message and relationship.fb_connected
	  			send_facebook_message(relationship.attributes)
	  		end
	  		
	  		if relationship.send_message and relationship.tw_connected
	  			send_twitter_message(relationship.attributes)
	  		end

	  		if relationship.send_message and relationship.gg_connected
	  			send_google_message(relationship.attributes)
	  		end

	  		if @message.present?
	  			update_message_status(@message)
	  		end
	  	end
  	end  

  end


private

  def send_mail(relationship, message)
	RelationshipMailer.message_email(relationship,message).deliver_later 
  end


  def send_facebook_message(relationship)
  	print "Facebook"

  end

  def send_twitter_message(relationship)

  	print "Twitter"
  end

  def send_google_message(relationship)

  	print "Google"
  end

  def update_message_status(message)
	  message.update(message_sent: true)
	  rescue ActiveRecord::RecordNotFound || ActiveRecord::NoMethodError
  end

  def correct_messages(messages)

  end
end
