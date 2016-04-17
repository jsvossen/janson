class Comment < ActiveRecord::Base

	validates :body, presence: true

	belongs_to :user
	belongs_to :post

	has_many :notifications, as: :notifiable, dependent: :destroy

	scope :order_asc, -> { order(created_at: :asc) }
	scope :order_desc, -> { order(created_at: :desc) }
	scope :most_recent, -> (limit=5) { order(created_at: :desc).limit(limit) }

end
