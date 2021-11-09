[
  ['王様ランキング', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09JBGF9W9']
  ['ジャヒー様はくじけない！', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B09BDY2V6P']
  ['無職転生 ～異世界行ったら本気だす～', 'Amazonプライム', 'https://www.amazon.co.jp/dp/B08SHW97KR']
  ['先輩がうざい後輩の話', 'Abema', 'https://abema.tv/video/title/115-83']
  ['８６―エイティシックス―', 'Abema', 'https://abema.tv/video/title/25-163']
  ['大正オトメ御伽話', 'Abema', 'https://abema.tv/video/title/189-35']
  ['白い砂のアクアトープ', 'Abema', 'https://abema.tv/video/title/194-23']
  ['ブルーピリオド', 'Netflix', 'https://www.netflix.com/title/81318842']
].each do |title, media, url|
  Content.create!(
    { title: title, media: media, url: url }
  )