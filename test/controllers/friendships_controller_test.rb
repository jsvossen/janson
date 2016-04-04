require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
	def setup
 		@request.env['devise.mapping'] = Devise.mappings[:user]
 		@user = users(:michael) 		
	end

	test "should create friendship for current user and friended user" do
		sign_in @user
		@other_user = users(:rando)
		assert_difference "Friendship.count", 2 do
		    post :create, friendship: { friend_id: @other_user.id }
		end
		assert @user.friend_status(@other_user) == "requested"
		assert @other_user.friend_status(@user) == "pending"
	end

	test "should update both friendships when request is accepted" do
		sign_in @user
		@other_user = users(:chris)
		@friendship = friendships(:pending)
		patch :update, id: @friendship
		assert @user.friend_status(@other_user) == "accepted"
		assert @other_user.friend_status(@user) == "accepted"
	end

	test "should delete both friendships on destroy" do
		request.env["HTTP_REFERER"] = root_path
		sign_in @user
		@friendship = friendships(:mutual1)
		assert_difference "Friendship.count", -2 do
		    delete :destroy, id: @friendship
		end
	end
end
