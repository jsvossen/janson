class PostsController < ApplicationController

	before_action :authenticate_user!
	before_action :correct_user, only: :destroy

	def index
		@post = current_user.posts.build
		@posts = current_user.news_feed.paginate(page: params[:page])
	end

	def show
		@post = Post.find(params[:id])
		@comments = @post.comments.paginate(page: params[:page]).order_desc
	end

	def create
		@posts = current_user.news_feed.paginate(page: params[:page])
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Post created!"
			redirect_to_back_or_default
		else
			flash.now[:danger] = "Error: #{@post.errors.full_messages.join('. ')}."
			render "posts/index"
		end
	end

	def destroy
		Post.find(params[:id]).delete
		flash[:success] = "Post deleted."
		redirect_to_back_or_default
	end

	private

		def post_params
			params.require(:post).permit(:body, :picture)
		end

		def correct_user
			@post = current_user.posts.find_by(id: params[:id])
			redirect_to root_path if @post.nil?
		end

end
