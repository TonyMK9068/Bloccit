require 'faker'

#create 20 topics
topics = []
20.times do
  topics << Topic.create(
    name: Faker::Lorem.words(rand(1..10)).join(" "),
    description: Faker::Lorem.paragraph(rand(1..4))
  )
end

#create random amount of users
rand(15..30).times do
  password = Faker::Lorem.characters(10)
  u = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password)
  u.skip_confirmation!
  u.save

#create a random amount of posts within specified range
#relate to user and topic

  rand(5..12).times do
    topic = topics.first # getting the first topic here
    p = u.posts.create(
      topic: topic,
      title: Faker::Lorem.words(rand(1..10)).join(" "), 
      body: Faker::Lorem.paragraphs(rand(1..4)).join("\n")
      )
      # set the created_at to a time within the past year
    p.update_attribute(:created_at, Time.now - rand(600..31536000))
    p.update_rank
    topics.rotate! #select next post to associate next comment that will be made
  end
end


#create comments for each user
#set post_id to be a random number
users = []
random_post = []
users = User.all

users.each do |user|
  rand(80..110).times do
    random_post = Post.find(rand(1..(Post.count)))
    c = user.comments.create(
      post: random_post,
      body: Faker::Lorem.paragraphs(rand(1..4)).join("\n")
      )
    c.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

case Rails.env
when "development"
# Saves three particular user instances, members of various user groups.
u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
end

#Console output
puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created