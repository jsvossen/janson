class Profile < ActiveRecord::Base

	validates :name, presence: :true

	belongs_to :user

	has_attached_file :avatar, styles: { medium: "400x400>", thumb: "100x100#" }, default_url: "missing_avatar_:style.jpg"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
	validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 500.kilobytes
	
end
