class FriendshipsController < ApplicationController

	before_action :authenticate_user!
	before_action :correct_user, only: :destroy
	before_action :invited_user, only: :update

	def create
		fid = params[:friendship][:friend_id]
		@friend_req = current_user.friendships.build(friend_id: fid, status: "requested")
		@notify = Friendship.new(user_id: fid, friend_id: current_user.id, status: "pending")
		if @friend_req.save && @notify.save
			friend = @friend_req.friend
			@notify.notifications.create(user_id: fid)
			flash[:success] = "A friend request has been sent to #{friend.name}!"
			redirect_to friend
		else
			errors = @friend_req.errors.full_messages + @notify.errors.full_messages
			flash[:danger] = "#{errors.uniq.join('. ')}."
			redirect_to_back_or_default
		end
	end

	def update
		friendship = Friendship.find(params[:id])
		reciprocal = Friendship.find_by(user_id: friendship.friend_id, friend_id: friendship.user_id)
		if friendship.update_attributes(status: "accepted") && reciprocal.update_attributes(status: "accepted")
			Notification.find_by(notifiable: friendship).destroy
			reciprocal.notifications.create(user_id: reciprocal.user_id)
			friend = friendship.friend
			flash[:success] = "You are now friends with #{friend.name}!"
			redirect_to friend
		else
			errors = @friend_req.errors.full_messages + @notification.errors.full_messages
			flash[:danger] = "#{errors.uniq.join('. ')}."
			redirect_to_back_or_default
		end
	end

	def destroy
		friendship = Friendship.find(params[:id])
		reciprocal = Friendship.find_by(user_id: friendship.friend_id, friend_id: friendship.user_id)
		friendship.destroy
		reciprocal.destroy
		if friendship.status == "requested"
			flash[:success] = "Friend request cancelled."
		elsif friendship.status == "pending"
			flash[:success] = "Friend request declined."
		else
			flash[:success] = "You are no longer friends with #{User.find(friendship.friend_id).name}."
		end
		redirect_to_back_or_default
	end

	private

		def friendship_params
			params.require(:friendship).permit(:user_id, :friend_id)
		end

		# only friendship members can delete friendship
		def correct_user
			@friendship = current_user.friendships.find_by(id: params[:id])
			redirect_to root_path if @friendship.nil?
		end

		# only invited user can accept friendship
		def invited_user
			@friendship = current_user.friendships.find_by(id: params[:id])
			redirect_to root_path unless @friendship && @friendship.status == "pending"
		end
end
