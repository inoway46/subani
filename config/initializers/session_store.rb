app_name = "subani"
Rails.application.config.session_store :cookie_store, key: "_#{app_name}_session", expire_after: 1.day