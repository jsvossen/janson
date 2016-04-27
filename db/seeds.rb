# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.reset_callbacks(:create)

def rand_name
	Faker::Name.name
end
def rand_location
	Faker::Address.state
end
def rand_date
	Faker::Date.between(40.years.ago, 15.years.ago)
end
def rand_pic
	URI.parse("http://loremflickr.com/400/400/person,animal,place")
end
def rand_content
	[Faker::Lorem.sentence, Faker::Hipster.sentence, Faker::Lorem.paragraph, Faker::Hipster.paragraph, Faker::Hacker.say_something_smart].sample
end

def random_profile user, name = rand_name, location = rand_location, birthday = rand_date, avatar = rand_pic
	user.create_profile(name: name, location: location, birthday: birthday, avatar: avatar)
end

User.where(email: "test@test.com").first_or_create do |user|
	user.password = "test"
	random_profile(user, "Ima Tester", "Testingville")
	user.profile.update_attribute(:about, "Testing, testing, 123...")
end

User.where(email: "ex@example.com").first_or_create do |user|
	user.password = "password"
	random_profile(user, "Demo User", "Anytown, USA")
	user.profile.update_attribute(:about, "Sample user account with random data.")
end

# create random users
20.times do |i|
	email = "ex#{i}@example.com"
	User.where(email: email).first_or_create do |user|
		user.password = "password#{i}"
		random_profile(user)
		user.profile.update_attribute(:about, rand_content) if Faker::Boolean.boolean
	end
end

# create posts and friends
User.all.each do |user|
	#posts 
	num_p = rand(10)
	num_p.times do 
		p = user.posts.create!(body: rand_content)
		p.update_attribute :picture, rand_pic if Faker::Boolean.boolean(0.25)
		p.update_attribute :created_at, Faker::Date.between(30.days.ago, Time.now)
	end
	#friends
	num_f = rand(5)
	num_f.times do
		friend = User.all.sample
		next if friend == user || user.friend_status(friend)
		user.friendships.create!(friend: friend, status: "accepted")
		friend.friendships.create!(friend: user, status: "accepted")
	end
end

# create likes and comments
User.all.each do |user|
	#likes
	num_l = rand(50)
	num_l.times do
		post = Post.all.sample
		next if user.likes?(post)
		user.likes.create!(post: post)
	end
	#comments
	num_c = rand(25)
	num_c.times do
		post = Post.all.sample
		c = user.comments.create!(post: post, body: rand_content)
		c.update_attribute :created_at, Faker::Date.between(post.created_at, Time.now)
	end
end

