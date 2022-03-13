class Toy < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many_attached :images

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 300 }
end
