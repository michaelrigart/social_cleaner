require "rubygems"
require "rake"

begin
  require "jeweler"  
  Jeweler::Tasks.new do |gem|
    gem.name = "social_cleaner"
    gem.summary = "Social Cleaner"
    gem.description = "Cleans up your social messages"
    gem.rubyforge_project = "nowarning"
    gem.files = Dir["README","{lib}/**/*"]

    gem.version = "0.0.2"
    gem.author = "Michaël Rigart"
    gem.email = "michael@netronix.be"
    gem.homepage = "http://www.netronix.be"
    gem.add_dependency "twitter", "0.9.12"
  end
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or one of its dependencies is not installed."
end
