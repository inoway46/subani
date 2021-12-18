namespace :push_line do
  desc "プッシュ通知のテスト"
  task test: :environment do
    message = {
      type: 'text',
      text: 'アニメの最新話が更新されました'
    }
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
    response = client.push_message(ENV["LINE_USER_ID"], message)
    p response
  end
end
