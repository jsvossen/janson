class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  default_scope -> { order(created_at: :desc) }

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
