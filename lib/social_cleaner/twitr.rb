require 'twitter'
require 'time'

module SocialCleaner

  class Twitr

    attr_accessor :delete_after_days, :expire_before, :tweet_ids

    def initialize(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
      self.delete_after_days = delete_after_days
      self.expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
      self.tweet_ids = []

      Twitter.configure do |config|
        config.consumer_key = consumer_token
        config.consumer_secret = consumer_secret
        config.oauth_token = access_token
        config.oauth_token_secret = access_secret
      end
    end

    def delete_messages
      puts "Expiring all Twitter updates prior to #{expire_before.to_s}."

      fetch_tweets

      puts "Deleting #{tweet_ids.length} tweets."

      destroy_tweets
    end

  private

    def fetch_tweets
      Twitter.user_timeline(count: 200).each do |status|
        if status[:created_at] < expire_before
          puts "Queueing delete status ID #{status[:id]} created at #{status[:created_at]}  (#{status[:text]})."
          self.tweet_ids.push(status[:id])
        end
      end

      self.tweet_ids.sort!
    end

    def destroy_tweets
      self.tweet_ids.each do |delete_status|
        puts "Deleting #{delete_status}..."
        Twitter.status_destroy(delete_status)
      end
    end
  end
end

