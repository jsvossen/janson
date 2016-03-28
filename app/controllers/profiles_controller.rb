class ProfilesController < ApplicationController

	before_action :authenticate_user!

	def edit
		@profile = current_user.profile
	end

	def update
		@profile = current_user.profile
		if @profile.update_attributes(profile_attributes)
			flash[:success] = "Profile successfully updated!"
			redirect_to root_path
		else
			flash.now[:danger] = "Error: #{@profile.errors.full_messages.join('. ')}."
			render :edit
		end
	end

	private

		def profile_attributes
			params.require(:profile).permit(:name, :birthday, :location, :about)
		end
end
