class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    schedules_path(resource)
  end

  Query = Subani::Client.parse <<-GRAPHQL
  query {
    searchWorks(seasons: ["2021-autumn"] ,orderBy: { field: WATCHERS_COUNT, direction: DESC}, first: 50) {
      edges {
        node {
          annictId
          title
          watchersCount
          episodesCount
          satisfactionRate
          officialSiteUrl
        }
      }
    }
  }
    GRAPHQL
end
