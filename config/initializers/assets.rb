# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( bootstrap.min.css )

Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( friendships/new.js )
Rails.application.config.assets.precompile += %w( landing_page/_current_user_polls.js )
Rails.application.config.assets.precompile += %w( landing_page/_friends_pane.js )
Rails.application.config.assets.precompile += %w( landing_page/_news_feed_polls.js )
Rails.application.config.assets.precompile += %w( user_polls/_form.js )
Rails.application.config.assets.precompile += %w( user_polls/results.js )
Rails.application.config.assets.precompile += %w( user_polls/user_polls.js )

