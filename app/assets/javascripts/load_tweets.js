twttr.ready(
  function (twttr) {
    gon.tweet_ids.forEach(function(tweet_id) {
      var divId = "tweet-" + tweet_id;
      var container = document.getElementById(divId);
      twttr.widgets.createTweet(tweet_id, container);
    });
  }
);
