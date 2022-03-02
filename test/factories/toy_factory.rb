# This will guess the User class
FactoryBot.define do
  factory :toy do
    owner { create :user }
    name { "Toy 1" }
  end
end