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
            # Let's get a Twitter Client created
            oauth = Twitter::OAuth.new(consumer_token, consumer_secret)
            oauth.authorize_from_access(access_token, access_secret)

            client = Twitter::Base.new(oauth)
 
            # Expire deadline
            expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
            expire_ids = []
 
            $stderr.puts "Expiring all Twitter updates prior to #{expire_before.to_s}."
 
            # Iterate through timeline
            # The old tweet id's don't contain a timestamp. maybe implement this for later?
            timeline = client.user_timeline
            timeline.each do |status|
                if Time.parse(status["created_at"]) < expire_before
                    $stderr.puts "Queueing tweet delete status ID #{status["id"]} created at #{status["created_at"]}  (#{status["text"]})."
                    $stdout.puts "#{status["id"]}\t\t#{status["created_at"]}\t\t#{status["text"]}"
                    expire_ids.push(status["id"])
                end
            end

            retweets = client.retweeted_by_me
            retweets.each do |retweet|
                if Time.parse(status["created_at"]) < expire_before
                    $stderr.puts "Queueing retweet delete status ID #{status["id"]} created at #{status["created_at"]}  (#{status["text"]})."
                    $stdout.puts "#{status["id"]}\t\t#{status["created_at"]}\t\t#{status["text"]}"
                    expire_ids.push(status["id"])
                end
            end
 
            # Now we'll sort the array, this will have the affect of putting the oldest items first in
            # the list to be deleted.
            expire_ids.sort!
 
            $stderr.puts "Deleting #{expire_ids.length} tweets."
     
            # Now let's delete the stuff
            # Note: the delete method is not rate limited.
            expire_ids.each do |delete_status|
              $stderr.puts "Deleting #{delete_status}..."
              client.status_destroy(delete_status)
            end
        end
    end
end

