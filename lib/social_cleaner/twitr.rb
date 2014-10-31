require 'twitter'
require 'time'

module SocialCleaner

  class Twitr

<<<<<<< HEAD
    attr_accessor :consumer_token, :consumer_secret, :access_token, :access_secret, :delete_after_days, :expire_ids
=======
    attr_accessor :delete_after_days, :expire_before, :tweet_ids
>>>>>>> 793fcede78a6c5cd2944e6b85b1f1a50847bac59

    def initialize(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
      self.delete_after_days = delete_after_days
      self.expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
      self.tweet_ids = []

<<<<<<< HEAD
    def delete_messages
      configure_client

      expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
      self.expire_ids = []

      puts "Expiring all Twitter updates prior to #{expire_before.to_s}."

      # Now we'll sort the array, this will have the affect of putting the oldest items first in
      # the list to be deleted.
      expire_ids.sort!

      puts "Deleting #{expire_ids.length} tweets."
=======
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
>>>>>>> 793fcede78a6c5cd2944e6b85b1f1a50847bac59

    def destroy_tweets
      self.tweet_ids.each do |delete_status|
        puts "Deleting #{delete_status}..."
        Twitter.status_destroy(delete_status)
      end
    end

  private

    def configure_client
      Twitter.configure do |config|
        config.consumer_key = consumer_token
        config.consumer_secret = consumer_secret
        config.oauth_token = access_token
        config.oauth_token_secret = access_secret
      end
    end

    def fetch_tweets(expire_before)
      Twitter.user_timeline(count: 200).each do |status|
        if status[:created_at] < expire_before
          puts "Queueing delete status ID #{status[:id]} created at #{status[:created_at]}  (#{status[:text]})."
          self.expire_ids.push(status[:id])
        end
      end
    end

    def delete_tweets

    end
  end
end

