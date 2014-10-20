require 'twitter'
require 'time'

module SocialCleaner

  class Twitr

    attr_accessor :consumer_token, :consumer_secret, :access_token, :access_secret, :delete_after_days, :expire_ids

    def initialize(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
      self.consumer_token = consumer_token
      self.consumer_secret = consumer_secret
      self.access_token = access_token
      self.access_secret = access_secret
      self.delete_after_days = delete_after_days
    end

    def delete_messages
      configure_client

      expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
      self.expire_ids = []

      puts "Expiring all Twitter updates prior to #{expire_before.to_s}."

      # Now we'll sort the array, this will have the affect of putting the oldest items first in
      # the list to be deleted.
      expire_ids.sort!

      puts "Deleting #{expire_ids.length} tweets."

      # Now let's delete the stuff
      # Note: the delete method is not rate limited.
      expire_ids.each do |delete_status|
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

