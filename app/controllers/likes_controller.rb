class LikesController < ApplicationController

	before_action :authenticate_user!

	def create
		@like = current_user.likes.build(like_params)
		if @like.save
			flash[:success] = "Post liked!"
			redirect_to :back
		else
			flash[:danger] = "Error: #{@like.errors.full_messages.join('. ')}."
			redirect_to :back
		end
	end

	def destroy
		current_user.likes.find_by(id: params[:id]).delete
		flash[:success] = "Post unliked."
		redirect_to :back
	end

	private

		def like_params
			params.require(:like).permit(:user_id, :post_id)
		end

end