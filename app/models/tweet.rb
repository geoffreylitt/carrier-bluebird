class Tweet < ApplicationRecord
  def retweeter
    raw_data["user"]["name"]
  end
end
