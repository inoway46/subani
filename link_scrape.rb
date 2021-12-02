#annictからアニメの再生ページのリンクを取得（search_wordにメディア名を入れる）
require 'open-uri'
require 'nokogiri'

#ユーザーエージェントの設定（503エラー回避のため）
opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36'

#取得先ページの用意
link1 = ["/works/8200", "/works/7969", "/works/7551", "/works/7917", "/works/8957", "/works/8170", "/works/8491", "/works/8180", "/works/7669", "/works/8135", "/works/8665", "/works/8181", "/works/7190", "/works/8402", "/works/7878", "/works/7619", "/works/8630", "/works/7827", "/works/8379", "/works/7879", "/works/8000", "/works/6871", "/works/7513", "/works/8546", "/works/7836", "/works/7739", "/works/7999", "/works/8675", "/works/8201", "/works/8414", "/works/7835", "/works/8656", "/works/7903", "/works/8634", "/works/8168", "/works/8796", "/works/7678", "/works/5438", "/works/8947", "/works/8459", "/works/8146", "/works/8837", "/works/7832", "/works/8779", "/works/8129", "/works/7853", "/works/8845", "/works/8870", "/works/7691", "/works/6305", "/works/7932", "/works/8990", "/works/8938", "/works/8661", "/works/8651", "/works/8788", "/works/8465", "/works/8172", "/works/8939", "/works/8182"]

annict = link1.map{|a| "https://annict.com/#{a}"}

urls = annict

urls.each do |url|
  #URLを読み込む前に1秒待つ（過剰アクセスによる429エラーを避けるため）
  sleep 1

  #取得先ページのロード
  charset = nil
  html = open(url, opt) do |f|
    charset = f.charset
    f.read
  end
  
  doc = Nokogiri::HTML.parse(html, nil, charset)
  
  @links = []
  
  #annictの作品ページから各メディアの配信URLを取得
  doc.xpath('//ul[@class="list-inline mt-2"]').css('a').each do |node|
    @links << node.attribute('href').value
  end

  #必要なメディアのリンクを@linksから部分一致検索で取得
  search_word = 'abema'
  target = @links.select { |e| e =~ %r{^.*#{search_word}.*} }

  #targetがnilでなければ、アニメのタイトルを配列に追加して結果を表示
  unless target.empty?
    doc.xpath('//h1[@class="fw-bold h2 mt-1"]').each do |node|
      target << node.text
    end

    p target
  end
end

