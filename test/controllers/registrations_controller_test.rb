require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  	def setup
 		@request.env['devise.mapping'] = Devise.mappings[:user]
 		@user = users(:michael)
	end
  
	test "should create profile on registration" do
		assert_difference "Profile.count", 1 do
		    post :create, user: { email: "test@test.com", password: "password", password_confirmation: "password" }
		end
		assert_redirected_to edit_profile_url
	end

	test "should not create profile if registration fails" do
		assert_no_difference "Profile.count" do
		    post :create, user: { email: "invalid@email", password: "password", password_confirmation: "" }
		end
		assert_template 'devise/registrations/new'
	end

	test "should delete profile on cancellation" do
		sign_in @user
		assert_difference "Profile.count", -1 do
			delete :destroy, id: @user
		end
	end
end
