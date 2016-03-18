class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	before_action {render layout: "users"}
	def index
		@relationships = current_user.relationships
		@user_networks = user_available_networks(current_user)
	end

	def create
	end

	def new
	end

	def update
	end
	
private
	def relationship_params
      params.require(:relationship).permit(:name, :surname, :email, :bday, :city, :country, :language, :gender)
    end

    def user_available_networks(user)
    	networks = []
    	user.social_networks.select("provider").each do |network_object|
    		networks<<network_object.provider
    	return networks
    end
end
