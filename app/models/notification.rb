class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def type
  	notifiable_type
  end

  def sender
  	if type == "Friendship"
  			notifiable.friend
    else
        notifiable.user
  	end
  end

end
