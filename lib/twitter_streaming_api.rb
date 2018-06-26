require_relative "twitter_streaming_api/version"

module TwitterStreamingApi
#!/usr/bin/env ruby
  require 'twitter'
  require 'yaml'

  class FetchTweets
    # will store the values of count so that in case the program restarts it initialize the count value
    @@WORDS_COUNT = {}
    def initialize(time: 300, word_counts: @@WORDS_COUNT)

      # build option hash to load the config file and time to fetch the tweets
      # default time is 5 minutes
      options = {:config_file => 'config.yml', :time => time}

      # Load in Twitter connection info from config.yaml file.
      puts "Loading config from #{options[:config_file]} and running for #{options[:time]} seconds"
      yaml_config = YAML.load_file(options[:config_file])

      # establish connection with twitter end point
      client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = yaml_config['consumer_key']
        config.consumer_secret     = yaml_config['consumer_secret']
        config.access_token        = yaml_config['access_token']
        config.access_token_secret = yaml_config['access_token_secret']
      end

      # pick the ignore words from config yml as we will be excluding it from result list
      ignore_list = yaml_config['ignore_words'].downcase.split(',')

      # List when we're starting & ending collection of Tweets
      start_time = Time.now
      end_time = start_time + Integer(options[:time])
      puts "Analysing Twitter tweets starting at #{start_time} ending at #{end_time}"
      tweets = 0

      # Sample Tweets from Twitter stream until time is up.
      progress_show_at = Time.now
      client.sample do |object|
        current_time = Time.now
        break if current_time >= end_time
        if progress_show_at.sec != current_time.sec
          print '*'
          progress_show_at = current_time
        end

        # ignoring non-English tweets
        # Unicode could still have some weird stuff show up like 💦 so ignoring them as well
        if object.is_a?(Twitter::Tweet) && object.lang == 'en'
          tweets += 1
          words = object.text.split(' ')
          words.each do |word|
            # making case insensitive so that it will be easier to compare the values
            word.downcase!
            unless word_counts.has_key?(word)
              next if ignore_list.include?(word)
              word_counts[word] = 0
            end
            word_counts[word] += 1
          end
        end
        # assigning word count to class variable so that if instance reinitialize then we will have
        # previous count value
        @@WORDS_COUNT = word_counts
      end

      # displaying result at console
      puts "\nTop 10 words by count in #{tweets} Tweets: #{word_counts.sort_by{|word, count| count}.reverse.take(10)}"
    end
  end
end
