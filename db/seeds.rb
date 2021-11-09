[
  ['王様ランキング', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09JBGF9W9', 6],
  ['ジャヒー様はくじけない！', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09BDY2V6P',5],
  ['無職転生 ～異世界行ったら本気だす～', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B08SHW97KR', 7],
  ['先輩がうざい後輩の話', 'Abema', 'https://abema.tv/video/title/115-83', 7],
  ['８６―エイティシックス―', 'Abema', 'https://abema.tv/video/title/25-163', 7],
  ['大正オトメ御伽話', 'Abema', 'https://abema.tv/video/title/189-35', 6],
  ['白い砂のアクアトープ', 'Abema', 'https://abema.tv/video/title/194-23', 5],
  ['ブルーピリオド', 'Netflix', 'https://www.netflix.com/title/81318842', 7]
].each do |title, media, url, stream|
  Content.create!(
    { title: title, media: media, url: url, stream: stream }
  )
end