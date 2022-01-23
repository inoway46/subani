module Line::ResponseTitle
  extend ActiveSupport::Concern
  included do
    def answer_titles_today(anime_lists)
      answer = ""
      anime_lists.each do |anime|
        title = anime.content.title
        episode = anime.content.episode
        url = anime.content.url
        result = "\n【#{title}】\n#{url}\n#{episode}話まで配信中\n"
        answer << result
      end
      answer
    end

    def answer_titles_unwatched(anime_lists)
      answer = ""
      anime_lists.each do |anime|
        title = anime.title
        episode = anime.episode
        url = anime.url
        result = "\n【#{title}】\n#{url}\n#{episode}話まで配信中\n"
        answer << result
      end
      answer
    end
  end
end
