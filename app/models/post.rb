class Post < ActiveRecord::Base

	validates :body, presence: true

	belongs_to :user

end
