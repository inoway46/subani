FactoryBot.define do
  factory :master do
    title { "鬼滅の刃" }
    media { "Abemaビデオ" }
    stream { 1 }
    url { "https://abema.tv/video/title/26-150" }
    episode { 7 }
  end
end
