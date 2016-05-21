module TweetsHelper
    def get_twitter_client
        return Twitter::REST::Client.new do |config|
          config.consumer_key = 'cG4nrKXzIn6OFhzSzr8YqQ'
          config.consumer_secret = '9uRIniqaRly08P091D4cveRMP3byyvZHQndMw56nw'
          config.access_token = '76392678-2lvqCZ2wV1mooneIYAxgEUyLWSpKxrcHWCgr8MUa8'
          config.access_token_secret = 'V1b3ByyyhUcOocaw5BKaG498E8ziSe1REtE61C6IP8ZzN'
        end
    end
end
