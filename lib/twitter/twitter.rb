require 'oauth'
require 'json'
require 'twitter'

module Twitter
  class Twitter

    attr_accessor :token, :sectet

    def initialize(token_s, secret_s)
      @token, @secret = token_s, secret_s
      @access_token = prepare_access_token(token_s, secret_s)
    end

    def prepare_access_token(oauth_token, oauth_token_secret)
      consumer = OAuth::Consumer.new("J6S7DbeFeqBOWeIEuvcBfg", "UBgMe3EtiEMQQKQ5WDM3iieOuH7PqqolTvEUFrqQU",
                                        { :site => "http://api.twitter.com",
                                          :scheme => :header
                                        })
      token_hash = { :oauth_token => oauth_token,
                     :oauth_token_secret => oauth_token_secret
                   }
      access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    end


    def home_time_line(count)
      response = @access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=#{count}")
      json_posts = JSON.parse(response.body)
      posts = Array.new

      json_posts.each do |post|
        posts << post["text"]
      end

      posts
    end

    def friends_list
      cursor = -1

      friends = Array.new

      begin
        response = @access_token.request(:get, "https://api.twitter.com/1.1/friends/list.json?cursor=#{cursor}")
        parsed_response = JSON.parse(response.body)
        #puts parsed_response
        users = parsed_response["users"]
        cursor = parsed_response["next_cursor"]

        friends = Array.new
        users.each do |user_d|
          user = User.new(user_d["name"])
          friends << user
        end

      end while users.empty?

      friends
    end

    def post(message)
      response = @access_token.post("https://api.twitter.com/1/statuses/update.json", {:status => message,
                                                                                       :trim_user => true,
                                                                                       :include_entities => true})
      parsed_response =  JSON.parse(response.body)
      id  = parsed_response["id"].to_i
    end


 end

end
