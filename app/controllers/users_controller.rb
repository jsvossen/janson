class UsersController < ApplicationController

	before_action :authenticate_user!

	def index
		@users = User.paginate(page: params[:page]).by_name_asc
		@friend_req = current_user.friendships.build
	end

	def show
		@user = User.find(params[:id])
	end

end
