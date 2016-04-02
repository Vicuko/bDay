class TwitterFriendsInfos

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(user_id, ids)
  	@user = User.find(user_id)
  	@provider = "twitter"
  	@twitter_info = @user.social_networks.find_by("provider=?",@provider)
  	if @twitter_info.present?
		# All requests will be sent to this server.
		baseurl = "https://api.twitter.com"
		path = "/1.1/users/lookup.json"
		query = URI.encode_www_form("user_id"=>"#{ids.join(',')}")
		# Verify credentials returns the current user in the body of the response.
		address = URI("#{baseurl}#{path}?#{query}")

		# Set up HTTP.
		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		consumer_key ||= OAuth::Consumer.new ENV['tw_key'], ENV['tw_secret']
		access_token ||= OAuth::Token.new @twitter_info.token, @twitter_info.secret

		# Issue the request.
		request = Net::HTTP::Get.new address.request_uri
		request.oauth! http, consumer_key, access_token
		
		http.start
		response = http.request request

		info = parse_response_info(response)
		if info.present? and @user.persisted?
			info.each do |content|
				generate_social_network(content)
			end
		end
	end
  end

private

	def parse_response_info(response)
		# Parse a response from the API and return a user object.
	  friends = nil
	  parsed_group = []
	  parsed_friends = []
	  parsed_persona = []
	  # Check for a successful request
	  if response.code == '200'
	  	friends = JSON(response.body)
	  	friends.each_with_index do |friend,index|
	    	parsed_friends[index]={
	    		nickname: friend["screen_name"] || "",
	    		uid: friend["id"],
	    		token: "",
	    		secret: "",
	    		expiry_date: "",
	    		expires: true,
	    		email: "",
	    		password: "",
	    		image: friend["profile_image_url_https"] || "",
	    		verified: friend["verified"] || "",
	    		timezone: friend["utc_offset"] ? friend["utc_offset"]/3600 : 0,
	    		language: friend["lang"] || "es"
	    	}

	    	parsed_persona[index]={
	    		name: friend["name"].split[0] || "",
	    		surname: friend["name"].split[1..-1].join(" ") || "",
	    		city: friend["location"],
	    		language: friend["lang"] || "es"
	    	}

	    	parsed_group[index] = parsed_friends[index],parsed_persona[index]
		end
		puts "Friend list parsed correctly"

	  else
	    # There was an error issuing the request.
	    puts "Expected a response of 200 but got #{response.code} instead for retrieving Twitter friends"
	  end

	  return parsed_group

	end


	def generate_social_network(content)
		SocialNetworkFindOrCreate.perform_async(@user.id,content[0],content[1],@provider)
	end
end