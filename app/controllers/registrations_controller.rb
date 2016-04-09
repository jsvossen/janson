class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    if @user.persisted?
    	init_name = @user.email.slice(0..(@user.email.index("@")-1)).capitalize
    	profile = @user.create_profile(name: init_name)
      UserMailer.welcome_mailer(@user).deliver_later
    end
  end

  def update
    super
  end


  protected

	  def after_sign_up_path_for(resource)
	    '/profile/edit' # Or :prefix_to_your_route
	  end

end 