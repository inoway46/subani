namespace :selenium do
  desc 'herokuのselenium動作確認'
  task one: :environment do
    require "selenium-webdriver"

    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

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

    message = {
      type: 'text',
      text: eptitle.text
    }

    response = client.push_message(ENV["LINE_USER_ID"], message)
    p response
  end

  desc '本番環境のマスタデータにepisodeを登録する'
  task abema_all: :environment do
    require "selenium-webdriver"

    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    
    abema_urls = Master.where(media: "Abemaビデオ").limit(2)

    #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：スクレイピングを開始します"

    #Masterのエピソード数を更新
    abema_urls.each do |master|

      sleep 1

      driver.navigate.to(master.url)

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

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンにして、LINEに通知
      @contents = Content.where(master_id: master.id)
      current_episode = master.episode
      new_episode = @titles.size

      if current_episode < new_episode
        @contents.update_all(new_flag: true)
        #Masterのepisodeを最新の状態に更新
        master.update(episode: new_episode)
        p "#{master.title}:フラグオン、Masterを#{new_episode}話に更新しました"
        #line_flagオンのcontentに紐づくユーザー一覧を取得し、uidが存在するユーザーにLINE通知を行う
        line_contents = @contents.where(line_flag: true)
        line_contents.each do |content|
          line_users = content.users.where.not(uid: nil)
          line_users.each do |user|
            message = {
              type: 'text',
              text: "#{master.title}の#{new_episode}話が公開されました！#{master.url}"
            }
            response = client.push_message(user.uid, message)
            p response
            p "LINE通知：#{content.title}を#{user.email}さんに送信しました"
          end
        end
      end

      #Masterの話数を表示（ログ確認用）
      p " <Master> #{master.episode}話 [#{master.title}]"

      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "<Content> #{master.title}を#{master.episode}話に更新しました"
      end
    end

    #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：スクレイピングが完了しました"
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
    #Selenium::WebDriver.logger.level = :info 

    driver = Selenium::WebDriver.for :firefox, options: options
    driver.get "https://www.google.com"
    p  "#{driver.title}"
    driver.quit
  end

  desc 'Amazonのスクレイピングテスト'
  task amazon: :environment do
    require  'selenium-webdriver'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    amazons =  Master.where(media: "Amazonプライム")

    amazons.each do |amazon|
      driver.navigate.to(amazon.url)

      sleep 2
      driver.execute_script('window.scroll(0,1000000);')

      elements = driver.find_elements(:xpath, '//*[@id="tab-content-episodes"]/div/div/a')
      if elements.present?
        elements.each do |element|
          element.click
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

      p @titles
    end
  end

  desc 'dアニメのテスト'
  task danime: :environment do
    require  'selenium-webdriver'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    amazons =  Master.where(media: "Amazonプライム")

    #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：Amazonスクレイピングを開始します"

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

      p new_episode = @titles.size

      @danime = []

      dtext = driver.find_elements(:class, "_28Bfau")
      
      if dtext.present?
        dtext.each do |node|
          @danime << node.text
        end

        ngword = ['dアニメストア']
        @danime.select! { |x| x =~ %r{^#{ngword}.*} }

        p @danime
        p new_episode -= 1 if @danime.size > 0
      end

      @contents = Content.where(master_id: master.id)
      current_episode = master.episode

      #取得したタイトル数が現在のエピソード数より多ければ最新話フラグをオンに
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

      #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：Amazonスクレイピングが完了しました"
  end

  desc 'Netflixのテスト'
  task netflix: :environment do
    require  'selenium-webdriver'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('headless')
    options.add_argument('disable-gpu')
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument('--lang=ja-JP')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    driver.navigate.to("https://www.netflix.com/jp/title/81374392")

    sleep 2
    driver.execute_script('window.scroll(0,1000000);')

    titles = driver.find_elements(:class, "episode-title")

    @titles = []

    titles.each do |node|
      @titles << node.text
    end

    p @titles
    p @titles.size
  end
end
