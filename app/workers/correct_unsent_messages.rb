class CorrectUnsentMessages
	include Sidekiq::Worker
	sidekiq_options :retry => 5
  	include Sidetiq::Schedulable
  	sidekiq_options queue: 'messages_distribution'

  	def perform(message_id)
  	@message = Message.find_by(id: message_id)

	  	if @message.present? and @message.persisted?
		  	@message.update_attributes(message_sent: true)
	  	end
	  	  
  	end  
end