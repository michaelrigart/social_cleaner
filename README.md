[![Code Climate](https://codeclimate.com/github/michaelrigart/social_cleaner.png)](https://codeclimate.com/github/michaelrigart/social_cleaner)

README (draft)
======

install the gem:

gem install social_cleaner

Then make a ruby script:

#!/usr/bin/ruby
#
# Get requires out of the way
require 'social_cleaner'

cleaner = SocialCleaner::Twitr.new(consumer_token, consumer_secret, access_token, access_secret, delete_after_days)
cleaner.delete_messages


Save the file, make it executeable and run like ./script.rb or put it in a cronjob
