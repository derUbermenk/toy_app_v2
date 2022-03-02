# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# create 5 users
5.times do
  
  name = Faker::Name.unique.name
  email = Faker::Internet.email(name: name)
  # password = 

  User.create!(
    name:  name,
    email: email
  )
end


# make each create 2 toys
User.all.each do |user|
  2.times do
    user.toys.create!(
      name: Faker::Lorem.sentence(word_count: [2,3].sample),
      description: Faker::Lorem.sentence(word_count: 10, supplemental: true)
    )
  end
end
