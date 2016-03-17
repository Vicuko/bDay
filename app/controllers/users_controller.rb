class UsersController < ApplicationController
before_action :authenticate_user!

	def show
		render "show"
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

end
