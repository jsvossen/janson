class FriendshipsController < ApplicationController

	before_action :authenticate_user!

	def create
		fid = params[:friendship][:friend_id]
		@friend_req = current_user.friendships.build(friend_id: fid, status: "requested")
		@notification = Friendship.new(user_id: fid, friend_id: current_user.id, status: "pending")
		if @friend_req.save && @notification.save
			friend = User.find(fid)
			flash[:success] = "A friend request has been sent to #{friend.name}!"
			redirect_to User.find(friend)
		else
			errors = @friend_req.errors.full_messages + @notification.errors.full_messages
			flash[:danger] = "#{errors.uniq.join('. ')}."
			redirect_to User.where(id: fid).any? ? User.find(fid) : root_path
		end
	end

	def update
	end

	def destroy
	end

	private

		def friendship_params
			params.require(:friendship).permit(:user_id, :friend_id)
		end

end
