Myflix::Application.configure do
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => "staging-drenz-myflix.herokuapp.com" }
  config.action_mailer.delivery_method = :letter_opener

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
