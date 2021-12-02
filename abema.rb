require 'open-uri'
require 'nokogiri'

opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'
#無職転生の再生ページを取得
url = 'https://abema.tv/video/title/26-149'

charset = nil
html = open(url, opt) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

@titles = []

doc.css('.com-video-EpisodeList__title').each do |node|
  @titles << node.text
end

@titles.pop

p @titles