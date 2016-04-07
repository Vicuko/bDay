class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	layout "users"

	# def index
	# 	@user_active_networks = get_user_active_networks(current_user)
	# end

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
       			redirect_to user_index_path
      		else
      			flash[:alert] = "Oops, there was a problem creating your contact. Please try again."
      			render nothing: true
      		end
      	end
	end

	# def new
	# 	@relationship = Relationship.new
	# end

	def update
		update_successful = true
		[form_for_relationship_params].each do |relationship|
      relationship=clean_date(relationship)
			if not rel_find_by_id(form_for_relationship_id).update(rel_update_params(relationship)) or not msge(form_for_relationship_message_id).update(msge_update_params(relationship))
				update_successful = false
			end
		end
		
		if update_successful
			flash[:notice] = "Se ha guardado la información correctamente"
			redirect_to user_index_path
		else
			flash[:alert] = "Ups, ha habido algún problema al guardar la información"
      redirect_to user_index_path
		end
	end

  def destroy
    relationship = Relationship.find_by("id=?",params[:relationship_id])
    if relationship.persisted?
      relationship.destroy
      redirect_to user_index_path
    else
      flash[:alert] = "Ups, ha habido algún problema al guardar la información"
      redirect_to user_index_path
    end
  end

  def message_now
    relationship = Relationship.find_by("id=?",params[:relationship_id])
    message = Message.find_by("id=?",params[:message_id])
    if message.persisted? and relationship.persisted?
      if message.send_email or message.send_fb or message.send_tw or message.send_gg
        DeliverMessage.perform_async(relationship.id, message.id)
        flash[:notice] = "Se ha enviado tu mensaje correctamente"
        redirect_to user_index_path
      else
        flash[:alert] = "Tienes que seleccionar un método de envío para poder mandar el mensaje"
        redirect_to user_index_path
      end
    else
        flash[:alert] = "Ups, ha habido algún problema al guardar la información"
        redirect_to user_index_path
    end

  end
	
private

    def relationship_params
      params.require(:relationship).permit(:nickname, :email, :send_date)
    end

    def form_for_relationship_params
      params.require(:relationship).permit(:id, :nickname, :email, :"send_date(1i)", :"send_date(2i)", :"send_date(3i)", :send_message, messages_attributes: [:message, :send_email, :send_fb, :send_tw, :send_gg, :id])
    end

    def form_for_relationship_id
      params.require(:relationship_id)
    end

    def form_for_relationship_message_id
      params.require(:message_id)
    end

    
    def clean_date(relationship)
      year = relationship.delete("send_date(1i)").to_i || Date.today.year
      month = relationship.delete("send_date(2i)").to_i || Date.today.month
      day = relationship.delete("send_date(3i)").to_i || Date.today.day
      relationship[:send_date]=Date.new(year, month, day)

      return relationship
    end


    def rel_find_by_id(relationship_id)
    	Relationship.find_by("id=?",relationship_id)
    end

    def rel_update_params(relationship)
    	rel = relationship.clone
    	rel.delete("id")
    	rel.delete("messages_attributes")
    	return rel
    end

    def msge(message_id)
      binding.pry
		  Message.find_by("id=?", message_id)
    end

    def msge_update_params(relationship)
    	rel = relationship.clone
    	rel[:messages_attributes].values.each do |value|
        value.delete("id")
        if value.present?
          message = value
          return message
        end
      end
    end




 #    def get_user_active_networks(user)
 #    	networks = existing_networks
 #    	user_networks = get_user_networks (user)
 #    	networks.each do |network,value|
 #    		if user_networks.include?(network.to_s)
 #    			networks[network]=true    		
 #    		end
	# 	  end
 #      return networks
	#   end

	# def existing_networks
	# 	{facebook: false, twitter: false, google_oauth2: false}
	# end

	# def get_user_networks (user)
	# 	networks = []
	# 	user.social_networks.select("provider").each do |network|
	# 		networks << network.provider
	# 	end
	# 	return networks
	# end

end	
