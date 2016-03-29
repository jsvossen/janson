require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:michael)
		@other_user = users(:tina)
		log_in_as @user
	end

	test "should show logged in user profile on home page" do
		get "/"
		assert_template "posts/index"
		assert_select "h1", text: @user.name
		assert_select "h1>img.gravatar"
		assert_select "p.email", text: @user.email
		assert_select "p.age", text: "30 years old"
		assert_select "p.location", text: "From #{@user.location}"
	end

	test "should show other user profile on user page" do
		get user_url(@other_user)
		assert_template "users/show"
		assert_select "h1", text: @other_user.name
		assert_select "h1>img.gravatar"
		assert_select "p.email", text: @other_user.email
		assert_select "p.location", text: "From #{@other_user.location}"
	end

end
