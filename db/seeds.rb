# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# example user

gutty_image  = "#{Rails.root}/public/images/gutty.png"
raahii_image = "#{Rails.root}/public/images/raahii.png"

gutty = User.create!(
  name:  "三上大河",
  email: "mikami@gmail.com",
  password:              "foobar",
  password_confirmation: "foobar",
  image: File.open(gutty_image)
)
nakahira = User.create!(
  name:  "中平有樹",
  email: "nakahira@gmail.com",
  password:              "foobar",
  password_confirmation: "foobar",
  image: File.open(raahii_image)
)

# other users
10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  file_path = "#{Rails.root}/public/images/sample/users/#{n+1}.png"
  User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    image:                 File.open(file_path),
  )
end

# items
item_images = Dir.glob("#{Rails.root}/public/images/sample/items/*")
[gutty, nakahira].each do |user|
  5.times do
    index = rand(0...item_images.length)
    image_path = item_images[index]
    filename = File.basename(image_path).split(".").first

    item = user.items.create!(
      name:  filename,
      image: File.open(image_path),
    )
  end
end

other_users = User.all.where.not(id: [1,2])
other_users.each do |user|
  rand(2..5).times do
    index = rand(0...item_images.length)
    image_path = item_images[index]
    filename = File.basename(image_path).split(".").first

    item = user.items.create!(
      name:  filename,
      image: File.open(image_path),
    )
  end
end

# relationships
following = other_users[0...5]
followers = other_users[0...10]
following.each { |followed| gutty.follow(followed) }
followers.each { |follower| follower.follow(gutty) }

following = other_users[5...10]
followers = other_users[0...10]
following.each { |followed| nakahira.follow(followed) }
followers.each { |follower| follower.follow(nakahira) }

# kasikaris
status = 1
[gutty, nakahira].each do |user|
  friends = user.friends
  friends.each_with_index do |friend, i|
    status = 1 - status
    Kasikari.create!(
      item_id:      user.items[i].id,
      from_user_id: user.id,
      to_user_id:   friend.id,
      start_date:   Date.today,
      end_date:     Date.today + i,
      status:       status,
    )
  end
  friends.each_with_index do |friend, i|
    status = 1 - status
    Kasikari.create!(
      item_id:      friend.items.first.id,
      from_user_id: friend.id,
      to_user_id:   user.id,
      start_date:   Date.today,
      end_date:     Date.today + i,
      status:       status,
    )
  end
end


gutty.follow(nakahira)
nakahira.follow(gutty)
