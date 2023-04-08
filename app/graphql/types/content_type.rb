# frozen_string_literal: true

module Types
  class ContentType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :url, String, null: false
    field :stream, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :registered, Boolean, null: false
    field :master_id, Integer
    field :new_flag, Boolean, null: false
    field :episode, Integer
    field :line_flag, Boolean, null: false
    field :media, Integer, null: false
  end
end
