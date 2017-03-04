# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  image_url = Faker::Avatar.image("my-own-slug", "100x100", "jpg")
  User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
  )
end

# アイテム
users = User.order(:created_at).take(30) << User.find(1)
10.times do
  users.each do |user|
    name = Faker::Food.ingredient
    image_url = Faker::LoremPixel.image("200x200", false, 'food')

    item = user.items.create!(
      name:  name
    )
    item.update_attributes!(image: image_url)
  end
end

# リレーションシップ
users = User.all
user = User.find(1)
following = users[2..40]
followers = users[2..50]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# 貸し借り
friends = user.friends.first(10)

friends.each.with_index(1) do |friend, i|
  Kasikari.create!(
    item_id:      user.items[i].id,
    from_user_id: user.id,
    to_user_id:   friend.id,
    start_date:   Date.today,
    end_date:     Date.today + i,
  )
end
friends.each.with_index(1) do |friend, i|
  Kasikari.create!(
    item_id:      friend.items.first.id,
    from_user_id: friend.id,
    to_user_id:   user.id,
    start_date:   Date.today,
    end_date:     Date.today + i,
  )
end
