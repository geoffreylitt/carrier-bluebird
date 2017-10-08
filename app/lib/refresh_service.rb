class RefreshService
  # Twitter gives us 800 tweets on the home timeline.
  # At the max of 200 tweets per request, we can get all 800 each hour.
  # If there were more than 800 in the past hour, we lose some.
  # (In the future we could handle this case through more frequent refreshes)
  NUM_REQUESTS = 4
  TWEETS_PER_REQUEST = 200

  def initialize
    @client = get_client
  end

  def refresh_tweets
    NUM_REQUESTS.times do
      max_id = Tweet.minimum(:twitter_id)
      since_id = Tweet.maximum(:twitter_id)

      puts "refreshing with (max_id #{max_id}, since_id #{since_id})"

      options = { count: TWEETS_PER_REQUEST }

      options.merge!({ max_id: max_id }) if max_id.present?
      options.merge!({ since_id: since_id }) if max_id.present?

      tweets = @client.home_timeline(options)

      puts "saving #{tweets.length} tweets"

      break if tweets.length == 0

      tweets.each do |tweet|
        # Slow to do this check once per tweet, but fast enough for now
        unless Tweet.find_by(twitter_id: tweet.id).present?
          Tweet.create!(
            raw_data: tweet.to_h,
            twitter_id: tweet.id,
            created_at: tweet.created_at,
            synced_at: Time.now
          )
        end
      end
    end
  end

  private

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
  end
end
