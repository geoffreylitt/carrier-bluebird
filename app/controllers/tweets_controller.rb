class TweetsController < ApplicationController
  def index
    if params[:live] == "true"
      tweets = Tweet.all
    else
      tweets = Tweet.where(
        # limit to only tweets from the previous day, in Eastern time
        "created_at < ?",
        DateTime.now.in_time_zone("US/Eastern").beginning_of_day
      )
    end

    @tweets = tweets.order(created_at: :desc).limit(100)
    gon.tweet_ids = @tweets.map(&:twitter_id).map(&:to_s)
    @metadata = params[:metadata] == "true"
  end
end
