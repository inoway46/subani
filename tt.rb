a = ["ヴィジュアルプリズン", "http://www.b-ch.com/ttl/index.php?ttl_c=7479", "http://ch.nicovideo.jp/ch2648092", "https://anime.dmkt-sp.jp/animestore/ci_pc?workId=25059", "https://abema.tv/video/title/26-151", "https://www.amazon.co.jp/dp/B09J428B57"]

abema = 'abema'
p a.select { |e| e =~ %r{^.*#{abema}.*} }