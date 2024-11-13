class Listing < ApplicationRecord
  validates :url, presence: true, uniqueness: true
end
