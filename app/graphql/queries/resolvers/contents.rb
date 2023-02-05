module Queries
  module Resolvers
    class Contents < GraphQL::Schema::Resolver
      type [Types::ContentType], null: false
      description "Contentの一覧取得"

      def resolve
        ::Content.all
      end
    end
  end
end
