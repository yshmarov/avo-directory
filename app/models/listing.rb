class Listing < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  has_one_attached :website_screenshot do |attachable|
    attachable.variant :opengraph, resize: "1200x630^", gravity: "center", extent: "1200x630"
  end

  has_many :category_listings, dependent: :destroy
  has_many :categories, through: :category_listings

  after_create_commit :crawl
  after_update_commit :crawl, if: -> { saved_change_to_url? }

  def crawl
    AttachScreenshotJob.perform_later self
    HomepageCrawlerJob.perform_later self
  end

  def self.ransackable_attributes auth_object = nil
    %w[name description url]
  end

  def self.ransackable_associations auth_object = nil
    []
  end

  def computed_title
    name.presence || clean_url
  end

  def clean_url
    url.gsub(/https?:\/\//, '').gsub(/\/$/, '').gsub(/^www\./, '')
  end
end
