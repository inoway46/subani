namespace :scraping_episode do
  desc '月曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_mon: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [1, 7])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '火曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_tue: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [1, 2])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '水曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_wed: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [2, 3])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '木曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_thu: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [3, 4])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '金曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_fri: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [4, 5])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '土曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_sat: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [5, 6])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end

  desc '日曜配信：Abemaビデオの再生ページから話数を取得し、Masterのepisodeカラムに保存'
  task abema_sun: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ").where(stream: [6, 7])

    abema_urls.each do |master|
      current_episode = master.episode

      sleep 1

      charset = nil
      html = open(master.url, opt) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      @titles = []

      doc.css('.com-video-EpisodeList__title').each do |node|
        @titles << node.text
      end

      target = []
      keys = ['話', '#', 'その']
      ngword = ['PV', 'スペシャル']

      keys.each do |key|
        target = @titles.select { |e| e =~ %r{^.*#{key}.*} }
        target.delete_if { |x| x =~ %r{^.*#{ngword[0]}.*} || x =~ %r{^.*#{ngword[1]}.*} }
        unless target.empty?
          if current_episode < target.size
            master.update(episode: target.size)
            p "#{master.title}の最新話が更新されました"
          end
        end
      end
      p "#{master.title} => #{master.episode}話"
    end
  end
end
