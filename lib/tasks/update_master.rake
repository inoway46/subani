require 'csv'
require 'aws-sdk-s3'

bucket = 'subani'.freeze
region = 'ap-northeast-1'.freeze
key = "master.csv"

s3 = Aws::S3::Client.new(
  region:,
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
)

def master_params(row)
  {
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

def update_master_by(lists)
  lists.each do |list|
    list_params = {
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
    }
    if Master.find_by(id: list[:id]).present?
      target = Master.find(list[:id])
      target.update(list_params)
    else
      Master.create(list_params)
    end
  end
end

namespace :update_master do
  desc 'ローカルのmaster.csvをローカルDBにインポート'
  task local_import: :environment do
    lists = []

    CSV.foreach("master.csv", headers: true) do |row|
      lists << master_params(row)
    end

    update_master_by(lists)
  end

  desc 'S3上のmaster.csvをHerokuDBにインポート'
  task heroku_import: :environment do
    file = s3.get_object(bucket:, key:)
    lines = CSV.parse(file.body.read)
    keys = lines[0]
    data = lines[1...].map { |line| keys.zip(line).to_h }

    lists = []

    data.each do |row|
      lists << master_params(row)
    end

    update_master_by(lists)
  end
end
