namespace :scraping_episode do
  desc '本番環境のマスタデータにepisodeを登録する'
  task abema_all: :environment do
    require 'open-uri'
    require 'nokogiri'
    require "selenium-webdriver"

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'.freeze

    options = Selenium::WebDriver::Chrome::Options.new(
      args: ["--headless", "--disable-gpu", "--incognito", "--no-sandbox", "--disable-setuid-sandbox",
        "--user-agent=#{USER_AGENT}"]
    )
    driver = Selenium::WebDriver.for :chrome, options: options
    
    abema_urls = Master.where(media: "Abemaビデオ").limit(5)

    #Masterのエピソード数を更新
    abema_urls.each do |master|
      current_episode = master.episode
      @contents = Content.where(master_id: master.id)

      sleep 2

      driver.get(master.url)

      #スクロールして全話表示
      3.times do
        sleep(1)
        driver.execute_script('window.scroll(0,1000000);')
      end

      @titles = []

      titles = driver.find_elements(:class, "com-video-EpisodeList__title")

      titles.each do |node|
        @titles << node.text
      end

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
      #p "#{master.title}の話数：master=#{master.episode}, content=#{@contents.first.episode}"
    end
  end
end