#Encoding: Windows-1252
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require_relative "../lib/au3"
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class ControlTest < Test::Unit::TestCase
  
  def setup
    AutoItX3::Window.new(AutoItX3::Window::DESKTOP_WINDOW).activate #Needed, because Win+R is "eaten" by a console window
    AutoItX3.send_keys("#r")
    sleep 1 #I can't ise Window.wait here, because the window has a different title in different languages
    @run_window = AutoItX3::Window.new(AutoItX3::Window::ACTIVE_WINDOW)
    @edit = AutoItX3::Edit.from_control(@run_window.focused_control)
  end
  
  def teardown
    @run_window.close
  end
  
  def test_from_control
    AutoItX3.send_keys("Test")
    assert_equal("Test", @edit.text)
  end
  
  def test_new
    AutoItX3.send_keys("Test")
    edit = AutoItX3::Edit.new(@run_window.title, "", "Edit1")
    assert_equal("Test", edit.text)
  end
  
  def test_disable
    @edit.disable
    sleep 0.2
    assert(!@edit.enabled?)
    sleep 1
    @edit.enable
    sleep 0.2
    assert(@edit.enabled?)
  end
  
  def test_hide
    @edit.hide
    sleep 0.2
    assert(!@edit.visible?)
    sleep 1
    @edit.show
    sleep 0.2
    assert(@edit.visible?)
  end
  
  def test_set_text
    @edit.text = "Test"
    AutoItX3.ctrl_a
    AutoItX3.ctrl_c
    assert_equal("Test", AutoItX3.cliptext)
  end
  
  def test_nonexistant
    assert_raise(AutoItX3::Au3Error){AutoItX3::Control.new(@run_window.title, "", "Nonexistant")}
  end
  
end
