require_relative 'boot'

require 'rails/all'
require 'graphql/client'
require 'graphql/client/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Subani
  class Application < Rails::Application
    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]
    config.time_zone = 'Tokyo'
    config.active_job.queue_adapter = :sidekiq
    config.generators do |g|
      g.assets false
      g.helper false
      g.decorator   false
      g.skip_routes true
      g.system_tests = nil
      g.test_framework :rspec, fixtures: false, controller_specs: false, view_specs: false, helper_specs: false, routing_specs: false, request_specs: false
    end
    # config.active_record.legacy_connection_handling = true # バージョンが安定してきたらtrueにする
  end
end
