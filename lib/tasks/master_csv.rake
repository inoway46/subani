require 'csv'

namespace :master_csv do
  desc 'MasterモデルをCSV出力'
  task export: :environment do
    masters = Master.where(media: "Abemaビデオ")

    CSV.open("master.csv", "w") do |csv|
      column_names = %w(id title media url stream rank created_at updated_at episode)
      csv << column_names
      masters.each do |master|
        column_values = [
          master.id,
          master.title.to_s,
          master.media.to_s,
          master.url,
          master.stream,
          master.rank,
          master.created_at,
          master.updated_at,
          master.episode
        ]
        csv << column_values
      end
    end
  end

  desc 'master.csvをheroku環境にインポート'
  task import: :environment do
    masters = Master.where(media: "Abemaビデオ")
    lists = []

    CSV.foreach("master.csv", headers: true) do |row|
      lists << {
        id: row["id"],
        episode: row["episode"]
      }
    end

    masters.zip(lists) do |master, list|
      Master.find(list[:id].to_i).update!(episode: list[:episode].to_i)
      p "#{master.title}を#{list[:episode]}話に更新しました"
    end
      
  end
end
