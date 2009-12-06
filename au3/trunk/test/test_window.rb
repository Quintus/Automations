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

class WindowTest < Test::Unit::TestCase
  
  THREADS = []
  
  def self.startup
    AutoItX3.opt("WinTitleMatchMode", 2)
  end
  
  def self.shutdown
    THREADS.each{|t| t.join}
  end
  
  def setup
    @pid = AutoItX3.run("mspaint")
    AutoItX3::Window.wait("Paint")
    @win = AutoItX3::Window.new("Paint")
  end
  
  def teardown
    @win.kill
  end
  
  def test_exists
    assert_true(AutoItX3::Window.exists?(@win.title))
  end
  
  def test_activate
    pid = AutoItX3.run("calc")
    THREADS << Thread.new{sleep 3; AutoItX3.kill_process(pid)}
    sleep 1
    assert_equal(false, @win.active?)
    @win.activate
    sleep 1
    assert_true(@win.active?)
  end
  
  def test_states
    @win.state = AutoItX3::Window::SW_MINIMIZE
    sleep 1
    assert_true(@win.minimized?)
    @win.state = AutoItX3::Window::SW_RESTORE
    sleep 1
    assert_equal(false, @win.minimized?)
    @win.state = AutoItX3::Window::SW_MAXIMIZE
    sleep 1
    assert_true(@win.maximized?)
  end
  
  def test_move_and_resize
    @win.move(37, 45, 200, 200)
    sleep 1
    assert_equal([37, 45], @win.rect[0..1])
    @win.move(0, 0, 420, 450)
    sleep 1
    assert_equal([0, 0, 420, 450], @win.rect)
  end
  
  def test_pid
    assert_equal(@pid, @win.pid)
  end
  
  def test_statusbar_text
    assert_compare(0, "<", @win.statusbar_text.size)
  end
  
  def test_text
    assert_compare(0, "<", @win.text.size)
  end
  
  def test_title
    assert_match(/Paint/, @win.title)
  end
  
  def test_to_i
    assert_equal(@win.handle.to_i(16), @win.to_i)
  end
  
  def test_transparency
    assert_equal(100, @win.transparency = 100)
    sleep 1
  end
  
  def test_visible
    assert_true(@win.visible?)
  end
  
  def test_close
    @win.close
    assert_true(@win.wait_not_active)
    assert_true(@win.wait_close)
  end
  
end