# This will guess the User class
FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "example@email.com"}
    password { 'password' }
    password_confirmation { 'password' }
  end
end