class AttachScreenshotJob < ApplicationJob
  queue_as :default

  def perform(record)
    url = record.url

    browser = Ferrum::Browser.new(timeout: 10)
    browser.resize(width: 1200, height: 630)
    browser.goto(url)
    browser.network.wait_for_idle

    tempfile = Tempfile.new
    browser.screenshot(path: tempfile.path, quality: 40, format: 'jpg')

    record.website_screenshot.attach(io: File.open(tempfile.path), filename: "#{url.parameterize}.jpg")
    puts record.website_screenshot.attached?
  ensure
    browser.quit
  end
end