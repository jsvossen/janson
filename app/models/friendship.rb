class Friendship < ActiveRecord::Base

	validates :friend_id,  :uniqueness => { :scope => :user_id, :message => "already added" }
	validates_inclusion_of :status, :in => %w( accepted requested pending ), :message => "is invalid"
	validate :friend_is_not_self

	belongs_to :user
	belongs_to :friend, :class_name => "User"

	has_many :notifications, as: :notifiable, dependent: :destroy

	scope :requested, -> { where(status: "requested") }
	scope :pending, -> { where(status: "pending") }
	scope :accepted, -> { where(status: "accepted") }

	private

		def friend_is_not_self
	    	errors.add(:friend_id, "cannot be yourself") unless user_id != friend_id
		end

end