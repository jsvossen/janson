class LikesController < ApplicationController

	before_action :authenticate_user!

	def create
		@like = current_user.likes.build(like_params)
		if @like.save
			@like.notifications.create(user: @like.post.user) if @like.user != @like.post.user
			flash[:success] = "Post liked!"
			redirect_to_back_or_default
		else
			flash[:danger] = "Error: #{@like.errors.full_messages.join('. ')}."
			redirect_to_back_or_default
		end
	end

	def destroy
		current_user.likes.find_by(id: params[:id]).destroy
		flash[:success] = "Post unliked."
		redirect_to_back_or_default
	end

	private

		def like_params
			params.require(:like).permit(:user_id, :post_id)
		end

end
