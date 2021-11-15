require_relative 'boot'

require 'rails/all'
require 'graphql/client'
require 'graphql/client/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Subani
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end

  AUTH_HEADER = 'Bearer h_8hL5ksxI8u5WBOF5biD7wuBqJUTGf3XzBaULhuSzw'
  HTTP = GraphQL::Client::HTTP.new('https://api.annict.com/graphql') do
    def headers(context)
      { 'Authorization': AUTH_HEADER }
    end
  end
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
