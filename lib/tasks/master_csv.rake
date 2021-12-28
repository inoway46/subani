require 'csv'
require 'aws-sdk-s3'

namespace :master_csv do
  desc 'MasterモデルをCSV出力してS3にアップロード'
  task export: :environment do
    #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：export処理を開始します"

    masters = Master.all

    CSV.open("master.csv", "w") do |csv|
      column_names = %w(id title media url stream update_day episode season rank)
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
          master.season,
          master.rank
        ]
        csv << column_values
      end
    end

    bucket = 'subani'.freeze
    region = 'ap-northeast-1'.freeze
    csv_file = "master.csv"

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    s3.put_object(bucket: bucket,
                  key: csv_file,
                  body: File.open(csv_file, :encoding => "UTF-8"),
                  content_type: 'text/csv',
                )

    #cron.logで実行確認のため時刻を表示
    p "#{Time.current}：export処理が終了しました"
  end

  desc 'S3からmaster.csvをインポートしてherokuDBのエピソード更新'
  task import: :environment do
    #heroku logsで実行確認のため時刻を表示
    p "#{Time.current}：import処理を開始します"

    masters = Master.all

    bucket = 'subani'.freeze
    region = 'ap-northeast-1'.freeze
    key = "master.csv"

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    file = s3.get_object(bucket: bucket, key: key)
    lines = CSV.parse(file.body.read)

    keys = lines[0]
    data = lines[1...].map { |line| Hash[keys.zip(line)] }

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
        season: row["season"],
        rank: row["rank"].to_i
      }
    end

    lists.each do |list|
      if Master.find_by(id: list[:id]).present?
        target = Master.find(list[:id])
        new_episode = list[:episode]
        if target.episode < new_episode
          target.update!(episode: new_episode)
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
          season: list[:season],
          rank: list[:rank]
        )
      end
    end

    masters.each do |master|
      @contents = Content.where(master_id: master.id)
      if @contents.present?
        @contents.each do |content|
          content.update(new_flag: true) if content.episode < master.episode
          content.update!(episode: master.episode)
          p "Content: #{content.title}を#{content.episode}話に更新しました"
        end
      end
    end

    #heroku logsで実行確認のため時刻を表示
    p "#{Time.current}：import処理が完了しました"
  end

  desc 'S3にCSVをアップロード'
  task upload_s3: :environment do
    bucket = 'subani'.freeze
    region = 'ap-northeast-1'.freeze
    csv_file = "master.csv"

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    s3.put_object(bucket: bucket,
                  key: csv_file,
                  body: File.open(csv_file, :encoding => "UTF-8"),
                  content_type: 'text/csv',
                )
  end

  desc 'master.csvをローカルDBにインポート'
  task local_import: :environment do
    lists = []

    CSV.foreach("master.csv", headers: true) do |row|
      lists << {
        id: row["id"].to_i,
        title: row["title"],
        media: row["media"],
        url: row["url"],
        stream: row["stream"],
        update_day: row["update_day"],
        episode: row["episode"].to_i,
        season: row["season"],
        rank: row["rank"].to_i
      }
    end

    lists.each do |list|
      if Master.find_by(id: list[:id]).present?
        target = Master.find(list[:id])
        target.update(title: list[:title],
                      media: list[:media],
                      url: list[:url],
                      stream: list[:stream],
                      update_day: list[:update_day],
                      episode: list[:episode],
                      season: list[:season],
                      rank: list[:rank]
                    )
      else
        Master.create(
          id: list[:id],
          title: list[:title],
          media: list[:media],
          url: list[:url],
          stream: list[:stream],
          update_day: list[:update_day],
          episode: list[:episode],
          season: list[:season],
          rank: list[:rank]
        )
      end
    end
  end

  desc 'ローカルDBのMasterをすべてHerokuにインポート'
  task heroku_all_import: :environment do

    bucket = 'subani'.freeze
    region = 'ap-northeast-1'.freeze
    key = "master.csv"

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    file = s3.get_object(bucket: bucket, key: key)
    lines = CSV.parse(file.body.read)
    keys = lines[0]
    data = lines[1...].map { |line| Hash[keys.zip(line)] }

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
        season: row["season"],
        rank: row["rank"].to_i
      }
    end

    lists.each do |list|
      if Master.find_by(id: list[:id]).present?
        target = Master.find(list[:id])
        target.update(title: list[:title],
                      media: list[:media],
                      url: list[:url],
                      stream: list[:stream],
                      update_day: list[:update_day],
                      episode: list[:episode],
                      season: list[:season],
                      rank: list[:rank]
                    )
      else
        Master.create(
          id: list[:id],
          title: list[:title],
          media: list[:media],
          url: list[:url],
          stream: list[:stream],
          update_day: list[:update_day],
          episode: list[:episode],
          season: list[:season],
          rank: list[:rank]
        )
      end
    end
  end

  desc 'S3からHerokuのMaster更新とLINE通知'
  task import_with_line: :environment do
    #heroku logsで実行確認のため時刻を表示
    p "#{Time.current}：import処理を開始します"

    masters = Master.all

    bucket = 'subani'.freeze
    region = 'ap-northeast-1'.freeze
    key = "master.csv"

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    file = s3.get_object(bucket: bucket, key: key)
    lines = CSV.parse(file.body.read)

    keys = lines[0]
    data = lines[1...].map { |line| Hash[keys.zip(line)] }

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
        season: row["season"],
        rank: row["rank"].to_i
      }
    end

    #Master更新
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
          season: list[:season],
          rank: list[:rank]
        )
      end
    end

    #LINE通知
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

    masters.each do |master|
      @contents = Content.where(master_id: master.id, line_flag: true)
      if @contents.present?
        @contents.each do |content|
          if content.episode < master.episode
            line_users = content.users.where.not(uid: nil)
            line_users.each do |user|
              message = {
                type: 'text',
                text: "#{master.title}の#{master.episode}話が公開されました！\n#{master.url}"
              }
              response = client.push_message(user.uid, message)
              p "LINE通知：#{content.title}を#{user.email}さんに送信しました"
            end
          end
        end
      end
    end

    #Content更新
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

    #heroku logsで実行確認のため時刻を表示
    p "#{Time.current}：import処理が完了しました"
  end
end