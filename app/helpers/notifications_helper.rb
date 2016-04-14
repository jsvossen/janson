module NotificationsHelper

	# returns bootstrap glyph key for given notification type
	def glyph(notification)
		case notification.type
			when "Friendship"
				"user"
			else
				"exclamation-sign"
		end
	end

end
