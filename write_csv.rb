require 'csv'

array = [["https://abema.tv/video/title/149-11", "無職転生 ～異世界行ったら本気だす～  第2部"],
["https://abema.tv/video/title/115-83", "先輩がうざい後輩の話"],
["https://abema.tv/video/title/26-149", "鬼滅の刃 無限列車編"],
["https://abema.tv/video/title/54-63", "見える子ちゃん"],
["https://abema.tv/video/title/536-2", "takt op.Destiny"],
["https://abema.tv/video/title/25-182", "世界最高の暗殺者、異世界貴族に転生する"],
["https://abema.tv/video/title/25-163", "86―エイティシックス― 第2クール"],
["https://abema.tv/video/title/194-25", "異世界食堂2"],
["https://abema.tv/video/title/19-81", "プラチナエンド"],
["https://abema.tv/video/title/189-34", "結城友奈は勇者である 大満開の章"],
["https://abema.tv/video/title/54-64", "最果てのパラディン"],
["https://abema.tv/video/title/189-35", "大正オトメ御伽話"],
["https://abema.tv/video/title/420-48", "月とライカと吸血姫"],
["https://abema.tv/video/title/198-8", "サクガン"],
["https://abema.tv/video/title/149-14", "吸血鬼すぐ死ぬ"],
["https://abema.tv/video/title/172-47", "ルパン三世 PART6"],
["https://abema.tv/video/title/25-179", "SELECTION PROJECT"],
["https://abema.tv/video/title/25-181", "逆転世界ノ電池少女"],
["https://abema.tv/video/title/5-27", "ワールドトリガー 3rdシーズン"],
["https://abema.tv/video/title/481-7", "プラオレ！～PRIDE OF ORANGE～"],
["https://abema.tv/video/title/283-19", "かぎなど"],
["https://abema.tv/video/title/54-66", "進化の実～知らないうちに勝ち組人生～"],
["https://abema.tv/video/title/6-3", "やくならマグカップも 二番窯"],
["https://abema.tv/video/title/168-33", "でーじミーツガール"],
["https://abema.tv/video/title/420-47", "テスラノート"],
["https://abema.tv/video/title/19-80", "メガトン級ムサシ"],
["https://abema.tv/video/title/54-65", "キミとフィットボクシング"],
["https://abema.tv/video/title/172-48", "シキザクラ"],
["https://abema.tv/video/title/115-84", "ポプテピピック 再放送(リミックス版)"],
["https://abema.tv/video/title/25-180", "Deep Insanity THE LOST CHILD"],
["https://abema.tv/video/title/26-152", "ビルディバイド -#000000- 第1期"],
["https://abema.tv/video/title/26-151", "ヴィジュアルプリズン"]]


CSV.open("abema.csv", "w") do |file|
  array.each do |row|
    file << row
  end
end