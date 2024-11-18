class Category < ApplicationRecord
  validates :name, presence: true

  has_many :category_listings, dependent: :destroy
  has_many :listings, through: :category_listings
end
