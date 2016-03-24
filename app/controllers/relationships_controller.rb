class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	layout "users"

	def index
		@user_active_networks = get_user_active_networks(current_user)
	end

	# def create
	# end

	# def new
	# end

	def update
		update_successful = true
		form_for_relationship_params[:relationships_attributes].each do |relationship|
			
			if not rel(relationship).update(rel_update_params(relationship)) or not msge(relationship).update(msge_update_params(relationship))
				update_successful = false
			end
		end
		
		if update_successful
			flash[:notice] = "Se ha guardado la información correctamente"
			redirect_to "index"
		else
			flash[:alert] = "Oops, ha habido algún problema al guardar la información"
		end
	end
	
private

	def relationship_params
      params.require(:relationship).permit(:name, :surname, :email, :bday, :city, :country, :language, :gender)
    end




    def form_for_relationship_params
    	params.require(:user).permit(relationships_attributes: [:id, :nickname, :email, messages_attributes: [:message, :send_email, :send_fb, :send_tw, :send_gg, :id]])
    end

    def rel(relationship)
    	Relationship.find(relationship[1][:id])
    end

    def rel_update_params(relationship)
    	rel = relationship[1].clone
    	rel.delete("id")
    	rel.delete("messages_attributes")
    	return rel
    end

    def msge(relationship)
		Message.find(relationship[1][:messages_attributes].values[0][:id])
    end

    def msge_update_params(relationship)
    	rel = relationship[1].clone
    	message = rel[:messages_attributes].values[0]
    	message.delete("id")
    	return message
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

	def existing_networks
		{facebook: false, twitter: false, google_oauth2: false}
	end

	def get_user_networks (user)
		networks = []
		user.social_networks.select("provider").each do |network|
			networks << network.provider
		end
		return networks
	end



end	
