class TweetsController < ApplicationController
  def index
    @tweets = Tweet.where("created_at > ?", Time.now - 1.day)
  end
end
