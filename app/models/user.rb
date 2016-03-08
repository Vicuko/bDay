class User < ActiveRecord::Base
  has_many :relationships_association, :class_name => "Relationship"
  has_many :relationships, :through => :relationships_association, :source => :relationship
  has_many :inverse_relationships_association, :class_name => "Relationship", :foreign_key => "relationship_id"
  has_many :inverse_relationships, :through => :inverse_relationships_association, :source => :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :google, :gplus]  

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    		user.email = auth.info.email
    		user.password = Devise.friendly_token[0,20]
    		user.name = auth.info.first_name
    		user.sirname = auth.info.last_name
    		   # assuming the user model has a name
    		user.image = auth.info.image # assuming the user model has an image
  		end
	end
end
