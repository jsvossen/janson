class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @request = User.from_omniauth(request.env["omniauth.auth"])
    @user = @request[:user]

    if @user.persisted?
      if @request[:new_user]
        sign_in @user
        flash[:success] = "Welcome! You have signed up successfully through Facebook. Complete your profile below:"
        redirect_to edit_profile_path
      else
        sign_in_and_redirect @user #, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end