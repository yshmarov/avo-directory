class Listing < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  has_one_attached :website_screenshot do |attachable|
    attachable.variant :opengraph, resize: "1200x630^", gravity: "center", extent: "1200x630"
  end

  after_update_commit :attach_screenshot, if: -> { saved_change_to_url? }

  def attach_screenshot
    AttachScreenshotJob.perform_later self
  end
end
