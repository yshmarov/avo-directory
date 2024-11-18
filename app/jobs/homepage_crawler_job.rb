require "nokogiri"
require "open-uri"
require "uri"

class HomepageCrawlerJob < ApplicationJob
  queue_as :default

  def perform(record)
    url = record.url

    html = URI.open(url)

    # Parse the HTML with Nokogiri
    doc = Nokogiri::HTML(html)

    # Extract the page title
    page_title = doc.at("title")&.text

    # Extract the favicon URL
    favicon = doc.at('link[rel="icon"]') || doc.at('link[rel="shortcut icon"]')
    favicon_url = favicon ? URI.join(url, favicon["href"]).to_s : nil

    # Extract the meta description
    meta_description = doc.at('meta[name="description"]')&.[]("content")

    # Extract the OpenGraph image
    og_image = doc.at('meta[property="og:image"]')&.[]("content")
    og_image_url = og_image ? URI.join(url, og_image).to_s : nil

    data = {
      page_title:,
      favicon_url:,
      meta_description:,
      og_image_url:
    }

    record.update(payload: data)
  end
end
