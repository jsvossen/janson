class Post < ActiveRecord::Base

	validate :not_empty

	has_attached_file :picture, styles: { medium: "400x400>" }
  	validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  	validates_with AttachmentSizeValidator, attributes: :picture, less_than: 500.kilobytes

	belongs_to :user
	has_many :likes, dependent: :destroy
	has_many :comments, dependent: :destroy

	default_scope -> { order(created_at: :desc) }

	def photo
		picture_file_name
	end

	def body_trimmed(limit = 1000)
		if body.size > limit 
			trimmed = body[0..limit]
			trimmed = trimmed + "..." if trimmed.size < body.size
		else
			body
		end
	end

	private

	  	# Validates either body or photo is present
	  	def not_empty
	  		if body.blank? && picture.blank?
	  			errors.add(:base, "Post cannot be empty")
	  		end
	  	end

end
