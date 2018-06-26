
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twitter_streaming_api/version"

Gem::Specification.new do |spec|
  spec.name          = "tweet_words_counter"
  spec.version       = TwitterStreamingApi::VERSION
  spec.authors       = ["Aashish Saini"]
  spec.email         = ["aashish.saini@3pillarglobal.com"]

  spec.summary       = 'Twitter streaming API (statuses/sample) to collect 5 minutes of tweets.'
  spec.description   = 'Twitter streaming API (statuses/sample) to collect 5 minutes of tweets.Obtain a total word count, filter out "stop words" (words like "and", "the", "me", etc -- useless words), and present the 10 most frequent words in those 5 minutes of tweets.Implement it so that if you had to stop the program and restart, it will pick up from the total word counts that you started from.'
  spec.homepage      = "http://www.example.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "twitter", '~> 6.2'
end
