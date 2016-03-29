class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

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

end
