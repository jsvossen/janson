class UsersController < ApplicationController

	before_action :authenticate_user!

	def index
		@users = User.paginate(page: params[:page]).by_name_asc
		@friend_req = current_user.friendships.build
	end

	def show
		@user = User.find(params[:id])
		@post = Post.new if @user == current_user
		@friend_req = current_user.friendships.build if @user != current_user
	end

	def friends
		@user = User.find(params[:user_id])
		@friends = @user.friends.accepted.paginate(page: params[:page]).by_name_asc
		if @user == current_user
			@sent_requests = @user.friends.requested.by_name_asc
			@pending_requests = @user.friends.pending.by_name_asc
		end
	end

end
