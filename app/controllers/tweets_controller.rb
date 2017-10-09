class TweetsController < ApplicationController
  def index
    if params[:live] == "true"
      tweets = Tweet.all
    else
      tweets =
        Tweet.where("created_at < ?", Date.today.in_time_zone("US/Eastern"))
    end

    @tweets = tweets.order(created_at: :desc).limit(100)
    gon.tweet_ids = @tweets.map(&:twitter_id).map(&:to_s)
    @metadata = params[:metadata] == "true"
  end
end
