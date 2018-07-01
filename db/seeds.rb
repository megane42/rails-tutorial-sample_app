# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

active_users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  active_users.each { |u| u.microposts.create!(content: content) }
end

me = User.first
following = User.all[2..50]
followers = User.all[3..40]
following.each { |u| me.follow(u) }
followers.each { |u| u.follow(me) }
