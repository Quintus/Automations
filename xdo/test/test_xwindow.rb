#!/usr/bin/env ruby
#Encoding: UTF-8
gem "test-unit", ">= 2.1" #Ensure we use the gem
require "test/unit"
require "xdo/xwindow.rb"
require "xdo/keyboard"

class WindowTest < Test::Unit::TestCase
  
  attr_accessor :xwindow
  
  #The program MUST NOT start maximized. xdotool has no possibility of 
  #acting on maximized windows. 
  NEW_WINDOW_CMD = "gedit"
  
  @@xwin = nil
  
  def self.startup
    fork{system(NEW_WINDOW_CMD)}
    XDo::XWindow.wait_for_window(Regexp.new(Regexp.escape(NEW_WINDOW_CMD)))
    @@xwin = XDo::XWindow.from_title(Regexp.new(Regexp.escape(NEW_WINDOW_CMD)))
  end
  
  def self.shutdown
    @@xwin.close!
  end
  
  def test_ewmh_active_window
    begin
      XDo::XWindow.from_active
    rescue XDo::XError
      #Standard not available
     notify $!.message
    end
  end
  
  def test_ewmh_wm_desktop
    begin
      XDo::XWindow.desktop_num
    rescue XDo::XError
      #Standard not available
      notify $!.message
    end
  end
  
  def test_ewmh_current_desktop
    begin
      XDo::XWindow.desktop
    rescue XDo::XError
      #Standard not available
      notify $!.message
    end
  end
  
  def test_exists
    assert_equal(true, XDo::XWindow.exists?(@@xwin.title))
  end
  
  def test_activate_desktop
    XDo::XWindow.activate_desktop
    assert_equal(XDo::XWindow.from_title(XDo::XWindow.desktop_name).id, XDo::XWindow.from_active.id)
    sleep 1
  end
  
  def test_active
    @@xwin.unfocus
    sleep 1
    @@xwin.activate
    assert_equal(@@xwin.id, XDo::XWindow.from_active.id)
    sleep 1
  end
  
  def test_focused
    @@xwin.unfocus
    sleep 1
    @@xwin.focus
    assert_equal(@@xwin.id, XDo::XWindow.from_focused.id)
    sleep 1
  end
  
  def test_move
    @@xwin.move(57, 57)
    assert_in_delta(50, 60, @@xwin.abs_position[0])
    assert_in_delta(50, 50, @@xwin.abs_position[1])
    assert_equal(@@xwin.abs_position, @@xwin.rel_position)
    sleep 1
  end
  
  def test_resize
    @@xwin.resize(500, 500)
    assert_equal([500, 500], @@xwin.size)
    sleep 1
  end

  def test_map
    @@xwin.unmap
    sleep 0.2
    assert_equal(nil, @@xwin.visible?)
    @@xwin.map
    sleep 0.2
    assert_block("Window is not visible."){@@xwin.visible?.kind_of?(Integer)}
    sleep 1
  end
  
end
 