class UsersController < ApplicationController
before_action :authenticate_user!

	def index
		@user_active_networks = get_user_active_networks(current_user)
		@relationship = Relationship.new
	end

	def edit
		
	end

	def update
	      if current_user.update_attributes(user_params)
	        redirect_to action: 'show', notice: 'User was successfully updated.'
	      else
	        render :edit, notice: 'User could not be updated'
	      end
	end

private
	def user_params
      params.require(:user).permit(:name, :surname, :email, :bday, :city, :country, :language, :gender)
    end

    def get_user_active_networks(user)
    	networks = existing_networks
    	user_networks = get_user_networks (user)
    	networks.each do |network,value|
    		if user_networks.include?(network.to_s)
    			networks[network]=true    		
    		end
		  end
      return networks
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
