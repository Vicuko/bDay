class User < ActiveRecord::Base
  has_many :relationships_association, :class_name => "Relationship"
  has_many :relationships, :through => :relationships_association, :source => :relationship
  has_many :inverse_relationships_association, :class_name => "Relationship", :foreign_key => "relationship_id"
  has_many :inverse_relationships, :through => :inverse_relationships_association, :source => :user
  has_many :social_networks, inverse_of: :user
  has_many :inverse_social_networks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :google, :gplus]  


  def self.persona_mail_exists?(email)
    User.find_by!(email: email).present?
    rescue ActiveRecord::RecordNotFound
      return false
  end

  def self.persona_signed_up?(email)
    User.find_by!(email: email).encrypted_password.present?
    rescue ActiveRecord::RecordNotFound
      return false
  end

  def self.what_persona_id?(email)
    User.find_by(email: email).id
  end

  def self.persona_find_or_create(auth)
    if SocialNetwork.social_network_uid_exists?(auth.uid)
      SocialNetwork.what_social_network_user_id?(auth.uid)
    else
      User.find_or_create_by(email: auth.info.email).id do |nuser|
        nuser.name = auth.info.first_name
        nuser.surname = auth.info.last_name
      end
    end
  end

end
