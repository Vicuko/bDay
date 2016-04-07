class AutomaticallyDeliverUserMessages
	
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	sidekiq_options queue: 'messages_distribution'

# include Sidetiq::Schedulable
  # recurrence backfill:true do
  # 	# hourly.minute_of_hour(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60)
  # end

  def perform(user_id)
  	@user = User.find_by("id=?", user_id)
  	if @user.persisted?
  		@relationships=@user.relationships.where("send_message=? AND send_date<=?", true, Date.today).order(updated_at: :desc)

	  	if @relationships.present?

		  	@relationships.each do |relationship|
		  		message = relationship.messages.where("message_sent=?",false).order(updated_at: :desc)
		  	
		  		if message.present? and relationship.user_id.present? and relationship.relationship_id.present?

			  		if message.size > 1
			  			correct_messages(message[1..-1])
			  			message=message[0]
			  		else
			  			message=message[0]
			  		end

			  		DeliverMessage.perform_async(relationship.id, message.id)
						  	
				end
		  	end
	  	end  
	 end
  end

private

  def correct_messages(messages)
  	messages.each do |message|
  		CorrectUnsentMessages.perform_async(message.id)
  	end
  end

end
