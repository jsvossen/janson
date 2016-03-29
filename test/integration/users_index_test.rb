require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
		log_in_as @user
	end

	test "show user list with friend status" do
		get users_path
		assert_template "users/index"
		first_page = User.paginate(page: 1)
		first_page.each do |user|
			assert_select "a[href=?]", user_path(user), user.name
			if user == @user
				assert_select ".friend-status", text: "This is you."
			else
				assert_select ".friend-status>a", text: "+ Add Friend"
			end
		end
	end
end
