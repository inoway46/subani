user1 = User.find(1)

[
  ['王様ランキング', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09JBGF9W9', 6],
  ['ジャヒー様はくじけない！', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09BDY2V6P',5],
  ['無職転生 ～異世界行ったら本気だす～', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B08SHW97KR', 7],
  ['先輩がうざい後輩の話', 'Abemaビデオ', 'https://abema.tv/video/title/115-83', 7],
  ['８６―エイティシックス―', 'Abemaビデオ', 'https://abema.tv/video/title/25-163', 7],
  ['大正オトメ御伽話', 'Abemaビデオ', 'https://abema.tv/video/title/189-35', 6],
  ['白い砂のアクアトープ', 'Abemaビデオ', 'https://abema.tv/video/title/194-23', 5],
  ['ブルーピリオド', 'Netflix', 'https://www.netflix.com/title/81318842', 7]
].each do |title, media, url, stream|
  @content = Content.create!(
    { title: title, media: media, url: url, stream: stream }
  )
  user1.contents << @content

  # User.create!(email: 'admin@example.com', password: 'yuuya416', password_confirmation: 'yuuya416', admin: true)
end