require 'open-uri'
require 'nokogiri'

opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'

url = "https://www.amazon.co.jp/dp/B09HZ9GKKX"

charset = nil
html = open(url, opt) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

puts doc.xpath('//div[@class="_28Bfau"]').text