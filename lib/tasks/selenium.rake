namespace :selenium do
  desc 'herokuのselenium動作確認'
  task one: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.implicit_wait = 10

    driver.navigate.to('https://abema.tv/video/title/149-11')

    #p driver.title
    #p driver.page_source

    eptitle = driver.find_element(:class, 'com-video-EpisodeList__title')

    p eptitle.text
  end

  desc 'firefoxドライバー'
  task fire: :environment do
    require  'selenium-webdriver'

    options = Selenium::WebDriver::Firefox::Options.new

    options.add_argument('--remote-debugging-port=9222')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')

    Selenium::WebDriver::Firefox::Binary.path=ENV['FIREFOX_BIN']
    Selenium::WebDriver::Firefox::Service.driver_path=ENV['GECKODRIVER_PATH']
      
    # use argument `:debug` instead of `:info` for detailed logs in case of an error
    Selenium::WebDriver.logger.level = :info 

    driver = Selenium::WebDriver.for :firefox, options: options
    driver.get "https://www.google.com"
    p  "#{driver.title}"
    driver.quit
  end
end
