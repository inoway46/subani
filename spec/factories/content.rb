FactoryBot.define do
  factory :content do
    title { "鬼滅の刃" }
    media { "Abemaビデオ" }
    stream { 1 }
    url { "https://abema.tv/video/title/26-150" }
    episode { 7 }
    master
  end
end
