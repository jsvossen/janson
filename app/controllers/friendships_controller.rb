class FriendshipsController < ApplicationController

	before_action :authenticate_user!

	def create
		fid = params[:friendship][:friend_id]
		@friend_req = current_user.friendships.build(friend_id: fid, status: "requested")
		@notification = Friendship.new(user_id: fid, friend_id: current_user.id, status: "pending")
		if @friend_req.save && @notification.save
			friend = @friend_req.friend
			flash[:success] = "A friend request has been sent to #{friend.name}!"
			redirect_to friend
		else
			errors = @friend_req.errors.full_messages + @notification.errors.full_messages
			flash[:danger] = "#{errors.uniq.join('. ')}."
			redirect_to :back
		end
	end

	def update
		friendship = Friendship.find(params[:id])
		reciprocal = Friendship.find_by(friend_id: friendship.user_id)
		if friendship.update_attributes(status: "accepted") && reciprocal.update_attributes(status: "accepted")
			friend = friendship.friend
			flash[:success] = "You are now friends with #{friend.name}!"
			redirect_to friend
		else
			errors = @friend_req.errors.full_messages + @notification.errors.full_messages
			flash[:danger] = "#{errors.uniq.join('. ')}."
			redirect_to :back
		end
	end

	def destroy
		friendship = Friendship.find(params[:id])
		reciprocal = Friendship.find_by(friend_id: friendship.user_id)
		friendship.destroy
		reciprocal.destroy
		if friendship.status == "requested"
			flash[:success] = "Friend request cancelled."
		elsif friendship.status == "pending"
			flash[:success] = "Friend request declined."
		else
			flash[:success] = "You are no longer friends with #{User.find(friendship.friend_id)}."
		end
		redirect_to :back
	end

	private

		def friendship_params
			params.require(:friendship).permit(:user_id, :friend_id)
		end

end
