class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, :through => :friendships do
    def requested
      where("friendships.status = ?", "requested")
    end
    def pending
      where("friendships.status = ?", "pending")
    end
    def accepted
      where("friendships.status = ?", "accepted")
    end
  end

  scope :by_name_asc, -> { joins(:profile).order("profiles.name") }

  def name
  	profile.name
  end

  def birthday
  	profile.birthday
  end

  def age
  	if profile.birthday
  		now = Time.now.utc.to_date
  		now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  	end
  end

  def location
  	profile.location
  end

  def about
  	profile.about
  end

  def friend_status(user)
    friendship = Friendship.find_by(user: self, friend: user)
    friendship ? friendship.status : false
  end

  def news_feed
    friend_ids = "SELECT friend_id FROM friendships
            WHERE user_id = :user_id"
    Post.where("user_id IN (#{friend_ids}) OR user_id = :user_id", 
               user_id: id)
  end

end
