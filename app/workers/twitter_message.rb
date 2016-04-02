class TwitterMessage

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(user_id, message_info)
  	@user = User.find(user_id)
  	@message = Message.find(message_info["id"])
  	@provider = "twitter"
  	@twitter_info = @user.social_networks.find_by("provider=?",@provider)
  	if @twitter_info.present? and @message.send_tw
		# All requests will be sent to this server.
		baseurl = "https://api.twitter.com"
		path = "/1.1/statuses/update.json"
		address = URI("#{baseurl}#{path}")
		
		request = Net::HTTP::Post.new address.request_uri
		request.set_form_data(
  			"status" => "#{message_info["message"]}"
		)
		# Set up HTTP.
		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# Assign the required info.
		consumer_key ||= OAuth::Consumer.new ENV['tw_key'], ENV['tw_secret']
		access_token ||= OAuth::Token.new @twitter_info.token, @twitter_info.secret

		# Issue the request.
		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		sent_text = parse_response_info(response)
		
		if sent_text.present? and @message.persisted?
			SaveSentMessage.perform_async(message_info, @provider)
		end
	end
  end

private

	def parse_response_info(response)
		# Parse a response from the API and return a user object.
	  text = nil
	  # Check for a successful request
	  if response.code == '200'
	  	info = JSON(response.body)
	  	text = info["text"]
		puts "Text parsed correctly"
	  else
	    # There was an error issuing the request.
	    puts "Expected a response of 200 but got #{response.code} instead for retrieving Twitter friends"
	  end
	  return text
	end

	  
end