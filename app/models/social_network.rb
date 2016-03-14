class SocialNetwork < ActiveRecord::Base
	belongs_to :user, inverse_of: :social_networks

	def self.social_network_mail_exists?(email)
		SocialNetwork.find_by!(email: email).present?
    	rescue ActiveRecord::RecordNotFound
      		return false
	end

	def self.social_network_uid_exists?(uid)
		SocialNetwork.find_by!(uid: uid).present?
    	rescue ActiveRecord::RecordNotFound
      		return false
	end

	def self.what_social_network_user_id?(uid)
    	SocialNetwork.find_by(uid: uid).user_id
  	end

	def self.from_omniauth_fb(id,auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |persona|
	    		persona.user_id = id
	    		persona.token = auth.credentials.token || ""
	    		persona.expiry_date = auth.credentials.expires_at  || ""
	    		persona.expires = auth.credentials.expires  || ""
	    		persona.email = auth.info.email || ""
	    		persona.password = Devise.friendly_token[0,20] || ""
	    		persona.image = auth.info.image || ""
	    		persona.verified = auth.info.verified || ""
	    		gender = auth.extra.raw_info.gender || "u"
	    		persona.gender = gender[0]
	    		persona.timezone = auth.extra.raw_info.timezone || 0
	    		persona.language = auth.extra.raw_info.locale || "es"
			end
    	return User.find_by(id:id)
	end
	
	def self.from_omniauth_tw(id,auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |persona|
	    		persona.user_id = id
	    		persona.token = auth.credentials.token || ""
	    		persona.expiry_date = auth.credentials.expires_at  || ""
	    		persona.expires = auth.extra.access_token.params[:x_auth_expires]
	    		persona.email = auth.info.email || ""
	    		persona.password = Devise.friendly_token[0,20] || ""
	    		persona.image = auth.info.image || ""
	    		persona.verified = auth.extra.raw_info.verified || ""
	    		persona.timezone = auth.extra.raw_info.utc_offset/3600 || 0
	    		persona.language = auth.extra.raw_info.lang || "es"
			end
    	return User.find_by(id:id)
	end

	def self.from_omniauth_gg(id,auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |persona|
	    		persona.user_id = id
	    		persona.token = auth.credentials.token || ""
	    		persona.expiry_date = auth.credentials.expires_at  || ""
	    		persona.expires = auth.credentials.expires  || ""
	    		persona.email = auth.info.email || ""
	    		persona.password = Devise.friendly_token[0,20] || ""
	    		persona.image = auth.info.image || ""
	    		persona.verified = auth.extra.raw_info.email_verified || ""
	    		gender = auth.extra.raw_info.gender || "u"
	    		persona.gender = gender[0]
	    		persona.language = auth.extra.raw_info.locale || "es"
			end
    	return User.find_by(id:id)
	end
end