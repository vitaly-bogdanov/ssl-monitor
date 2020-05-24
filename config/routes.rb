require "sidekiq/web"
require 'sidekiq-scheduler/web'
Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    sidekiq_username = ::Digest::SHA256.hexdigest(Rails.application.credentials.sidekiq[:user_name])
    sidekiq_password = ::Digest::SHA256.hexdigest(Rails.application.credentials.sidekiq[:user_password])
    username_hash = ::Digest::SHA256.hexdigest(username)
    password_hash = ::Digest::SHA256.hexdigest(password)
    ActiveSupport::SecurityUtils.secure_compare(username_hash, sidekiq_username) & 
      ActiveSupport::SecurityUtils.secure_compare(password_hash, sidekiq_password)
  end
  mount Sidekiq::Web, at: "/sidekiq"
  get '/status', to: 'api/v1/domains#status'
  post '/domain', to: 'api/v1/domains#domain'
end