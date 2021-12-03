User.create!(email: 'admin@example.com', password: 'yuuya416', password_confirmation: 'yuuya416', admin: true)

amazon_list = [[1, "鬼滅の刃 遊郭編", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HZF885V", 1, 2], [2, "見える子ちゃん", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HMW859Y", 1, 5], [3, "ワールドトリガー 3rdシーズン", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J1XNY54", 1, 29], [4, "MUTEKING THE Dancing HERO", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HLFKKW6", 1, 50], [5, "闘神機ジーズフレーム", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HWSGY7L", 1, 51], [6, "月とライカと吸血姫", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HLJWTLW", 2, 20], [7, "吸血鬼すぐ死ぬ", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HLG64C3", 2, 23], [8, "逆転世界ノ電池少女", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J486BPX", 2, 28], [9, "進化の実～知らないうちに勝ち組人生～", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HQDNXC1", 2, 33], [10, "カードファイト!! ヴァンガード overDress Season2", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HQFV3FM/", 2, 52], [11, "ビルディバイド -#000000-", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J1YDMQ3", 2, 53], [12, "ヴィジュアルプリズン", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J42XTLV", 2, 54], [13, "白い砂のアクアトープ", "Amazonプライム", "https://www.amazon.co.jp/dp/B0992SSZKL", 3, 4], [14, "takt op.Destiny", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HN9XPLG", 3, 8], [15, "世界最高の暗殺者、異世界貴族に転生する", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J48HN1Q/", 3, 10], [16, "大正オトメ御伽話", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HZ9GKKX", 3, 21], [17, "プラオレ！PRIDE OF ORANGE", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HRH31RC", 3, 31], [18, "かぎなど", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J7NNZ95/", 3, 32], [19, "やくならマグカップも 二番窯", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HM78VGJ", 3, 34], [20, "チキップダンサーズ", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HN92DCX", 3, 55], [21, "ディープインサニティ ザ・ロストチャイルド", "Amazonプライム", "https://www.amazon.co.jp/dp/B09JSCGQTG", 3, 56], [22, "境界戦機", "Amazonプライム", "https://www.amazon.co.jp/dp/B09J8XGTMM", 4, 35], [23, "ジャヒー様はくじけない！", "Amazonプライム", "https://www.amazon.co.jp/dp/B09BDY2V6P/", 5, 6], [24, "王様ランキング", "Amazonプライム", "https://www.amazon.co.jp/dp/B09JBGF9W9", 5, 13], [25, "プラチナエンド", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HSZT8HZ", 5, 15], [26, "SELECTION PROJECT", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HMK8CLJ", 5, 25], [27, "メガトン級ムサシ", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HJMKKQ3", 5, 44], [28, "シキザクラ", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HZ8B8D2", 5, 49], [29, "SCARLET NEXUS", "Amazonプライム", "https://www.amazon.co.jp/dp/B09891TR1L", 5, 57], [30, "SHAMAN KING（2021年版）", "Amazonプライム", "https://www.amazon.co.jp/dp/B091XQT58W", 5, 58], [31, "BanG Dream! ガルパ☆ピコ", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HV6KF7F", 5, 59], [32, "無職転生 ～異世界行ったら本気だす～ 第2クール", "Amazonプライム", "https://www.amazon.co.jp/dp/B08SHW97KR", 6, 1], [33, "異世界食堂２", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HN9R836", 6, 14], [34, "結城友奈は勇者である-大満開の章-", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HDJ5PJH", 6, 16], [35, "最果てのパラディン", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HN9K77J", 6, 19], [36, "180秒で君の耳を幸せにできるか？", "Amazonプライム", "https://www.amazon.co.jp/dp/B09JJ1LX3B", 6, 30], [37, "でーじミーツガール", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HC5MQPF", 6, 36], [38, "半妖の夜叉姫 -戦国御伽草子- 弐の章", "Amazonプライム", "https://www.amazon.co.jp/dp/B09H9R3VP7", 6, 60], [39, "ドラゴンクエスト ダイの大冒険", "Amazonプライム", "https://www.amazon.co.jp/dp/B08KL3Z92B/", 6, 61], [40, "先輩がうざい後輩の話", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HZ7218D", 7, 3], [41, "86 -エイティシックス- 第2期", "Amazonプライム", "https://www.amazon.co.jp/dp/B092M1WW6Q/", 7, 11], [42, "サクガン", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HRKG9C8", 7, 22], [43, "ルパン三世 PART6", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HYSCM1M", 7, 24], [44, "テスラノート", "Amazonプライム", "https://www.amazon.co.jp/dp/B09HJX1F88", 7, 40]]

amazon_list.each do |id, title, media, url, stream, rank|
  Master.find_or_create_by!(
    { id: id, title: title, media: media, url: url, stream: stream, rank: rank }
  )
end

abema_list = [[45, "無職転生 ～異世界行ったら本気だす～  第2部", "Abemaビデオ", "https://abema.tv/video/title/149-11", 7, 1], [46, "先輩がうざい後輩の話", "Abemaビデオ", "https://abema.tv/video/title/115-83", 7, 3], [47, "見える子ちゃん", "Abemaビデオ", "https://abema.tv/video/title/54-63", 2, 5], [48, "takt op.Destiny", "Abemaビデオ", "https://abema.tv/video/title/536-2", 6, 8], [49, "世界最高の暗殺者、異世界貴族に転生する", "Abemaビデオ", "https://abema.tv/video/title/25-182", 4, 10], [50, "86―エイティシックス― 第2クール", "Abemaビデオ", "https://abema.tv/video/title/25-163", 7, 11], [51, "異世界食堂2", "Abemaビデオ", "https://abema.tv/video/title/194-25", 6, 14], [52, "プラチナエンド", "Abemaビデオ", "https://abema.tv/video/title/19-81", 5, 15], [53, "結城友奈は勇者である 大満開の章", "Abemaビデオ", "https://abema.tv/video/title/189-34", 7, 16], [54, "最果てのパラディン", "Abemaビデオ", "https://abema.tv/video/title/54-64", 7, 19], [55, "大正オトメ御伽話", "Abemaビデオ", "https://abema.tv/video/title/189-35", 6, 21], [56, "月とライカと吸血姫", "Abemaビデオ", "https://abema.tv/video/title/420-48", 2, 20], [57, "サクガン", "Abemaビデオ", "https://abema.tv/video/title/198-8", 1, 22], [58, "吸血鬼すぐ死ぬ", "Abemaビデオ", "https://abema.tv/video/title/149-14", 2, 23], [59, "ルパン三世 PART6", "Abemaビデオ", "https://abema.tv/video/title/172-47", 7, 24], [60, "SELECTION PROJECT", "Abemaビデオ", "https://abema.tv/video/title/25-179", 6, 25], [61, "逆転世界ノ電池少女", "Abemaビデオ", "https://abema.tv/video/title/25-181", 5, 28], [62, "ワールドトリガー 3rdシーズン", "Abemaビデオ", "https://abema.tv/video/title/5-27", 2, 29], [63, "プラオレ！～PRIDE OF ORANGE～", "Abemaビデオ", "https://abema.tv/video/title/481-7", 4, 31], [64, "かぎなど", "Abemaビデオ", "https://abema.tv/video/title/283-19", 3, 32], [65, "進化の実～知らないうちに勝ち組人生～", "Abemaビデオ", "https://abema.tv/video/title/54-66", 3, 33], [66, "やくならマグカップも 二番窯", "Abemaビデオ", "https://abema.tv/video/title/6-3", 4, 34], [67, "でーじミーツガール", "Abemaビデオ", "https://abema.tv/video/title/168-33", 1, 36], [68, "テスラノート", "Abemaビデオ", "https://abema.tv/video/title/420-47", 3, 40], [69, "メガトン級ムサシ", "Abemaビデオ", "https://abema.tv/video/title/19-80", 6, 44], [70, "キミとフィットボクシング", "Abemaビデオ", "https://abema.tv/video/title/54-65", 6, 46], [71, "シキザクラ", "Abemaビデオ", "https://abema.tv/video/title/172-48", 5, 49], [72, "ポプテピピック 再放送(リミックス版)", "Abemaビデオ", "https://abema.tv/video/title/115-84", 7, 50], [73, "Deep Insanity THE LOST CHILD", "Abemaビデオ", "https://abema.tv/video/title/25-180", 3, 51], [74, "ビルディバイド -#000000- 第1期", "Abemaビデオ", "https://abema.tv/video/title/26-152", 7, 52], [75, "ヴィジュアルプリズン", "Abemaビデオ", "https://abema.tv/video/title/26-151", 6, 53], [76, "MUTEKING THE Dancing HERO", "Abemaビデオ", "https://abema.tv/video/title/19-79", 2, 54], [77, "月曜日のたわわ2", "Abemaビデオ", "https://abema.tv/video/title/11-40", 2, 26], [78, "カードファイト!! ヴァンガード overDress Season2", "Abemaビデオ", "https://abema.tv/video/title/283-18", 2, 55], [79, "鬼滅の刃 遊郭編", "Abemaビデオ", "https://abema.tv/video/title/26-150", 2, 2], [80, "がんばれ同期ちゃん", "Abemaビデオ", "https://abema.tv/video/title/11-41", 2, 27], [81, "ジャヒー様はくじけない！", "Abemaビデオ", "https://abema.tv/video/title/194-24", 5, 4], [82, "SHAMAN KING（2021年版）", "Abemaビデオ", "https://abema.tv/video/title/115-77", 5, 56], [83, "白い砂のアクアトープ", "Abemaビデオ", "https://abema.tv/video/title/194-23", 5, 6], [84, "ドラゴンクエスト ダイの大冒険", "Abemaビデオ", "https://abema.tv/video/title/5-25", 7, 57]]

abema_list.each do |id, title, media, url, stream, rank|
  Master.find_or_create_by!(
    { id: id, title: title, media: media, url: url, stream: stream, rank: rank }
  )
end
