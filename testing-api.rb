client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "a6RzlXLiLAuF31zm2iPjvabMI"
  config.consumer_secret     = "f1z70dn358nKeK3GpwIPl8eNNHiEJ0JU1DDwBPPLMU44xcYWfM"
  config.access_token        = "221658618-PbK0Iu3PmUK6Cn8bSfLFO3pUFZWTiUdTe612gU4s"
  config.access_token_secret = "uNurpubTKrqEUApIcyXY7k6orTLDbYvzrAwRjdQvRiBdA"
end


def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

client.get_all_tweets("sferik")
