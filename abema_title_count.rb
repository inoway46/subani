require "selenium-webdriver"
require 'open-uri'
require 'nokogiri'
require 'byebug'

USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'.freeze

options = Selenium::WebDriver::Chrome::Options.new(
  args: ["--disable-gpu", "--incognito", "--no-sandbox", "--disable-setuid-sandbox",
    "--user-agent=#{USER_AGENT}", "window-size=1280x800"]
)
driver = Selenium::WebDriver.for :chrome, options: options
#wait = Selenium::WebDriver::Wait.new(:timeout => 10)

driver.get('https://abema.tv/video/title/5-25')

sleep 5

element = driver.find_element(:class, 'com-video-EpisodeListSection__sort-icon')

driver.action.move_by(element.location.x , element.location.y).click.perform

#wait.until{ driver.find_element(:class, 'com-video-EpisodeListSection__sort-icon com-video-EpisodeListSection__sort-icon--reverse') }

sleep 5

title = driver.find_element(:class, "com-video-EpisodeList__title")

p title.text

driver.quit

