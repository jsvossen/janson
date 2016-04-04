class PostsController < ApplicationController

	before_action :authenticate_user!

	def index
		@posts = Post.all
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Post created!"
			redirect_to :back
		else
			flash.now[:danger] = "Error: #{@post.errors.full_messages.join('. ')}."
			render "posts/index"
		end
	end

	def destroy
		Post.find(params[:id]).delete
		flash[:success] = "Post deleted."
		redirect_to :back
	end

	private

		def post_params
			params.require(:post).permit(:user_id, :body)
		end

end
