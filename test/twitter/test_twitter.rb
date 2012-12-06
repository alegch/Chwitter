require 'test_helper'

class TestTwitter <MiniTest::Unit::TestCase

  def setup
    @tw = Twitter::Twitter.new("153491448-kLp9HNAeezC4OJadQQPyobzEmlzs88VyJczGN1yP", "wYTGcqD6bObGgZfplSBQHDovLkCC06B0Au7B608pSo")
  end

  def test_home_time_line
    posts =  @tw.home_time_line(5)

    puts posts

    assert_equal posts.count, 5
  end

  def test_get_friends
    friends = @tw.friends_list

    friends.each do |user|
      puts user.name
    end

    assert_equal friends.empty?, false, "must be more nil"

  end

  def test_post
    post_id = @tw.post("first post from console twitter")
    assert_equal  post_id.zero?,  false,  "post don't posted"
  end
end
