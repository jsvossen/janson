class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def type
  	notifiable_type
  end

  def sender
  	case type
  		when "Friendship"
  			notifiable.friend
  		else
  			nil
  	end
  end

end
