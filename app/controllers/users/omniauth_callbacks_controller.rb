class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env["omniauth.auth"]
    if user_signed_in?
      id = current_user.id
    else
      name = auth.info.first_name || auth.info.name.split[0] || ""
      sirname = auth.info.last_name || auth.info.name.split[1..-1].join(" ") || "" 
      id = User.persona_find_or_create(auth.uid,auth.info.email,name, sirname)
    end

    @user = SocialNetwork.from_omniauth_fb(id,auth)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to show_user_registration_path
    end
  end

  def twitter
    auth = request.env["omniauth.auth"]
    if user_signed_in?
      id = current_user.id
    else
      name = auth.info.first_name || auth.info.name.split[0] || ""
      sirname = auth.info.last_name || auth.info.name.split[1..-1].join(" ") || "" 
      id = User.persona_find_or_create(auth.uid,auth.info.email,name, sirname)
    end

    @user = SocialNetwork.from_omniauth_tw(id,auth)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to show_user_registration_path
    end
  end

  def google_oauth2
    auth = request.env["omniauth.auth"]
    if user_signed_in?
      id = current_user.id
    else
      name = auth.info.first_name || auth.info.name.split[0] || ""
      sirname = auth.info.last_name || auth.info.name.split[1..-1].join(" ") || "" 
      id = User.persona_find_or_create(auth.uid,auth.info.email,name, sirname)
    end

    @user = SocialNetwork.from_omniauth_gg(id,auth)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "google_oauth2") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to show_user_registration_path
    end
  end

  def failure
    redirect_to root_path
  end

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

end
