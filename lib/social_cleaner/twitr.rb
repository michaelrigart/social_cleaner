module SocialCleaner

    class Twitr
 
        # parameters
        attr_accessor :consumer_token, :consumer_secret, :access_token, :access_secret, :delete_after_days

        # client object
        attr_accessor :client

        # tweet id's to be deleted
        attr_accessor :expire_ids, :expire_before


        def initialize(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
            consumer_token = consumer_token
            consumer_secret = consumer_secret
            access_token = access_token
            access_secret = access_secret
            delete_after_days = delete_after_days
            expire_ids = []
        end


        def create_client
            # Let's get a Twitter Client created
            oauth = Twitter::OAuth.new(consumer_token, consumer_secret)
            oauth.authorize_from_access(access_token, access_secret)

            client = Twitter::Base.new(oauth)
        end


        def add_tweets_to_queue(statusses)
            statusses.each do |status|
                if Time.parse(status["created_at"]) < expire_before
                    $stderr.puts "Queueing tweet delete status ID #{status["id"]} created at #{status["created_at"]}  (#{status["text"]})."
                    $stdout.puts "#{status["id"]}\t\t#{status["created_at"]}\t\t#{status["text"]}"
                    expire_ids.push(status["id"])
                end
            end
        end


        def delete_tweets
            expire_ids.each do |delete_status|
              $stderr.puts "Deleting #{delete_status}..."
              client.status_destroy(delete_status)
            end
        end


        def delete_messages
            # Create client object
            create_client

            # Expire deadline
            expire_before = Time.now - (delete_after_days * 60 * 60 * 24)
 
            $stderr.puts "Expiring all Twitter updates prior to #{expire_before.to_s}."
 
            # Iterate through timeline
            # The old tweet id's don't contain a timestamp. maybe implement this for later?
            add_tweets_to_queue(client.user_timeline)
            add_tweets_to_queue(client.retweeted_by_me) 

            # Now we'll sort the array, this will have the affect of putting the oldest items first in
            # the list to be deleted.
            expire_ids.sort!
 
            $stderr.puts "Deleting #{expire_ids.length} tweets."
     
            # Now let's delete the stuff
            # Note: the delete method is not rate limited.
            delete_tweets
        end
    end
end

