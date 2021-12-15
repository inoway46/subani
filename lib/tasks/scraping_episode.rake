namespace :scraping_episode do
  desc '本番環境のマスタデータにepisodeを登録する'
  task abema_all: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    
    abema_urls = Master.where(media: "Abemaビデオ")

    #Masterのエピソード数を更新
    abema_urls.each do |master|
      current_episode = master.episode
      @contents = Content.where(master_id: master.id)

      sleep 1

      driver.navigate.to(master.url)

      p driver.page_source

      wait.until { driver.find_elements(:class, 'com-video-EpisodeList__title').size > 0 }

      #スクロールして全話表示
      3.times do
        sleep(1)
        driver.execute_script('window.scroll(0,1000000);')
      end

      @titles = []

      titles = driver.find_elements(:class, 'com-video-EpisodeList__title')

      titles.each do |node|
        @titles << node.text
      end

      #取得したタイトルからPVやスペシャル回を除去
      ngword = ['PV', 'スペシャル']
      @titles.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンに
      new_episode = @titles.size
      if current_episode < new_episode
        @contents.update_all(new_flag: true)
        #Masterのepisodeを最新の状態に更新
        master.update(episode: new_episode)
        p "#{master.title}:フラグオン、Masterを#{new_episode}話に更新しました"
      end

      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "#{master.title}のcontentデータを#{master.episode}話に更新しました"
      end

      #デバッグ用
      p "#{master.title}：master=#{master.episode}話"
    end
  end

  desc 'herokuのselenium動作確認'
  task test: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/149-11')

    p driver.page_source

    @titles = []

    wait.until { driver.find_elements(:class, 'com-video-EpisodeList__title').size > 0 }

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    titles = driver.find_elements(:class, 'com-video-EpisodeList__title')

    titles.each do |node|
      @titles << node.text
    end

    p @titles
  end

  desc 'firefoxでテスト'
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
    #Selenium::WebDriver.logger.level = :info 

    driver = Selenium::WebDriver.for :firefox, options: options
    driver.get "https://www.google.com"
    puts  "#{driver.title}"
    driver.quit
  end

  desc 'googleでテスト'
  task google: :environment do
    require  'selenium-webdriver'

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to "https://www.google.com"
    p driver.page_source
    p driver.find_element(:class, 'MV3Tnb').text
    driver.quit
  end

  desc 'herokuのselenium動作確認'
  task one: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/149-11')

    p driver.title
    p driver.page_source

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    eptitle = driver.find_element(:class, 'com-video-EpisodeList__title')

    p eptitle
  end

  desc '変更：ウインドウサイズ、取得要素'
  task one1: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('window-size=1920,1080')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/149-11')

    #p driver.page_source
    p driver.title

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    eptitle = driver.find_element(:class, 'com-video-EpisodeList__caption')
    p eptitle.attribute('innerHTML')
    p eptitle.find_element(:tag_name, 'p').text
  end

  desc '変更：ウインドウサイズのみ'
  task one2: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument('window-size=1920,1080')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/149-11')

    #p driver.page_source
    p driver.title

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    eptitle = driver.find_element(:class, 'com-video-EpisodeList__title')
    p eptitle.attribute('innerHTML')
    p eptitle.text
  end

  desc '変更：取得要素のみ'
  task one3: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/149-11')

    #p driver.page_source
    p driver.title

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    eptitle = driver.find_element(:class, 'com-video-EpisodeList__caption')
    p eptitle.attribute('innerHTML')
    p eptitle.find_element(:tag_name, 'p').text
  end
end