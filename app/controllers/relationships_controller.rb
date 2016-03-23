class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	layout "users"

	def index
		@relationships = get_user_relationships(current_user)
		@messages = get_user_messages(@relationships)
		@user_active_networks = get_user_active_networks(current_user)
	end

	# def create
	# end

	# def new
	# end

	def update
		binding.pry
	end
	
private
	def relationship_params
      params.require(:relationship).permit(:name, :surname, :email, :bday, :city, :country, :language, :gender)
    end

    def get_user_relationships(user)
    	Relationship.where("user_id=?",user.id)
    end

    def get_user_active_networks(user)
    	networks = existing_networks
    	user_networks = get_user_networks (user)
    	networks.each do |network,value|
    		if user_networks.include?(network.to_s)
    			networks[network]=true    		
    		end
    	return networks
		end
	end

	def get_user_networks (user)
		networks = []
		user.social_networks.select("provider").each do |network|
			networks << network.provider
		end
		return networks
	end

	def existing_networks
		{facebook: false, twitter: false, google_oauth2: false}
	end

	def get_user_messages(relationships)
		messages = []
		relationships.each do |relationship|
			messages << get_last_message(relationship)
		end
		return messages
	end

	def get_last_message(relationship)
		message = relationship.messages.last || Message.new
		message.message_sent ? message : Message.new
	end

	
end	
