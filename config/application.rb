require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end

Raven.configure do |config|
  config.dsn = 'https://b0baf23d74394aa5ae17056feec304ab:12b66e689b664791aa0ead95c38aad98@sentry.io/236650'
end
