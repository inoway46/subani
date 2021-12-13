namespace :scraping_episode do
  desc '本番環境のマスタデータにepisodeを登録する'
  task abema_all: :environment do
    require "selenium-webdriver"

    options = Selenium::WebDriver::Firefox::Options.new

    options.add_argument('--remote-debugging-port=9222')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')

    Selenium::WebDriver::Firefox::Binary.path=ENV['FIREFOX_BIN']
    Selenium::WebDriver::Firefox::Service.driver_path=ENV['GECKODRIVER_PATH']

    Selenium::WebDriver.logger.level = :info

    driver = Selenium::WebDriver.for :firefox, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    
    abema_urls = Master.where(media: "Abemaビデオ").limit(3)

    #Masterのエピソード数を更新
    abema_urls.each do |master|
      current_episode = master.episode
      @contents = Content.where(master_id: master.id)

      sleep 1

      driver.get(master.url)

      #スクロールして全話表示
      loop do
        if driver.find_elements(:class, "com-video-EpisodeList__title").size > 1
          break
        else
          sleep 1
          3.times do
            driver.execute_script('window.scroll(0,1000000);')
          end
        end
      end

      @titles = []

      titles = driver.find_elements(:class, "com-video-EpisodeList__title")

      titles.each do |node|
        @titles << node.text
      end

      p @titles

      #取得したタイトルからPVやスペシャル回を除去
      ngword = ['PV', 'スペシャル']
      @titles.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンに
      new_episode = @titles.size
      @contents.update_all(new_flag: true) if current_episode < new_episode

      #MasterとContentのepisodeを最新の状態に更新
      master.update(episode: new_episode)
      @contents.update_all(episode: new_episode)

      #デバッグ用
      p "#{master.title}の話数：master=#{master.episode}, content=#{@contents.first.episode}"
    end

    driver.quit
  end

  desc 'herokuのselenium動作確認'
  task test: :environment do
    require "selenium-webdriver"

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'.freeze

    options = Selenium::WebDriver::Chrome::Options.new(
      args: ["--headless", "--disable-gpu", "--incognito", "--no-sandbox", "--disable-setuid-sandbox",
        "--user-agent=#{USER_AGENT}", "window-size=1920,1080", "start-maximized"]
    )
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.get('https://abema.tv/video/title/149-11')

    loop do
      if driver.find_elements(:class, "com-video-EpisodeList__title").size > 1
        break
      else
        sleep 1
        3.times do
          driver.execute_script('window.scroll(0,1000000);')
        end
      end
    end

    @titles = []

    titles = driver.find_elements(:class, "com-video-EpisodeList__title")

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
    Selenium::WebDriver.logger.level = :info 

    driver = Selenium::WebDriver.for :firefox, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.get('https://abema.tv/video/title/149-11')

    element = driver.find_element(:class, "com-video-EpisodeList__title")

    wait.until {element.displayed?}

    p element.text

    3.times do
      sleep(1)
      driver.execute_script('window.scroll(0,1000000);')
    end

    loop do
      if driver.find_elements(:class, "com-video-EpisodeList__title").size > 0
        break
      else
        sleep 0.5
      end
    end

    @titles = []

    titles = driver.find_elements(:class, "com-video-EpisodeList__title")

    titles.each do |node|
      @titles << node.text
    end

    p @titles
    
    driver.quit
  end
end