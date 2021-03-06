class TweetsController < ApplicationController
  def index
    # todo:
    # * move this fat controller into a dedicated tweet fetching service
    # * generalize these sections, make it really easy to define new sections:
    #   * field
    #   * operator on that type of field (eg >, < for integers, but not strings)
    #   * value on the other end

    if current_user.present?
      tweets = Tweet.where(synced_user_id: current_user.id)
    else
      tweets = Tweet.none
    end

    unless params[:live] == "true"
      # limit to only tweets from the previous day, in Eastern time
      beginning_of_day = DateTime.now.in_time_zone("US/Eastern").beginning_of_day
      tweets = tweets.where("created_at < ?", beginning_of_day).
                      where("created_at > ?", beginning_of_day - 1.day)
    end

    @most_retweeted = tweets.order("(raw_data->>'retweet_count')::int desc").limit(20)
    @most_favorited = tweets.where.not(twitter_id: @most_retweeted.map(&:twitter_id)).order("(raw_data->>'retweet_count')::int desc").limit(20)
    @normal_people = tweets.where("(raw_data->'user'->>'followers_count')::int < 1000").limit(20)
    @other_tweets = tweets.order(created_at: :desc).limit(50)

    all_tweets = @most_retweeted + @most_favorited + @normal_people + @other_tweets

    gon.tweet_ids = all_tweets.uniq(&:twitter_id).map(&:twitter_id).map(&:to_s)
    @metadata = params[:metadata] == "true"
  end
end
