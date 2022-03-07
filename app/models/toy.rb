class Toy < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many_attached :image

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
end
