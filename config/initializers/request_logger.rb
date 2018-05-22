Rails.application.config.middleware.insert_before ActionDispatch::Static, RequestLogger
