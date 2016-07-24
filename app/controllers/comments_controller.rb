class CommentsController < ApplicationController

	before_action :authenticate_user!
	before_action :correct_user, only: :destroy

	def create
		@comment = current_user.comments.build(comment_params)
		if @comment.save
			@comment.notifications.create(user: @comment.post.user) if @comment.post.user != @comment.user
			respond_to do |format|
				format.html {
					flash[:success] = "Comment added!"
					redirect_to_back_or_default
				}
				format.js
			end
		else
			flash.now[:danger] = "Error: #{@comment.errors.full_messages.join('. ')}."
			@post = @comment.post
			@comments = @comment.post.comments.paginate(page: params[:page]).order_desc
			render "posts/show"
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		respond_to do |format|
			format.html {
				flash[:success] = "Comment deleted."
				redirect_to_back_or_default
			}
			format.js
		end
	end

	private

		def comment_params
			params.require(:comment).permit(:post_id, :user_id, :body)
		end

		# comment author and post author can delete comments
		def correct_user
			@comment = Comment.find(params[:id])
			unless current_user == @comment.post.user
				@comment = current_user.comments.find_by(id: params[:id])
				redirect_to root_path if @comment.nil?
			end
		end

end
