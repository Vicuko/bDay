class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	layout "users"

	def index
		@user_active_networks = get_user_active_networks(current_user)
	end

	def create
		name = relationship_params[:nickname].split[0] || ""
      	sirname = relationship_params[:nickname].split[1..-1].join(" ") || "" 
      	email = relationship_params[:email]
      	id = User.persona_find_or_create(nil, email, name, sirname)

      	if Relationship.relationship_exists?(current_user.id,id)
      		flash[:alert] = "Ya tenías a este contacto"
      		render relationships_path

      	else
      		rel = relationship_params.clone
      		rel[:user_id]=current_user.id
      		rel[:relationship_id]=id
          rel=clean_date(rel)
      		rel_id = Relationship.find_or_create(rel)
      		if Message.create(relationship_id: rel_id)
       			redirect_to relationships_path
      		else
      			flash[:alert] = "Oops, there was a problem creating your contact. Please try again."
      			render new_relationship
      		end
      	end
	end

	def new
		@relationship = Relationship.new
	end

	def update
		update_successful = true
		form_for_relationship_params[:relationships_attributes].each do |relationship|
			relationship[1]=clean_date(relationship[1])
			if not rel_find_by_id(relationship).update(rel_update_params(relationship)) or not msge(relationship).update(msge_update_params(relationship))
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
      params.require(:relationship).permit(:nickname, :email, :send_date)


    end


    def clean_date(relationship)
      year = relationship.delete("send_date(1i)").to_i || Date.today.year
      month = relationship.delete("send_date(2i)").to_i || Date.today.month
      day = relationship.delete("send_date(3i)").to_i || Date.today.day
      relationship[:send_date]=Date.new(year, month, day)

      return relationship
    end


    def form_for_relationship_params
    	params.require(:user).permit(relationships_attributes: [:id, :nickname, :email, :"send_date(1i)", :"send_date(2i)", :"send_date(3i)", messages_attributes: [:message, :send_email, :send_fb, :send_tw, :send_gg, :id]])
    end

    def rel_find_by_id(relationship)
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
