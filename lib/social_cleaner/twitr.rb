require 'twitter'
require 'time'

module SocialCleaner

  class Twitr

    attr_accessor :consumer_token, :consumer_secret, :access_token, :access_secret, :delete_after_days

    def initialize(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
      self.consumer_token = consumer_token
      self.consumer_secret = consumer_secret
      self.access_token = access_token
      self.access_secret = access_secret
      self.delete_after_days = delete_after_days
    end

    def delete_messages
      Twitter.configure do |config|
        config.consumer_key = consumer_token
        config.consumer_secret = consumer_secret
        config.oauth_token = access_token
        config.oauth_token_secret = access_secret
      end

      expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
      expire_ids = []

      puts "Expiring all Twitter updates prior to #{expire_before.to_s}."

      Twitter.user_timeline(count: 200).each do |status|
        if status[:created_at] < expire_before
          puts "Queueing delete status ID #{status[:id]} created at #{status[:created_at]}  (#{status[:text]})."
          expire_ids.push(status[:id])
        end
      end

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
  end
end

