namespace :scraping_episode do
  require "selenium-webdriver"
  require 'webdrivers'

  def set_proxy
    proxy_host = '172.105.238.80'
    proxy_port = '1234'
    proxy = Selenium::WebDriver::Proxy.new(http: "#{proxy_host}:#{proxy_port}")
    proxy
  end

  def selenium_options
    options = Selenium::WebDriver::Chrome::Options.new(
      prefs: { 'profile.default_content_setting_values.notifications': 2 },
      binary: ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    )
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    options
  end

  def selenium_capabilities_chrome
    Selenium::WebDriver::Remote::Capabilities.chrome
  end

  def driver_init
    caps = [
      selenium_options,
      selenium_capabilities_chrome,
    ]

    Selenium::WebDriver.for(:chrome, capabilities: caps)
  end

  desc 'Abemaビデオのタイトル数をスクレイピングしてローカルDB更新'
  task abema_cert: :environment do
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
    Selenium::WebDriver::Chrome.path = chrome_bin_path if chrome_bin_path

    driver = driver_init
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to('https://abema.tv/video/title/25-163')

    sleep 5

    print(driver.page_source)

    wait.until { driver.find_elements(:class, 'com-a-Checkbox').size > 0 }
    driver.find_element(:class, 'com-a-Checkbox').click
    driver.find_element(:class, 'c-application-GDPRContainer__button').click

    sleep 5

    wait.until { driver.find_elements(:class, 'com-video-EpisodeList__title').size > 0 }

    print(driver.page_source)
  end

  desc 'Abemaビデオのタイトル数をスクレイピングしてローカルDB更新'
  task abema: :environment do
    include Day
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
    Selenium::WebDriver::Chrome.path = chrome_bin_path if chrome_bin_path

    driver = driver_init
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    abemas = Master.abema_titles.now_streaming

    p "#{Time.current}:スクレイピングを開始します"

    abemas.each do |master|
      current_episode = master.episode
      @contents = Content.where(master_id: master.id)

      sleep 1

      driver.navigate.to(master.url)

      wait.until { driver.find_elements(:class, 'com-video-EpisodeList__title').size > 0 }

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
      ngword = ['PV', 'スペシャル', 'アニメ']
      @titles.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} || x =~ %r{^.*#{ngword[2]}.*} }

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンに
      new_episode = @titles.size
      if current_episode < new_episode
        @contents.update_all(new_flag: true)
        master.update(episode: new_episode, update_day: day_of_week)
        p "#{master.title}:フラグオン、Masterを#{new_episode}話に更新しました"
      end

      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "#{master.title}のcontentデータを#{master.episode}話に更新しました"
      end

      #デバッグ用
      p "#{master.title}:master=#{master.episode}話"
    end

    p "#{Time.current}:スクレイピングが完了しました"
    driver.quit
  end

  desc 'Amazonプライムのタイトル数をスクレイピングしてローカルDB更新'
  task amazon: :environment do
    include Day
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
    Selenium::WebDriver::Chrome.path = chrome_bin_path if chrome_bin_path

    driver = driver_init
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    amazons =  Master.amazon_titles.now_streaming

    p "#{Time.current}:Amazonスクレイピングを開始します"

    amazons.each do |master|
      driver.navigate.to(master.url)

      sleep 2
      driver.execute_script('window.scroll(0,1000000);')

      elements = driver.find_elements(:xpath, '//*[@id="tab-content-episodes"]/div/div/a')
      if elements.present?
        elements.each do |element|
          driver.execute_script('arguments[0].click();', element)
        end
      end

      2.times do
        sleep(1)
        driver.execute_script('window.scroll(0,1000000);')
      end

      titles = driver.find_elements(:class, "_2nY3e-")

      @titles = []

      titles.each do |node|
        @titles << node.text
      end

      ngword = ['ボーナス:']
      @titles.delete_if { |x| x =~ %r{^#{ngword}.*} }

      new_episode = @titles.size

      @danime = []

      dtext = driver.find_elements(:class, "_28Bfau")
      
      if dtext.present?
        dtext.each do |node|
          @danime << node.text
        end

        ngword = ['dアニメストア']
        @danime.select! { |x| x =~ %r{^#{ngword}.*} }

        new_episode -= 1 if @danime.size > 0
      end

      @contents = Content.where(master_id: master.id)
      current_episode = master.episode

      if current_episode < new_episode
        @contents.update_all(new_flag: true)
        master.update(episode: new_episode, update_day: day_of_week)
        p "#{master.title}:フラグオン、Masterを#{new_episode}話に更新しました"
      end

      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "#{master.title}のcontentデータを#{master.episode}話に更新しました"
      end

      p "#{master.title}:master=#{master.episode}話"
    end

    p "#{Time.current}:Amazonスクレイピングが完了しました"
    driver.quit
  end

  desc 'Netflixのタイトル数をスクレイピングしてローカルDB更新'
  task netflix: :environment do
    include Day
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
    Selenium::WebDriver::Chrome.path = chrome_bin_path if chrome_bin_path

    driver = driver_init
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    netflixs = Master.netflix_titles.now_streaming.onair

    p "#{Time.current}:スクレイピングを開始します"

    netflixs.each do |master|
      current_episode = master.dummy_episode
      @contents = Content.where(master_id: master.id)

      sleep 1

      driver.navigate.to(master.url)

      wait.until { driver.find_elements(:class, 'episode-title').size > 0 }

      3.times do
        sleep(1)
        driver.execute_script('window.scroll(0,1000000);')
      end

      @titles = []

      titles = driver.find_elements(:class, 'episode-title')

      titles.each do |node|
        @titles << node.text
      end

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンに
      new_episode = @titles.size
      if current_episode < new_episode
        @contents.update_all(new_flag: true)
        master.episode += 1
        master.update(episode: master.episode, dummy_episode: new_episode)
        p "#{master.title}:フラグオン、Masterを#{new_episode}話に更新しました"
      end

      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "#{master.title}のcontentデータを#{master.episode}話に更新しました"
      end

      #デバッグ用
      p "#{master.title}:master=#{master.episode}話"
    end

    p "#{Time.current}:スクレイピングが完了しました"
    driver.quit
  end
end