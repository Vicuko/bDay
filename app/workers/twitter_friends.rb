require 'oauth'
class TwitterFriends

	include Sidekiq::Worker
	sidekiq_options :retry => false
  	sidekiq_options queue: 'default'


  def perform(user_id)
  	@user = User.find(user_id)
  	@twitter_info = @user.social_networks.find_by("provider=?","twitter")
	if @twitter_info.present?
		# All requests will be sent to this server.
		baseurl = "https://api.twitter.com"

		# Verify credentials returns the current user in the body of the response.
		address = URI("#{baseurl}/1.1/friends/ids.json")

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
		ids = parse_ids_response(response)

		#Once we get the ids, we call on the jobs for retrieving the information for the ids. Depending on the amount of ids, we may have to call more than once
		if ids.present? and @user.persisted?
			distribute_ids(ids)
		end
	end

  end

private

	def parse_ids_response(response)
	  # Parse a response from the API and return a user object.
	  ids = nil
	  # Check for a successful request
	  if response.code == '200'
	    
	    if JSON(response.body)["ids"].present?
			ids = JSON(response.body)["ids"]
		    puts "Friend list retrieved correctly"
		else
			raise "The user doesn't have any friends"
		end

	  else
	    # There was an error issuing the request.
	    puts "Expected a response of 200 but got #{response.code} instead for retrieving Twitter friends"
	  end
	  return ids
	end
  
  	def distribute_ids(ids)
	  	if ids.size > 100
			TwitterFriendsInfos.perform_async(@user.id,ids[0..99])
			distribute_ids(ids[100..-1])
		elsif 1 < ids.size <= 100
			TwitterFriendsInfos.perform_async(@user.id,ids[0..-1])
		elsif ids.size = 1
			TwitterFriendsInfo.perform_async(@user.id,ids)
		else
			raise "There aren't any friends left "
		end
  	end
end