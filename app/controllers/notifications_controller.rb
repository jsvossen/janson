class NotificationsController < ApplicationController

	before_action :authenticate_user!
	before_action :correct_user, only: :destroy

	def index
		@notifications = current_user.notifications
	end

	def destroy
		Notification.find(params[:id]).destroy
		flash[:success] = "Notification dismissed."
		redirect_to_back_or_default
	end

	private

		def correct_user
			@note = current_user.notifications.find_by(id: params[:id])
			redirect_to root_path if @note.nil?
		end

end
