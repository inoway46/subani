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
        title: row["title"],
        episode: row["episode"]
      }
    end

    lists.each do |list|
      target = Master.find(list[:id].to_i)
      new_episode = list[:episode].to_i
      if target.episode < new_episode
        target.update!(episode: new_episode)
        p "Master: #{list[:title]}を#{list[:episode]}話に更新しました"
      end
    end

    masters.each do |master|
      @contents = Content.where(master_id: master.id)
      if @contents.present?
        @contents.update_all(episode: master.episode)
        p "Content: #{master.title}を#{master.episode}話に更新しました"
      end
    end
  end
end
