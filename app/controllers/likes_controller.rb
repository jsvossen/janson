class LikesController < ApplicationController

	before_action :authenticate_user!

	def create
		@like = current_user.likes.build(like_params)
		if @like.save
			@like.notifications.create(user: @like.post.user) if @like.user != @like.post.user
			
			respond_to do |format|
				format.html { 
					flash[:success] = "Post liked!"
					redirect_to_back_or_default
				}
				format.js
			end
		else
			respond_to do |format|
				format.html { 
					flash[:danger] = "Error: #{@like.errors.full_messages.join('. ')}."
					redirect_to_back_or_default 
				}
				format.js
			end
		end
	end

	def destroy
		@like = current_user.likes.find_by(id: params[:id])
		@like.destroy
		respond_to do |format|
			format.html { 
				flash[:success] = "Post unliked."
				redirect_to_back_or_default 
			}
			format.js
		end
	end

	private

		def like_params
			params.require(:like).permit(:user_id, :post_id)
		end

end
