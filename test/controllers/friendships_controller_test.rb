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
		@other_user = users(:chris)
		sign_in @other_user
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

	test "only friendship members can delete friendship" do
		sign_in users(:rando)
		@friendship = friendships(:mutual1)
		assert_no_difference "Friendship.count" do
			delete :destroy, id: @friendship
		end
		assert_redirected_to root_url
	end

	test "only invitee can accept friendship" do
		sign_in @user
		@other_user = users(:chris)
		@friendship = friendships(:pending)
		patch :update, id: @friendship
		assert @user.friend_status(@other_user) == "requested"
		assert @other_user.friend_status(@user) == "pending"
		assert_redirected_to root_url
	end


end
