# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DNS"]
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.enable_tracing = true
  config.environment = Rails.env
end
