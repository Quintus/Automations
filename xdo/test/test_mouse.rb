#!/usr/bin/env ruby
#Encoding: UTF-8
gem "test-unit", ">= 2.1" #Ensure we use the gem
require "test/unit"
require "xdo/mouse.rb"

class MouseTest < Test::Unit::TestCase
  
  def test_position
    str = `#{XDo::XDOTOOL} getmouselocation`
    xdpos = []
    xdpos << str.match(/x:\s?(\d+)/)[1]
    xdpos << str.match(/y:\s?(\d+)/)[1]
    xdpos.collect!{|o| o.to_i}
    assert_equal(xdpos, XDo::Mouse.position)
  end
  
  def test_move
    XDo::Mouse.move(200, 200)
    assert_equal([200, 200], XDo::Mouse.position)
    XDo::Mouse.move(0, 0)
    assert_equal([0, 0], XDo::Mouse.position)
    XDo::Mouse.move(0, 200)
    assert_equal([0, 200], XDo::Mouse.position)
    XDo::Mouse.move(100, 100)
    assert_equal([100, 100], XDo::Mouse.position)
  end
  
end