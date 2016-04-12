class Post < ActiveRecord::Base

	validate :not_empty
	validate :picture_size

	mount_uploader :picture, PictureUploader

	belongs_to :user
	has_many :likes, dependent: :destroy
	has_many :comments, dependent: :destroy

	default_scope -> { order(created_at: :desc) }


	private

		# Validates the size of an uploaded picture.
	  	def picture_size
	  		if picture.size > 500.kilobytes
	  			errors.add(:picture, "should be less than 500 KB")
	  		end
	  	end

	  	# Validates either body or photo is present
	  	def not_empty
	  		if body.blank? && picture.blank?
	  			errors.add(:base, "Post cannot be empty")
	  		end
	  	end

end
