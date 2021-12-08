namespace :scraping_episode do
  desc 'Abemaビデオの再生ページから話数を取得し、episodeカラムに保存、話数が増えたらnew_flagをtrueにする'
  task abema: :environment do
    require 'open-uri'
    require 'nokogiri'

    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
    
    abema_urls = Master.where(media: "Abemaビデオ")

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
    end
  end

  
end
