require 'test_helper'

class SiteRootTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:michael)
	end

	test "root should be login page when logged out" do
		get root_url
		assert_template "devise/sessions/new"
	end

	test "root should be posts index when logged in" do
		log_in_as @user
		get root_url
		assert_template "posts/index"
	end

end
