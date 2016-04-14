class Comment < ActiveRecord::Base

	validates :body, presence: true

	belongs_to :user
	belongs_to :post

	has_many :notifications, as: :notifiable, dependent: :destroy

	default_scope -> { order(created_at: :asc) }

end
