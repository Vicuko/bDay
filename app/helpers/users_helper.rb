module UsersHelper
	def user_sign_up(id)
		User.where("id=?","id").update_attributes(signed_up: true)
	end

	def user_unsign_up
		current_user.update_attributes(signed_up: false, encrypted_password:"")
	end

	def user_signed_up?(email)
		User.find_by("email=?","email").where("signed_up=?",true).present?
		rescue ActiveRecord::RecordNotFound
	    	return false
	end
end
