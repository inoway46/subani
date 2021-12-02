require 'open-uri'
require 'nokogiri'

opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'

urls = ["https://www.amazon.co.jp/dp/B09HZF885V", "https://www.amazon.co.jp/dp/B09HMW859Y", "https://www.amazon.co.jp/dp/B09J1XNY54", "https://www.amazon.co.jp/dp/B09HLFKKW6", "https://www.amazon.co.jp/dp/B09HWSGY7L", "https://www.amazon.co.jp/dp/B09HLJWTLW", "https://www.amazon.co.jp/dp/B09HLG64C3", "https://www.amazon.co.jp/dp/B09J486BPX", "https://www.amazon.co.jp/dp/B09HQDNXC1", "https://www.amazon.co.jp/dp/B09HQFV3FM/", "https://www.amazon.co.jp/dp/B09J1YDMQ3", "https://www.amazon.co.jp/dp/B09J42XTLV", "https://www.amazon.co.jp/dp/B0992SSZKL", "https://www.amazon.co.jp/dp/B09HN9XPLG", "https://www.amazon.co.jp/dp/B09J48HN1Q/", "https://www.amazon.co.jp/dp/B09HZ9GKKX", "https://www.amazon.co.jp/dp/B09HRH31RC", "https://www.amazon.co.jp/dp/B09J7NNZ95/", "https://www.amazon.co.jp/dp/B09HM78VGJ", "https://www.amazon.co.jp/dp/B09HN92DCX", "https://www.amazon.co.jp/dp/B09JSCGQTG", "https://www.amazon.co.jp/dp/B09J8XGTMM", "https://www.amazon.co.jp/dp/B09BDY2V6P/", "https://www.amazon.co.jp/dp/B09JBGF9W9", "https://www.amazon.co.jp/dp/B09HSZT8HZ", "https://www.amazon.co.jp/dp/B09HMK8CLJ", "https://www.amazon.co.jp/dp/B09HJMKKQ3", "https://www.amazon.co.jp/dp/B09HZ8B8D2", "https://www.amazon.co.jp/dp/B09891TR1L", "https://www.amazon.co.jp/dp/B091XQT58W", "https://www.amazon.co.jp/dp/B09HV6KF7F", "https://www.amazon.co.jp/dp/B08SHW97KR", "https://www.amazon.co.jp/dp/B09HN9R836", "https://www.amazon.co.jp/dp/B09HDJ5PJH", "https://www.amazon.co.jp/dp/B09HN9K77J", "https://www.amazon.co.jp/dp/B09JJ1LX3B", "https://www.amazon.co.jp/dp/B09HC5MQPF", "https://www.amazon.co.jp/dp/B09H9R3VP7", "https://www.amazon.co.jp/dp/B08KL3Z92B/", "https://www.amazon.co.jp/dp/B09HZ7218D", "https://www.amazon.co.jp/dp/B092M1WW6Q/", "https://www.amazon.co.jp/dp/B09HRKG9C8", "https://www.amazon.co.jp/dp/B09HYSCM1M", "https://www.amazon.co.jp/dp/B09HJX1F88"]

urls.each do |url|
#再生ページを取得
#url = "https://www.amazon.co.jp/dp/B09HZF885V"

charset = nil
html = open(url, opt) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

@titles = []

doc.xpath('//div[@class="_2nY3e-"]').css('span').each do |node|
  @titles << node.text
end

p @titles
end