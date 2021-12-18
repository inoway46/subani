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

  desc "登録ユーザーのプロフィール取得"
  task profile: :environment do
    message = {
      type: 'text',
      text: 'アニメの最新話が更新されました'
    }
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
    response = client.get_profile("U2cebc69b40f59ece7e640c5b1ccaf125")
    case response
    when Net::HTTPSuccess then
      contact = JSON.parse(response.body)
      p contact['displayName']
      p contact['pictureUrl']
      p contact['statusMessage']
    else
      p "#{response.code} #{response.body}"
    end
  end

  desc "登録ユーザーのuser_id取得"
  task id: :environment do
    def get_followers(all_user_ids = [], continuation_token = nil)
      client = Line::Bot::Client.new do |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      end
      
      response = client.get_follower_ids(continuation_token)
      json = JSON.parse(response.body)
    
      puts "count: #{json["userIds"].count}"
      all_user_ids = all_user_ids + json["userIds"]
    
      if json["next"]
        puts "continuation_token: #{json["next"]}"
        sleep 1
        get_followers(all_user_ids, json["next"])
      else
        puts "done"
        return all_user_ids
      end
    end

    get_followers
  end
end
