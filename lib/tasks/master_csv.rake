require 'csv'
require 'aws-sdk-s3'

bucket = 'subani'.freeze
region = 'ap-northeast-1'.freeze
key = "master.csv"

s3 = Aws::S3::Client.new(
  region: region,
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
)

namespace :master_csv do
  desc 'MasterモデルをCSV出力してS3にアップロード'
  task export: :environment do
    p "#{Time.current}:export処理を開始します"

    masters = Master.all

    CSV.open("master.csv", "w") do |csv|
      column_names = %w[id title media url stream update_day episode dummy_episode season rank]
      csv << column_names
      masters.each do |master|
        column_values = [
          master.id,
          master.title,
          master.media,
          master.url,
          master.stream,
          master.update_day,
          master.episode,
          master.dummy_episode,
          master.season,
          master.rank
        ]
        csv << column_values
      end
    end

    s3.put_object(bucket: bucket,
                  key: key,
                  body: File.open(key, :encoding => "UTF-8"),
                  content_type: 'text/csv',
                )

    p "#{Time.current}:export処理が終了しました"
  end

  desc 'S3からHerokuのMaster更新とLINE通知'
  task import_with_line: :environment do
    include Day
    month = this_month

    p "#{Time.current}:import処理を開始します"

    masters = Master.all

    file = s3.get_object(bucket: bucket, key: key).body.read
    lines = CSV.parse(file)

    keys = lines[0]
    data = lines[1...].map { |line| keys.zip(line).to_h }

    lists = []

    data.each do |row|
      lists << {
        id: row["id"].to_i,
        title: row["title"],
        media: row["media"],
        url: row["url"],
        stream: row["stream"],
        update_day: row["update_day"],
        episode: row["episode"].to_i,
        dummy_episode: row["dummy_episode"].to_i,
        season: row["season"],
        rank: row["rank"].to_i
      }
    end

    # Master更新
    lists.each do |list|
      if Master.find_by(id: list[:id]).present?
        target = Master.find(list[:id])
        new_episode = list[:episode]
        if target.episode < new_episode
          target.update(episode: new_episode)
          p "Master: #{list[:title]}を#{list[:episode]}話に更新しました"
        end
      else
        Master.create(
          id: list[:id],
          title: list[:title],
          media: list[:media],
          url: list[:url],
          stream: list[:stream],
          update_day: list[:update_day],
          episode: list[:episode],
          dummy_episode: list[:dummy_episode],
          season: list[:season],
          rank: list[:rank]
        )
      end
    end

    # LINE通知
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV.fetch("LINE_CHANNEL_ID", nil)
      config.channel_secret =ENV.fetch("LINE_CHANNEL_SECRET", nil)
      config.channel_token = ENV.fetch("LINE_CHANNEL_TOKEN", nil)
    end

    # 課金防止のためプッシュ通知を1000件以内に制限
    line_notification = LineNotification.new
    line_notification.total_count = LineNotification.monthly_total.size

    catch(:exit) do
      masters.each do |master|
        @contents = Content.where(master_id: master.id, line_flag: true)
        next if @contents.empty?

        @contents.each do |content|
          next unless content.episode < master.episode

          line_users = content.users.where.not(uid: nil)
          line_users.each do |user|
            if line_notification.can_notify?
              message = {
                type: 'text',
                text: "#{master.title}の#{master.episode}話が公開されました！\n#{master.url}"
              }
              client.push_message(user.uid, message) unless Rails.env.test?
              LineNotification.create_record(master, month)
              p "LINE通知:#{content.title}をuser_id:#{user.id}さんに送信しました"
              line_notification.total_count += 1
            else
              throw :exit
            end
          end
        end
      end
    end

    # Content更新
    masters.each do |master|
      @contents = Content.where(master_id: master.id)
      if @contents.present?
        @contents.each do |content|
          if content.episode < master.episode
            content.update(episode: master.episode, new_flag: true)
            p "Content: #{content.title}を#{content.episode}話に更新しました"
          end
        end
      end
    end

    p "#{Time.current}:import処理が完了しました"
  end
end