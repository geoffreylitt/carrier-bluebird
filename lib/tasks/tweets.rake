namespace :tweets do
  desc "Refresh up to 1000 tweets"
  task refresh: :environment do
    RefreshService.new.refresh_tweets
  end
end
