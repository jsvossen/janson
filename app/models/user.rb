class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_one :profile, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
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

  after_create :send_welcome_email

  def name
  	profile.name if profile
  end

  def birthday
  	profile.birthday if profile
  end

  def age
  	if profile.birthday
  		now = Time.now.utc.to_date
  		now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  	end
  end

  def location
  	profile.location if profile
  end

  def about
  	profile.about if profile
  end

  def friend_status(user)
    friendship = Friendship.find_by(user: self, friend: user)
    friendship ? friendship.status : false
  end

  def news_feed
    friend_ids = "SELECT friend_id FROM friendships
            WHERE user_id = :user_id AND status = 'accepted'"
    Post.where("user_id IN (#{friend_ids}) OR user_id = :user_id", 
               user_id: id)
  end

  def likes?(post)
    !likes.find_by(post_id: post.id).nil?
  end

  def self.from_omniauth(auth)
    auth_req = { new_user: false }
    auth_req[:user] = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.create_profile(name: auth.info.name, avatar: URI.parse(auth.info.image))
      auth_req[:new_user] = true
    end
    auth_req
  end

  private
    def send_welcome_email
      UserMailer.welcome_mailer(self).deliver_later
    end

end
