namespace :selenium do
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
