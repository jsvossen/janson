class Post < ActiveRecord::Base

	validates :body, presence: true

	belongs_to :user
	has_many :likes, dependent: :destroy
	has_many :comments, dependent: :destroy

	default_scope -> { order(created_at: :desc) }

end
